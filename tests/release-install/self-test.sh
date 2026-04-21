#!/usr/bin/env bash
# self-test.sh — confirm the no-latest harness actually catches bad code.
#
# Procedure:
#   1. Run no-latest.test.sh against the real release-install scripts → must PASS.
#   2. Temporarily swap release-install.sh with the dirty fixture     → must FAIL.
#   3. Restore the original.
#
# Exit 0 if both expectations hold; non-zero otherwise.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HARNESS="$ROOT/tests/release-install/no-latest.test.sh"
FIXTURE="$ROOT/tests/release-install/_fixtures/dirty-install.sh"
SH_FILE="$ROOT/release-install.sh"
BACKUP="$(mktemp)"

cleanup() {
  if [ -f "$BACKUP" ] && [ -s "$BACKUP" ]; then
    cp "$BACKUP" "$SH_FILE"
  fi
  rm -f "$BACKUP"
}
trap cleanup EXIT

echo "=== self-test step 1: real scripts must PASS ==="
if ! bash "$HARNESS" >/dev/null; then
  echo "FAIL: real release-install scripts trip the harness"
  bash "$HARNESS"
  exit 1
fi
echo "OK: real scripts pass"
echo ""

echo "=== self-test step 2: dirty fixture must FAIL ==="
cp "$SH_FILE" "$BACKUP"
cp "$FIXTURE" "$SH_FILE"

set +e
bash "$HARNESS" >/dev/null
RC=$?
set -e

if [ "$RC" -ne 1 ]; then
  echo "FAIL: harness returned $RC against dirty fixture (expected 1)"
  exit 1
fi
echo "OK: dirty fixture correctly rejected (rc=$RC)"
echo ""

echo "=== self-test PASS ==="
exit 0