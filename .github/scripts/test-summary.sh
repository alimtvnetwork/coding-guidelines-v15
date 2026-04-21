#!/usr/bin/env bash
# test-summary.sh — Pattern 06 (Matrix Test Aggregator).
#
# Walks <results_dir>/<shard_pattern>/ directories, parses each shard's
# test output, and emits a unified PASS/FAIL summary with reason
# excerpts for failed cases.
#
# Spec: spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/06-matrix-test-aggregator.md
# Contract: exit 0 all green | 1 any failure | 2 tool error

set -uo pipefail

readonly EXIT_OK=0
readonly EXIT_VIOLATION=1
readonly EXIT_TOOL_ERROR=2

RESULTS_DIR="${1:-${CI_GUARDS_TEST_SUMMARY_RESULTS_DIR:-./test-artifacts}}"
SHARD_PATTERN="${CI_GUARDS_TEST_SUMMARY_SHARD_PATTERN:-test-results-*}"
OUTPUT_FILENAME="${CI_GUARDS_TEST_SUMMARY_OUTPUT_FILENAME:-test-output.txt}"
PASS_MARKER="${CI_GUARDS_TEST_SUMMARY_PASS_MARKER:-^--- PASS:}"
FAIL_MARKER="${CI_GUARDS_TEST_SUMMARY_FAIL_MARKER:-^--- FAIL:}"
REASON_KEYWORDS="${CI_GUARDS_TEST_SUMMARY_REASON_KEYWORDS:-expected|got|Error|FAIL|panic|undefined|mismatch}"
REASON_MAX_LINES="${CI_GUARDS_TEST_SUMMARY_REASON_MAX_LINES:-10}"
SUMMARY_OUT="${GITHUB_STEP_SUMMARY:-/dev/stdout}"

results_dir_exists() {
  [ -d "$1" ]
}

count_marker() {
  local file="$1"
  local marker="$2"
  grep -cE "$marker" "$file" 2>/dev/null || true
}

extract_reasons() {
  local file="$1"
  grep -E "$REASON_KEYWORDS" "$file" 2>/dev/null \
    | head -n "$REASON_MAX_LINES" || true
}

emit_shard_summary() {
  local shard="$1"
  local pass_count="$2"
  local fail_count="$3"
  printf '| %s | %s | %s |\n' "$shard" "$pass_count" "$fail_count" >> "$SUMMARY_OUT"
}

emit_failure_block() {
  local shard="$1"
  local file="$2"
  printf '\n#### Failures in %s\n\n```\n' "$shard" >> "$SUMMARY_OUT"
  extract_reasons "$file" >> "$SUMMARY_OUT"
  printf '```\n' >> "$SUMMARY_OUT"
}

process_shard() {
  local shard_dir="$1"
  local shard
  shard=$(basename "$shard_dir")
  local file="$shard_dir/$OUTPUT_FILENAME"
  if [ ! -f "$file" ]; then
    printf '::warning::missing %s in %s\n' "$OUTPUT_FILENAME" "$shard"
    return 0
  fi
  local pass_count fail_count
  pass_count=$(count_marker "$file" "$PASS_MARKER")
  fail_count=$(count_marker "$file" "$FAIL_MARKER")
  emit_shard_summary "$shard" "$pass_count" "$fail_count"
  if [ "$fail_count" -gt 0 ]; then
    emit_failure_block "$shard" "$file"
    return 1
  fi
  return 0
}

main() {
  if ! results_dir_exists "$RESULTS_DIR"; then
    printf '::error::results directory not found: %s\n' "$RESULTS_DIR" >&2
    exit "$EXIT_TOOL_ERROR"
  fi
  printf '## Test summary\n\n| Shard | PASS | FAIL |\n|-------|------|------|\n' \
    >> "$SUMMARY_OUT"
  local any_fail=0
  local found=0
  for shard_dir in "$RESULTS_DIR"/$SHARD_PATTERN; do
    [ -d "$shard_dir" ] || continue
    found=1
    if ! process_shard "$shard_dir"; then
      any_fail=1
    fi
  done
  if [ "$found" -eq 0 ]; then
    printf '::warning::no shards matched %s in %s\n' \
      "$SHARD_PATTERN" "$RESULTS_DIR" >&2
    exit "$EXIT_OK"
  fi
  if [ "$any_fail" -eq 1 ]; then
    exit "$EXIT_VIOLATION"
  fi
  exit "$EXIT_OK"
}

main "$@"