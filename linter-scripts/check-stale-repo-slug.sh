#!/usr/bin/env bash
# ============================================================
# Stale Repo Slug Safeguard
# ============================================================
# Scans the repository for pre-renumber repo slug references
# (coding-guidelines-v1 .. coding-guidelines-v14). The current
# canonical slug is `coding-guidelines-v15`. Any older slug is a
# bug from an incomplete bulk rename and must be fixed.
#
# Allowed exceptions:
#   - This script itself (it must mention the blocked slugs).
#   - release-artifacts/** historical snapshots (immutable
#     pinned-version installer bundles).
#   - .git/**, node_modules/**, dist/**, build/** (generated).
#
# Usage:  bash linter-scripts/check-stale-repo-slug.sh
# CI:     wired in .github/workflows/ci.yml (lint job).
# ============================================================

set -uo pipefail

CURRENT_SLUG="coding-guidelines-v15"
ALLOWLIST="linter-scripts/stale-repo-slug.allowlist"
# Match v1..v14 but NOT v15+.
PATTERN='coding-guidelines-v(1[0-4]|[1-9])\b'

echo "🔍 Scanning for stale repo slug references (pre-${CURRENT_SLUG})..."

RAW=$(grep -rEn -I "$PATTERN" . \
  --exclude-dir=.git \
  --exclude-dir=node_modules \
  --exclude-dir=dist \
  --exclude-dir=build \
  --exclude-dir=release-artifacts \
  --exclude="check-stale-repo-slug.sh" \
  --exclude="stale-repo-slug.allowlist" \
  2>/dev/null || true)

# Filter out paths matched by the allowlist (one glob/path-prefix per line).
if [[ -f "$ALLOWLIST" && -n "$RAW" ]]; then
  MATCHES=$(echo "$RAW" | python3 -c "
import sys, fnmatch
allow = []
with open('$ALLOWLIST') as f:
    for line in f:
        s = line.strip()
        if s and not s.startswith('#'):
            allow.append(s)
for line in sys.stdin:
    raw = line.split(':', 1)[0]
    path = raw[2:] if raw.startswith('./') else raw
    if any(fnmatch.fnmatch(path, p) or path == p or path.startswith(p + '/') for p in allow):
        continue
    sys.stdout.write(line)
")
else
  MATCHES="$RAW"
fi

if [[ -z "$MATCHES" ]]; then
  echo "✅ PASS: no stale repo slug references found."
  exit 0
fi

COUNT=$(echo "$MATCHES" | wc -l | tr -d ' ')
echo "❌ FAIL: found $COUNT stale repo slug reference(s):"
echo ""
echo "$MATCHES"
echo ""
echo "Fix: replace pre-renumber slugs with '$CURRENT_SLUG'."
echo "     Example bulk fix:"
echo "       grep -rlE '$PATTERN' . | xargs sed -i 's|coding-guidelines-v14|$CURRENT_SLUG|g'"
exit 1