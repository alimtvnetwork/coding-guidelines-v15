#!/usr/bin/env bash
# replay-repro.sh — G-REP gate: replay an issue file and emit evidence.
#
# Spec: spec/19-ai-reliability/06-validation-gates.md (Gate G-REP)
# Version: 1.0.0
#
# Usage:
#   ./scripts/replay-repro.sh <issue-file>
#   ./scripts/replay-repro.sh 03-issues/2026-04-21-flicker.md
#
# Contract:
#   1. Reads the issue file and extracts the expected console error
#      (first fenced block tagged ```console-error``` or first line
#      starting with "EXPECTED-ERROR:").
#   2. Replays the scenario by running the repro command declared in the
#      issue file (line starting with "REPRO-CMD:") and captures stdout +
#      stderr into a trace file under .repro/<issue-stem>.trace.
#   3. Greps the trace for the expected error string.
#   4. Emits the G-REP evidence block (GATE/RESULT/EVIDENCE/...).
#
# Exit codes:
#   0  → PASS  (expected error found in trace)
#   1  → FAIL  (expected error NOT found in trace)
#   2  → ERROR (issue file missing / malformed / repro command failed to run)

set -u

GATE_ID="G-REP"
SCRIPT_VERSION="1.0.0"

die() {
  local message="$1"
  printf 'GATE: %s\nRESULT: ERROR\nEVIDENCE: %s\nATTRIBUTED-TO: FAIL-REP-000\nNEXT-ACTION: fix invocation and rerun\n' \
    "$GATE_ID" "$message" >&2
  exit 2
}

is_arg_present() {
  [ "$#" -ge 1 ] && [ -n "${1:-}" ]
}

is_arg_present "$@" || die "missing <issue-file> argument"

ISSUE_FILE="$1"
[ -f "$ISSUE_FILE" ] || die "issue file not found: $ISSUE_FILE"

# --- Extract expected error -------------------------------------------------
EXPECTED_ERROR=""
EXPECTED_ERROR=$(awk '
  /^EXPECTED-ERROR:/ { sub(/^EXPECTED-ERROR:[ \t]*/, ""); print; exit }
' "$ISSUE_FILE")

if [ -z "$EXPECTED_ERROR" ]; then
  EXPECTED_ERROR=$(awk '
    /^```console-error[ \t]*$/ { in_block=1; next }
    in_block && /^```[ \t]*$/  { exit }
    in_block                    { print }
  ' "$ISSUE_FILE" | head -n 1)
fi

[ -n "$EXPECTED_ERROR" ] || die "no EXPECTED-ERROR or \`\`\`console-error block in $ISSUE_FILE"

# --- Extract repro command --------------------------------------------------
REPRO_CMD=$(awk '
  /^REPRO-CMD:/ { sub(/^REPRO-CMD:[ \t]*/, ""); print; exit }
' "$ISSUE_FILE")

[ -n "$REPRO_CMD" ] || die "no REPRO-CMD: line in $ISSUE_FILE"

# --- Run repro and capture trace --------------------------------------------
ISSUE_STEM=$(basename "$ISSUE_FILE" .md)
TRACE_DIR=".repro"
TRACE_FILE="$TRACE_DIR/${ISSUE_STEM}.trace"
mkdir -p "$TRACE_DIR" || die "cannot create $TRACE_DIR"

printf '# replay-repro.sh v%s\n# issue:    %s\n# command:  %s\n# expected: %s\n# ---\n' \
  "$SCRIPT_VERSION" "$ISSUE_FILE" "$REPRO_CMD" "$EXPECTED_ERROR" > "$TRACE_FILE"

# Run command; capture combined stdout+stderr; never let failure abort the gate.
bash -c "$REPRO_CMD" >> "$TRACE_FILE" 2>&1
REPRO_EXIT=$?

# --- Match expected error ---------------------------------------------------
MATCH_LINE=""
# Only search lines AFTER the "# ---" header separator so the header
# (which echoes EXPECTED-ERROR/REPRO-CMD verbatim) cannot self-match.
MATCH_LINE=$(awk '/^# ---$/ { found=1; next } found' "$TRACE_FILE" \
  | grep -F -n -m 1 -- "$EXPECTED_ERROR" || true)

is_match_found() {
  [ -n "$MATCH_LINE" ]
}

if is_match_found; then
  printf 'GATE: %s\nRESULT: PASS\nEVIDENCE: %s\nTRACE: %s\nREPRO-EXIT: %s\n' \
    "$GATE_ID" "$MATCH_LINE" "$TRACE_FILE" "$REPRO_EXIT"
  exit 0
fi

printf 'GATE: %s\nRESULT: FAIL\nEVIDENCE: expected "%s" not found in %s\nTRACE: %s\nREPRO-EXIT: %s\nATTRIBUTED-TO: FAIL-REP-001\nNEXT-ACTION: re-instrument repro or update EXPECTED-ERROR in %s\n' \
  "$GATE_ID" "$EXPECTED_ERROR" "$TRACE_FILE" "$TRACE_FILE" "$REPRO_EXIT" "$ISSUE_FILE"
exit 1