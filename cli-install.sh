#!/usr/bin/env bash
# =====================================================================
# cli-install.sh — CLI Toolchain Spec
#
# Installs the CLI-related spec folders (PowerShell, CI/CD, generic CLI, update, distribution, generic release).
#
# Quick start:
#   curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/cli-install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/cli-install.sh | bash -s -- --version v3.39.0
#
# This is a thin wrapper around install.sh that hardcodes the bundle's
# folder list. All install.sh flags are forwarded (e.g. --version,
# --dest, --dry-run, --prompt, --force).
#
# Folders installed:
#   spec/11-powershell-integration
#   spec/12-cicd-pipeline-workflows
#   spec/13-generic-cli
#   spec/14-update
#   spec/15-distribution-and-runner
#   spec/16-generic-release
# =====================================================================

set -euo pipefail

BUNDLE_NAME="cli"
BUNDLE_FOLDERS="spec/11-powershell-integration,spec/12-cicd-pipeline-workflows,spec/13-generic-cli,spec/14-update,spec/15-distribution-and-runner,spec/16-generic-release"
INSTALLER_URL="https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.sh"

echo ""
echo "════════════════════════════════════════════════════════"
echo "  CLI Toolchain Spec (bundle: ${BUNDLE_NAME})"
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
