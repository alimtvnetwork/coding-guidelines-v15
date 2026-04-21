<#
.SYNOPSIS
    Pinned-version installer for GitHub Releases.

.DESCRIPTION
    The release-page counterpart to install.ps1. NEVER resolves "latest".
    Installs exactly the version it was built for (baked at release time)
    or the version explicitly passed via -Version.

    Spec: spec/14-update/25-release-pinned-installer.md

.PARAMETER Version
    Install this exact tag (overrides baked-in value).

.PARAMETER NoUpdate
    No-op. Pinning is always on; switch accepted for ergonomics / parity
    with the bash variant.

.EXAMPLE
    irm https://github.com/<owner>/<repo>/releases/download/vX.Y.Z/release-install.ps1 | iex
    .\release-install.ps1 -Version v3.21.0

.NOTES
    Exit codes (per spec):
      0  success
      1  no version resolvable
      2  invalid version string
      3  pinned release / asset not found
      5  inner installer rejected pinning handshake
#>

param(
    [string]$Version = "",
    [switch]$NoUpdate
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ── Build-time substitution target ────────────────────────────────
# The release workflow replaces __VERSION_PLACEHOLDER__ with the concrete
# tag (e.g. v3.21.0) when uploading this file as a release asset.
$BakedVersion = "__VERSION_PLACEHOLDER__"

$Repo     = "alimtvnetwork/coding-guidelines-v15"
$SemverRe = '^v?\d+\.\d+\.\d+(-[A-Za-z0-9.]+)?$'

$script:Indent = "    "
function Write-Step { param([string]$Msg) Write-Host "$script:Indent▸ $Msg"  -ForegroundColor Cyan }
function Write-OK   { param([string]$Msg) Write-Host "$script:Indent✅ $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "$script:Indent⚠️  $Msg" -ForegroundColor Yellow }
function Write-Err  { param([string]$Msg) Write-Host "$script:Indent❌ $Msg" -ForegroundColor Red }
function Write-Dim  { param([string]$Msg) Write-Host "$script:Indent$Msg"   -ForegroundColor DarkGray }

# ── Resolve pinned version (spec §Resolution Algorithm) ───────────
function Resolve-PinnedVersion {
    if ($Version) {
        if ($BakedVersion -ne "__VERSION_PLACEHOLDER__" -and $BakedVersion -ne $Version) {
            Write-Warn "Argument -Version ($Version) overrides baked-in ($BakedVersion)."
        }
        return $Version
    }
    if ($BakedVersion -ne "__VERSION_PLACEHOLDER__") {
        return $BakedVersion
    }
    return $null
}

$Resolved = Resolve-PinnedVersion
if (-not $Resolved) {
    Write-Err "release-install requires a pinned version."
    Write-Err "Pass -Version <tag> or run the baked copy from a Release page."
    exit 1
}

# ── Validate (spec §Validation) ───────────────────────────────────
if ($Resolved -notmatch $SemverRe) {
    Write-Err "Invalid version format: '$Resolved'"
    Write-Err "Expected semver, e.g. v3.21.0 or 3.21.0-beta.1"
    exit 2
}

Write-OK "Installing pinned version: $Resolved"

# ── HEAD-check pinned asset, hybrid fallback ──────────────────────
function Test-UrlExists {
    param([string]$Url)
    try {
        $req = [System.Net.HttpWebRequest]::Create($Url)
        $req.Method = "HEAD"
        $req.Timeout = 5000
        $req.AllowAutoRedirect = $true
        $resp = $req.GetResponse()
        $code = [int]$resp.StatusCode
        $resp.Close()
        return $code -eq 200
    } catch {
        return $false
    }
}

$PrimaryUrl  = "https://github.com/$Repo/releases/download/$Resolved/source-code.zip"
$FallbackUrl = "https://codeload.github.com/$Repo/zip/refs/tags/$Resolved"

Write-Step "Probing primary release asset..."
$DownloadUrl = $null
if (Test-UrlExists -Url $PrimaryUrl) {
    $DownloadUrl = $PrimaryUrl
    Write-OK "Found release asset: $PrimaryUrl"
} else {
    Write-Warn "Primary asset unavailable — trying codeload zip."
    if (Test-UrlExists -Url $FallbackUrl) {
        $DownloadUrl = $FallbackUrl
        Write-OK "Found tag zip: $FallbackUrl"
    } else {
        Write-Err "Release '$Resolved' not found at either location:"
        Write-Err "  primary:  $PrimaryUrl"
        Write-Err "  fallback: $FallbackUrl"
        Write-Err "Verify the tag exists at https://github.com/$Repo/releases"
        exit 3
    }
}

# ── Hand off to inner installer with pinning handshake ────────────
$InstallUrl = "https://raw.githubusercontent.com/$Repo/$Resolved/install.ps1"
Write-Step "Handing off to inner installer (pinned)..."
Write-Dim "  Source: $InstallUrl"
Write-Dim "  Pinned: $Resolved"

try {
    $script = Invoke-RestMethod -Uri $InstallUrl -UseBasicParsing
} catch {
    Write-Err "Could not download inner installer: $($_.Exception.Message)"
    exit 3
}

# Build a script block that invokes install.ps1 with pinning handshake.
$wrapper = @"
$script
# Hand-off override block injected by release-install.ps1
"@

try {
    $sb = [scriptblock]::Create($wrapper)
    & $sb -Version $Resolved -NoProbe -PinnedByReleaseInstall $Resolved
    $exit = $LASTEXITCODE
} catch {
    Write-Err "Inner installer error: $($_.Exception.Message)"
    exit 5
}

if ($exit -and $exit -ne 0) {
    Write-Err "Inner installer exited with code $exit"
    if ($exit -eq 2) {
        Write-Err "Pinning handshake may have been rejected (version skew?)"
        exit 5
    }
    exit $exit
}

Write-OK "Pinned install complete: $Resolved"
