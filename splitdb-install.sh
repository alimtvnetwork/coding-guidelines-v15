#!/usr/bin/env bash
# =====================================================================
# splitdb-install.sh — Split-DB Architecture Spec
#
# Installs the database conventions, split-DB architecture, and seedable config specs.
#
# Quick start:
#   curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/splitdb-install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/splitdb-install.sh | bash -s -- --version v3.39.0
#
# This is a thin wrapper around install.sh that hardcodes the bundle's
# folder list. All install.sh flags are forwarded (e.g. --version,
# --dest, --dry-run, --prompt, --force).
#
# Folders installed:
#   spec/04-database-conventions
#   spec/05-split-db-architecture
#   spec/06-seedable-config-architecture
# =====================================================================

set -euo pipefail

BUNDLE_NAME="splitdb"
BUNDLE_FOLDERS="spec/04-database-conventions,spec/05-split-db-architecture,spec/06-seedable-config-architecture"
INSTALLER_URL="https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.sh"

echo ""
echo "════════════════════════════════════════════════════════"
echo "  Split-DB Architecture Spec (bundle: ${BUNDLE_NAME})"
echo "  Delegating to install.sh with --folders ${BUNDLE_FOLDERS}"
echo "════════════════════════════════════════════════════════"
echo ""

# Skip the latest-installer probe — bundle scripts pin to install.sh as-is.
export INSTALL_NO_PROBE=1

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$INSTALLER_URL" | bash -s -- --folders "$BUNDLE_FOLDERS" "$@"
elif command -v wget >/dev/null 2>&1; then
  wget -qO- "$INSTALLER_URL" | bash -s -- --folders "$BUNDLE_FOLDERS" "$@"
else
  echo "❌ Neither curl nor wget found. Install one and retry." >&2
  exit 1
fi
