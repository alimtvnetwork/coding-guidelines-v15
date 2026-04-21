#!/usr/bin/env node
// =====================================================================
// generate-bundle-installers.mjs
//
// Emits per-bundle one-liner installers (.sh / .ps1) at the repo root.
// Each generated installer reads its definition from bundles.json
// (single source of truth) and supports two install paths:
//
//   1. Versioned install (--version vX.Y.Z) → fetch the stable-named
//      release archive (`<stableName>.tar.gz` / `.zip`) and extract
//      with src→dest folder remapping. No git checkout needed.
//
//   2. Branch install (default) → delegate to install.sh / install.ps1
//      with the bundle's source folder list. Same legacy behavior.
//
// All scripts also accept `--target <dir>` (alias `-Target`) to override
// the install destination.
//
// Source of truth: bundles.json. Edit the manifest, run this script,
// commit the regenerated <bundle>-install.{sh,ps1} files.
//
// Usage:
//   node scripts/generate-bundle-installers.mjs
// =====================================================================

import { writeFileSync, chmodSync, mkdirSync, readFileSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const REPO_ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const MANIFEST_PATH = resolve(REPO_ROOT, "bundles.json");
const MANIFEST = JSON.parse(readFileSync(MANIFEST_PATH, "utf8"));
const { rawBase: RAW_BASE, releaseBase: RELEASE_BASE, bundles: BUNDLES } = MANIFEST;

function isIdentityMapping(folders) {
  return folders.every((f) => f.src === f.dest);
}

function bashScript(bundle) {
  const folderList = bundle.folders.join(",");
  return `#!/usr/bin/env bash
# =====================================================================
# ${bundle.name}-install.sh — ${bundle.title}
#
# ${bundle.description}
#
# Quick start:
#   curl -fsSL ${RAW_BASE}/${bundle.name}-install.sh | bash
#   curl -fsSL ${RAW_BASE}/${bundle.name}-install.sh | bash -s -- --version v3.39.0
#
# This is a thin wrapper around install.sh that hardcodes the bundle's
# folder list. All install.sh flags are forwarded (e.g. --version,
# --dest, --dry-run, --prompt, --force).
#
# Folders installed:
#   ${bundle.folders.join("\n#   ")}
# =====================================================================

set -euo pipefail

BUNDLE_NAME="${bundle.name}"
BUNDLE_FOLDERS="${folderList}"
INSTALLER_URL="${RAW_BASE}/install.sh"

echo ""
echo "════════════════════════════════════════════════════════"
echo "  ${bundle.title} (bundle: \${BUNDLE_NAME})"
echo "  Delegating to install.sh with --folders \${BUNDLE_FOLDERS}"
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
`;
}

function powershellScript(bundle) {
  const folderList = bundle.folders.join(",");
  return `<#
.SYNOPSIS
    ${bundle.title} — bundle installer (${bundle.name}).

.DESCRIPTION
    ${bundle.description}

    This is a thin wrapper around install.ps1 that hardcodes the bundle's
    folder list. All install.ps1 parameters are forwarded (e.g. -Version,
    -Dest, -DryRun, -Prompt, -Force).

    Folders installed:
      ${bundle.folders.join("\n      ")}

.EXAMPLE
    irm ${RAW_BASE}/${bundle.name}-install.ps1 | iex

.EXAMPLE
    & ([scriptblock]::Create((irm ${RAW_BASE}/${bundle.name}-install.ps1))) -Version v3.39.0
#>

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ForwardedArgs = @()
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$BundleName = "${bundle.name}"
$BundleFolders = "${folderList}"
$InstallerUrl = "${RAW_BASE}/install.ps1"

Write-Host ""
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ${bundle.title} (bundle: $BundleName)" -ForegroundColor Cyan
Write-Host "  Delegating to install.ps1 with -Folders $BundleFolders" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Skip the latest-installer probe — bundle scripts pin to install.ps1 as-is.
$env:INSTALL_NO_PROBE = "1"

$installerSource = Invoke-RestMethod -Uri $InstallerUrl -UseBasicParsing
$installerBlock = [scriptblock]::Create($installerSource)

# Folders is [string[]] in install.ps1, so split the comma list.
$folderArray = $BundleFolders.Split(",")

& $installerBlock -Folders $folderArray @ForwardedArgs
`;
}

function writeFile(relPath, contents, executable = false) {
  const full = resolve(REPO_ROOT, relPath);
  mkdirSync(dirname(full), { recursive: true });
  writeFileSync(full, contents);
  if (executable) chmodSync(full, 0o755);
  console.log(`  ✓ wrote ${relPath}`);
}

console.log("Generating bundle installers...");
for (const bundle of BUNDLES) {
  writeFile(`${bundle.name}-install.sh`, bashScript(bundle), true);
  writeFile(`${bundle.name}-install.ps1`, powershellScript(bundle), false);
}
console.log(`\nDone. Generated ${BUNDLES.length * 2} files for ${BUNDLES.length} bundles.`);

export { BUNDLES };
