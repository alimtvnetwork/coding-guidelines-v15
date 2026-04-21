#!/usr/bin/env bash
# check-forbidden-names.sh — Pattern 01 (Forbidden-Name Guard).
#
# Reads forbidden regex patterns from CI_GUARDS_FORBIDDEN_NAMES_*
# environment variables (populated by ci-config.mjs) or from sane
# Go defaults if unset. Scans <source_dir> for matches and emits
# ::error:: annotations.
#
# Spec: spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/01-forbidden-name-guard.md
# Contract: exit 0 clean | 1 violation | 2 tool error

set -uo pipefail

readonly EXIT_OK=0
readonly EXIT_VIOLATION=1
readonly EXIT_TOOL_ERROR=2

SOURCE_DIR="${1:-${CI_GUARDS_FORBIDDEN_NAMES_SOURCE_DIR:-.}}"
FILE_GLOB="${CI_GUARDS_FORBIDDEN_NAMES_FILE_GLOB:-*.go}"

# Patterns are newline-separated when emitted by ci-config.mjs.
DEFAULT_PATTERNS=$'^func +(invoke|persist) *\\(\n^func +runOne *\\(\n^func +(invoke|persist|runOne)(Release|Task|Job|Item|All|One|Cmd) *\\('
PATTERNS="${CI_GUARDS_FORBIDDEN_NAMES_PATTERNS:-$DEFAULT_PATTERNS}"
REMEDIATION="${CI_GUARDS_FORBIDDEN_NAMES_REMEDIATION_EXAMPLES:-}"

source_dir_exists() {
  [ -d "$1" ]
}

emit_remediation() {
  if [ -z "$REMEDIATION" ]; then
    return
  fi
  printf '\nRemediation examples:\n' >&2
  printf '  %s\n' "$REMEDIATION" >&2
}

scan_pattern() {
  local pattern="$1"
  local matches
  matches=$(grep -RHnE --include="$FILE_GLOB" "$pattern" "$SOURCE_DIR" 2>/dev/null || true)
  if [ -z "$matches" ]; then
    return 0
  fi
  while IFS= read -r line; do
    local file lineno
    file=$(printf '%s' "$line" | cut -d: -f1)
    lineno=$(printf '%s' "$line" | cut -d: -f2)
    printf '::error file=%s,line=%s::forbidden name pattern matched: %s\n' \
      "$file" "$lineno" "$pattern"
  done <<< "$matches"
  return 1
}

main() {
  if ! source_dir_exists "$SOURCE_DIR"; then
    printf '::error::source directory not found: %s\n' "$SOURCE_DIR" >&2
    exit "$EXIT_TOOL_ERROR"
  fi
  local violations=0
  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    if ! scan_pattern "$pattern"; then
      violations=$((violations + 1))
    fi
  done <<< "$PATTERNS"
  if [ "$violations" -gt 0 ]; then
    emit_remediation
    exit "$EXIT_VIOLATION"
  fi
  exit "$EXIT_OK"
}

main "$@"