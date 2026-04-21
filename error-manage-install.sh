#!/usr/bin/env bash
# =====================================================================
# error-manage-install.sh — Error Management Spec
#
# Installs the error-management guidance plus the spec-authoring guide.
#
# Quick start:
#   curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/error-manage-install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/error-manage-install.sh | bash -s -- --version v3.39.0
#
# This is a thin wrapper around install.sh that hardcodes the bundle's
# folder list. All install.sh flags are forwarded (e.g. --version,
# --dest, --dry-run, --prompt, --force).
#
# Folders installed:
#   spec/01-spec-authoring-guide
#   spec/03-error-manage
# =====================================================================

set -euo pipefail

BUNDLE_NAME="error-manage"
BUNDLE_FOLDERS="spec/01-spec-authoring-guide,spec/03-error-manage"
INSTALLER_URL="https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.sh"

echo ""
echo "════════════════════════════════════════════════════════"
echo "  Error Management Spec (bundle: ${BUNDLE_NAME})"
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
