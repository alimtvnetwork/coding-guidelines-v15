<#
.SYNOPSIS
    PowerShell counterpart to test-bundle-installers.sh.

.DESCRIPTION
    Builds local .zip archives mimicking GitHub Release assets, serves
    them via a background python http.server, points each *-install.ps1
    at the local URL, runs it with -Version vtest -Target <tmp>, and
    asserts every declared dest folder lands under the target.
#>

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$Work     = New-Item -ItemType Directory -Path (Join-Path ([System.IO.Path]::GetTempPath()) ("bundle-test-" + [guid]::NewGuid().ToString("N").Substring(0,8))) | ForEach-Object { $_.FullName }
$Archives = Join-Path $Work "archives"
$Port     = 18476
$FakeVer  = "vtest"
$AssetDir = Join-Path $Archives "download/$FakeVer"
New-Item -ItemType Directory -Path $AssetDir -Force | Out-Null

$serverProc = $null
function Stop-Server { if ($script:serverProc -and -not $script:serverProc.HasExited) { $script:serverProc.Kill() } }
trap { Stop-Server; if (-not $env:KEEP_TMP) { Remove-Item -Recurse -Force $Work -ErrorAction SilentlyContinue }; throw }

$bundleNames = (& node (Join-Path $RepoRoot "scripts/read-bundles.mjs") names).Split("`n") | Where-Object { $_ }

Write-Host "▸ building local .zip archives in $Archives"
foreach ($bundle in $bundleNames) {
    $stable  = (& node (Join-Path $RepoRoot "scripts/read-bundles.mjs") stable-name $bundle).Trim()
    $folders = (& node (Join-Path $RepoRoot "scripts/read-bundles.mjs") folders $bundle).Trim().Split(" ")
    $zipPath = Join-Path $AssetDir "$stable.zip"
    Push-Location $RepoRoot
    try {
        Compress-Archive -Path $folders -DestinationPath $zipPath -Force
    } finally {
        Pop-Location
    }
    Write-Host "  ✓ $stable.zip [$($folders -join ', ')]"
}

Write-Host "▸ starting local HTTP server on port $Port"
$serverProc = Start-Process -FilePath "python3" -ArgumentList "-m","http.server",$Port -WorkingDirectory $Archives -PassThru -WindowStyle Hidden -RedirectStandardOutput (Join-Path $Work "server.log") -RedirectStandardError (Join-Path $Work "server.err")

# Wait for the server to come up.
$ready = $false
for ($i = 0; $i -lt 50; $i++) {
    try { Invoke-WebRequest -Uri "http://127.0.0.1:$Port/" -UseBasicParsing -TimeoutSec 1 | Out-Null; $ready = $true; break } catch { Start-Sleep -Milliseconds 200 }
}
if (-not $ready) { Stop-Server; throw "local HTTP server failed to start" }

$LocalBase = "http://127.0.0.1:$Port"
$failed = @()

foreach ($bundle in $bundleNames) {
    Write-Host ""
    Write-Host "═════════════════════════════════════════════"
    Write-Host "  Testing $bundle-install.ps1"
    Write-Host "═════════════════════════════════════════════"

    $target = Join-Path $Work "install-$bundle"
    New-Item -ItemType Directory -Path $target -Force | Out-Null

    # Patch ReleaseBase to point at our local server.
    $testScript = Join-Path $Work "$bundle-install.ps1"
    $original   = Get-Content -Raw (Join-Path $RepoRoot "$bundle-install.ps1")
    $patched    = $original -replace '(?m)^\$ReleaseBase\s*=.*$', "`$ReleaseBase = `"$LocalBase`""
    Set-Content -Path $testScript -Value $patched -Encoding utf8

    & pwsh -NoProfile -File $testScript -Version $FakeVer -Target $target
    if ($LASTEXITCODE -ne 0) {
        Write-Host "::error::$bundle-install.ps1 exited $LASTEXITCODE"
        $failed += $bundle
        continue
    }

    $manifest = Get-Content -Raw (Join-Path $RepoRoot "bundles.json") | ConvertFrom-Json
    $entry    = $manifest.bundles | Where-Object { $_.name -eq $bundle }
    $missing  = 0
    foreach ($folder in $entry.folders) {
        $expected = Join-Path $target $folder.dest
        if (Test-Path $expected) {
            Write-Host "  ✓ $expected"
        } else {
            Write-Host "::error::$bundle missing → $expected"
            $missing++
        }
    }
    if ($missing -gt 0) { $failed += $bundle }
}

Stop-Server
if (-not $env:KEEP_TMP) { Remove-Item -Recurse -Force $Work -ErrorAction SilentlyContinue }

Write-Host ""
Write-Host "═════════════════════════════════════════════"
if ($failed.Count -eq 0) {
    Write-Host "✅ all bundle install scripts passed"
    exit 0
} else {
    Write-Host "❌ failed bundles: $($failed -join ', ')"
    exit 1
}
