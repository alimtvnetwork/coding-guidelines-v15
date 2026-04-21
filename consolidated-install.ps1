<#
.SYNOPSIS
    Consolidated Guidelines — bundle installer (consolidated).

.DESCRIPTION
    Installs the spec-authoring guide, error-manage spec, and consolidated guidelines bundle.

    This is a thin wrapper around install.ps1 that hardcodes the bundle's
    folder list. All install.ps1 parameters are forwarded (e.g. -Version,
    -Dest, -DryRun, -Prompt, -Force).

    Folders installed:
      spec/01-spec-authoring-guide
      spec/03-error-manage
      spec/17-consolidated-guidelines

.EXAMPLE
    irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/consolidated-install.ps1 | iex

.EXAMPLE
    & ([scriptblock]::Create((irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/consolidated-install.ps1))) -Version v3.39.0
#>

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ForwardedArgs = @()
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$BundleName = "consolidated"
$BundleFolders = "spec/01-spec-authoring-guide,spec/03-error-manage,spec/17-consolidated-guidelines"
$InstallerUrl = "https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.ps1"

Write-Host ""
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Consolidated Guidelines (bundle: $BundleName)" -ForegroundColor Cyan
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
