#!/usr/bin/env node
// =====================================================================
// generate-bundle-installers.mjs
//
// Emits per-bundle one-liner installers (.sh / .ps1) at the repo root.
// Each generated installer is a thin wrapper that delegates to the
// canonical install.sh / install.ps1 with a hardcoded --folders list.
//
// Why thin wrappers: keeps a single source of truth for download +
// merge logic in install.{sh,ps1}; fixes propagate to all bundles
// automatically; bundle scripts stay ~40 lines and easy to audit.
//
// Usage:
//   node scripts/generate-bundle-installers.mjs
// =====================================================================

import { writeFileSync, chmodSync, mkdirSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const REPO_ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const REPO_SLUG = "alimtvnetwork/coding-guidelines-v15";
const RAW_BASE = `https://raw.githubusercontent.com/${REPO_SLUG}/main`;

const BUNDLES = [
  {
    name: "error-manage",
    title: "Error Management Spec",
    description: "Installs the error-management guidance plus the spec-authoring guide.",
    folders: ["spec/01-spec-authoring-guide", "spec/03-error-manage"],
  },
  {
    name: "splitdb",
    title: "Split-DB Architecture Spec",
    description: "Installs the database conventions, split-DB architecture, and seedable config specs.",
    folders: [
      "spec/04-database-conventions",
      "spec/05-split-db-architecture",
      "spec/06-seedable-config-architecture",
    ],
  },
  {
    name: "slides",
    title: "Slides App + Decks",
    description: "Installs the slides Vite app and the source decks (spec-slides/).",
    folders: ["spec-slides", "slides-app"],
  },
  {
    name: "linters",
    title: "Linters + CI/CD Linter Pack",
    description: "Installs the project linters and the CI/CD linter runner pack.",
    folders: ["linters", "linters-cicd"],
  },
  {
    name: "cli",
    title: "CLI Toolchain Spec",
    description: "Installs the CLI-related spec folders (PowerShell, CI/CD, generic CLI, update, distribution, generic release).",
    folders: [
      "spec/11-powershell-integration",
      "spec/12-cicd-pipeline-workflows",
      "spec/13-generic-cli",
      "spec/14-update",
      "spec/15-distribution-and-runner",
      "spec/16-generic-release",
    ],
  },
  {
    name: "wp",
    title: "WordPress Plugin How-To Spec",
    description: "Installs the WordPress plugin authoring spec into spec/18-wp-plugin-how-to.",
    folders: ["spec/18-wp-plugin-how-to"],
  },
  {
    name: "consolidated",
    title: "Consolidated Guidelines",
    description: "Installs the spec-authoring guide, error-manage spec, and consolidated guidelines bundle.",
    folders: [
      "spec/01-spec-authoring-guide",
      "spec/03-error-manage",
      "spec/17-consolidated-guidelines",
    ],
  },
];

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
