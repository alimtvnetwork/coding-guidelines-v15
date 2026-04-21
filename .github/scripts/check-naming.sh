#!/usr/bin/env bash
# check-naming.sh — Pattern 02 (Grandfather-Baseline Naming).
#
# Compares identifiers extracted from <source_dir> against a frozen
# baseline file. New identifiers must match an allowed-prefix regex.
#
# Spec: spec/12-cicd-pipeline-workflows/03-reusable-ci-guards/02-grandfather-baseline-naming.md
# Contract: exit 0 clean | 1 violation | 2 tool error
#
# Modes:
#   bash check-naming.sh                        -> gate mode
#   bash check-naming.sh --regenerate-baseline  -> rewrite baseline

set -uo pipefail

readonly EXIT_OK=0
readonly EXIT_VIOLATION=1
readonly EXIT_TOOL_ERROR=2

SOURCE_DIR="${CONST_DIR:-${CI_GUARDS_NAMING_BASELINE_SOURCE_DIR:-.}}"
BASELINE="${BASELINE_FILE:-${CI_GUARDS_NAMING_BASELINE_BASELINE_FILE:-.github/scripts/constants-baseline.txt}}"
ALLOWED_PREFIX="${CI_GUARDS_NAMING_BASELINE_ALLOWED_PREFIX_REGEX:-^(Cmd|Msg|Err|Flag|Default)}"
RENAME_EXAMPLES="${CI_GUARDS_NAMING_BASELINE_RENAME_EXAMPLES:-}"

MODE="gate"
if [ "${1:-}" = "--regenerate-baseline" ]; then
  MODE="regenerate"
fi

source_dir_exists() {
  [ -d "$1" ]
}

# Extracts top-level Go const identifiers, raw-string aware.
# mawk-portable (uses 2-arg match + RSTART/RLENGTH only).
extract_identifiers() {
  local dir="$1"
  awk '
    BEGIN { in_const = 0; in_rawstr = 0 }
    {
      line = $0
      n = length(line)
      for (i = 1; i <= n; i++) {
        c = substr(line, i, 1)
        if (c == "`") { in_rawstr = 1 - in_rawstr }
      }
      if (in_rawstr) { next }
      if (match(line, /^[[:space:]]*const[[:space:]]*\(/)) { in_const = 1; next }
      if (in_const && match(line, /^[[:space:]]*\)/))      { in_const = 0; next }
      if (in_const) {
        if (match(line, /[A-Z][A-Za-z0-9_]*/)) {
          name = substr(line, RSTART, RLENGTH)
          print name
        }
        next
      }
      if (match(line, /^const[[:space:]]+[A-Z][A-Za-z0-9_]*/)) {
        s = substr(line, RSTART, RLENGTH)
        sub(/^const[[:space:]]+/, "", s)
        print s
      }
    }
  ' "$dir"/*.go 2>/dev/null | LC_ALL=C sort -u
}

find_declaration_location() {
  local name="$1"
  grep -RHnE "(^|[[:space:]])${name}[[:space:]]*=" "$SOURCE_DIR" 2>/dev/null \
    | head -n 1 || true
}

emit_rename_examples() {
  if [ -z "$RENAME_EXAMPLES" ]; then
    return
  fi
  printf '\nRename examples:\n' >&2
  printf '  %s\n' "$RENAME_EXAMPLES" >&2
}

regenerate_baseline() {
  mkdir -p "$(dirname "$BASELINE")"
  extract_identifiers "$SOURCE_DIR" > "$BASELINE"
  printf 'Baseline regenerated: %s (%d identifiers)\n' \
    "$BASELINE" "$(wc -l < "$BASELINE")"
  exit "$EXIT_OK"
}

gate_check() {
  if [ ! -f "$BASELINE" ]; then
    printf '::error::baseline file not found: %s\n' "$BASELINE" >&2
    printf 'Run with --regenerate-baseline to seed it.\n' >&2
    exit "$EXIT_TOOL_ERROR"
  fi
  local current_tmp new_names violations=0
  current_tmp=$(mktemp)
  extract_identifiers "$SOURCE_DIR" > "$current_tmp"
  new_names=$(LC_ALL=C comm -23 "$current_tmp" "$BASELINE")
  rm -f "$current_tmp"
  if [ -z "$new_names" ]; then
    exit "$EXIT_OK"
  fi
  while IFS= read -r name; do
    [ -z "$name" ] && continue
    if ! printf '%s' "$name" | grep -qE "$ALLOWED_PREFIX"; then
      local loc
      loc=$(find_declaration_location "$name")
      printf '::error::new identifier %s violates prefix rule %s (%s)\n' \
        "$name" "$ALLOWED_PREFIX" "${loc:-location unknown}"
      violations=$((violations + 1))
    fi
  done <<< "$new_names"
  if [ "$violations" -gt 0 ]; then
    emit_rename_examples
    exit "$EXIT_VIOLATION"
  fi
  exit "$EXIT_OK"
}

main() {
  if ! source_dir_exists "$SOURCE_DIR"; then
    printf '::error::source directory not found: %s\n' "$SOURCE_DIR" >&2
    exit "$EXIT_TOOL_ERROR"
  fi
  if [ "$MODE" = "regenerate" ]; then
    regenerate_baseline
  fi
  gate_check
}

main "$@"