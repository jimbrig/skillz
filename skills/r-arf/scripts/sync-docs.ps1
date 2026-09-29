<#
.SYNOPSIS
  Copy upstream eitsupi/arf docs into references/vendor.
#>
[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"
$Repo = "eitsupi/arf"
$VendorDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\references\vendor"))
New-Item -ItemType Directory -Force -Path $VendorDir | Out-Null

$entries = gh repo read-dir docs/ --repo $Repo --json path --jq ".entries.[].path"
$files = @()
foreach ($doc in $entries) {
  if ($doc -notmatch '\.md$') { continue }
  $name = $doc.Split("/")[-1]
  $dest = Join-Path $VendorDir $name
  gh repo read-file $doc --repo $Repo --output $dest --clobber
  $files += $name
}

$version = $null
$arf = Get-Command arf -ErrorAction SilentlyContinue
if ($arf) { $version = (& arf --version 2>&1 | Out-String).Trim() }

$manifest = [ordered]@{
  repo      = $Repo
  synced_at = (Get-Date).ToString("o")
  files     = $files
  arf       = $version
}
$manifest | ConvertTo-Json | Set-Content -Path (Join-Path $VendorDir "MANIFEST.json") -Encoding utf8
Write-Host "Synced $($files.Count) docs to $VendorDir"
if ($version) { Write-Host "Installed: $version" }
