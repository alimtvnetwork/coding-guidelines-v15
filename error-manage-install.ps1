<#
.SYNOPSIS
    Error Management Spec — bundle installer (error-manage).

.DESCRIPTION
    Installs the error-management guidance plus the spec-authoring guide.

    This is a thin wrapper around install.ps1 that hardcodes the bundle's
    folder list. All install.ps1 parameters are forwarded (e.g. -Version,
    -Dest, -DryRun, -Prompt, -Force).

    Folders installed:
      spec/01-spec-authoring-guide
      spec/03-error-manage

.EXAMPLE
    irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/error-manage-install.ps1 | iex

.EXAMPLE
    & ([scriptblock]::Create((irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/error-manage-install.ps1))) -Version v3.39.0
#>

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ForwardedArgs = @()
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$BundleName = "error-manage"
$BundleFolders = "spec/01-spec-authoring-guide,spec/03-error-manage"
$InstallerUrl = "https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.ps1"

Write-Host ""
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Error Management Spec (bundle: $BundleName)" -ForegroundColor Cyan
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
