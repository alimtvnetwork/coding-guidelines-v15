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
# Match v1..v14 but NOT v15+ (negative lookahead emulated by listing).
# Pattern: coding-guidelines-v(1|2|3|4|5|6|7|8|9|10|11|12|13|14)
PATTERN='coding-guidelines-v(1[0-4]|[1-9])\b'

echo "🔍 Scanning for stale repo slug references (pre-${CURRENT_SLUG})..."

# grep -E with word boundary; -r recursive; -n with line numbers; -I skip binary
MATCHES=$(grep -rEn -I "$PATTERN" . \
  --exclude-dir=.git \
  --exclude-dir=node_modules \
  --exclude-dir=dist \
  --exclude-dir=build \
  --exclude-dir=release-artifacts \
  --exclude="check-stale-repo-slug.sh" \
  2>/dev/null || true)

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