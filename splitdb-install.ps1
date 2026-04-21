<#
.SYNOPSIS
    Split-DB Architecture Spec — bundle installer (splitdb).

.DESCRIPTION
    Installs the database conventions, split-DB architecture, and seedable config specs.

    This is a thin wrapper around install.ps1 that hardcodes the bundle's
    folder list. All install.ps1 parameters are forwarded (e.g. -Version,
    -Dest, -DryRun, -Prompt, -Force).

    Folders installed:
      spec/04-database-conventions
      spec/05-split-db-architecture
      spec/06-seedable-config-architecture

.EXAMPLE
    irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/splitdb-install.ps1 | iex

.EXAMPLE
    & ([scriptblock]::Create((irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/splitdb-install.ps1))) -Version v3.39.0
#>

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ForwardedArgs = @()
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$BundleName = "splitdb"
$BundleFolders = "spec/04-database-conventions,spec/05-split-db-architecture,spec/06-seedable-config-architecture"
$InstallerUrl = "https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.ps1"

Write-Host ""
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Split-DB Architecture Spec (bundle: $BundleName)" -ForegroundColor Cyan
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
