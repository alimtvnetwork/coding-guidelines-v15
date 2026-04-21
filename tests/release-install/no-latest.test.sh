#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────
# tests/release-install/no-latest.test.sh
#
# G-REL test harness — asserts that release-install.sh and
# release-install.ps1 NEVER fall back to:
#
#   1. api.github.com/.../releases/latest          (latest API)
#   2. /releases/latest/                            (HTML "latest" page)
#   3. raw.githubusercontent.com/.../main/...       (rolling main branch)
#   4. raw.githubusercontent.com/.../master/...     (rolling master branch)
#   5. /tree/HEAD or /tarball/HEAD or /zipball/HEAD (git HEAD ref)
#   6. clone https://github.com/<repo>(.git)?       (git clone of repo)
#
# Per spec/14-update/25-release-pinned-installer.md §"Pin Enforcement
# Guarantees":
#   e. Never query GitHub API for `latest` releases.
#   f. Never clone or fetch the source git repo.
#
# This is a STATIC text scan — no network is used. It runs in CI and
# fails the build if any forbidden pattern appears in either script.
#
# Exit codes:
#   0  PASS — both scripts are clean
#   1  FAIL — at least one forbidden pattern found
#   2  ERROR — script(s) missing or unreadable
# ──────────────────────────────────────────────────────────────────────

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SH_FILE="$REPO_ROOT/release-install.sh"
PS_FILE="$REPO_ROOT/release-install.ps1"

is_file_readable() {
  [ -r "$1" ]
}

# Each forbidden pattern is "label<TAB>regex" — regex is a fixed
# extended POSIX expression that grep -E understands.
FORBIDDEN_PATTERNS=(
  "latest-api	api\\.github\\.com/repos/[^/[:space:]]+/[^/[:space:]]+/releases/latest"
  "latest-html	github\\.com/[^/[:space:]]+/[^/[:space:]]+/releases/latest"
  "raw-main	raw\\.githubusercontent\\.com/[^/[:space:]]+/[^/[:space:]]+/main/"
  "raw-master	raw\\.githubusercontent\\.com/[^/[:space:]]+/[^/[:space:]]+/master/"
  "head-ref	(/tree/HEAD|/tarball/HEAD|/zipball/HEAD|refs/heads/HEAD)"
  "git-clone	git[[:space:]]+clone[[:space:]]+https?://github\\.com/"
)

TOTAL_FAILS=0
REPORT_FILE="$(mktemp)"
trap 'rm -f "$REPORT_FILE"' EXIT

scan_file() {
  local label="$1" file="$2"
  if ! is_file_readable "$file"; then
    echo "ERROR: $label not readable at $file" >> "$REPORT_FILE"
    return 2
  fi
  local local_fails=0
  local entry pattern_label pattern_regex match
  for entry in "${FORBIDDEN_PATTERNS[@]}"; do
    pattern_label="${entry%%	*}"
    pattern_regex="${entry#*	}"
    match="$(grep -E -n -- "$pattern_regex" "$file" || true)"
    if [ -n "$match" ]; then
      echo "FAIL: $label matched [$pattern_label]" >> "$REPORT_FILE"
      echo "$match" | sed 's/^/      /' >> "$REPORT_FILE"
      local_fails=$((local_fails + 1))
    fi
  done
  return $local_fails
}

echo "G-REL: no-latest harness for release-install.{sh,ps1}"
echo "      repo: $REPO_ROOT"
echo ""

ERROR_HIT=0

scan_file "release-install.sh"  "$SH_FILE"
SH_RC=$?
if [ "$SH_RC" -eq 2 ]; then ERROR_HIT=1; else TOTAL_FAILS=$((TOTAL_FAILS + SH_RC)); fi

scan_file "release-install.ps1" "$PS_FILE"
PS_RC=$?
if [ "$PS_RC" -eq 2 ]; then ERROR_HIT=1; else TOTAL_FAILS=$((TOTAL_FAILS + PS_RC)); fi

if [ "$ERROR_HIT" -eq 1 ]; then
  cat "$REPORT_FILE"
  printf '\nGATE: G-REL\nRESULT: ERROR\nATTRIBUTED-TO: FAIL-REL-000\n'
  exit 2
fi

if [ "$TOTAL_FAILS" -gt 0 ]; then
  cat "$REPORT_FILE"
  printf '\nGATE: G-REL\nRESULT: FAIL\nEVIDENCE: %d forbidden pattern(s) found\nATTRIBUTED-TO: FAIL-REL-001\nNEXT-ACTION: remove latest/main/master/HEAD references from release-install.{sh,ps1}\n' \
    "$TOTAL_FAILS"
  exit 1
fi

printf 'GATE: G-REL\nRESULT: PASS\nEVIDENCE: zero forbidden patterns in release-install.sh and release-install.ps1\n'
exit 0