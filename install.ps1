# Links every skill in ./skills into ~/.claude/skills (Windows).
# Uses directory junctions, so no admin rights or Developer Mode required.
# Re-run any time; it is idempotent.

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$src  = Join-Path $repo 'skills'
$dest = Join-Path $HOME '.claude\skills'

New-Item -ItemType Directory -Force -Path $dest | Out-Null

function Remove-LinkOrDir {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }
    $item = Get-Item $Path -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        # Junction / symlink: delete the reparse point only, never follow into the target.
        [IO.Directory]::Delete($Path, $false)
    } else {
        Remove-Item $Path -Recurse -Force
    }
}

Get-ChildItem -Directory $src | ForEach-Object {
    $link = Join-Path $dest $_.Name
    Remove-LinkOrDir $link
    New-Item -ItemType Junction -Path $link -Target $_.FullName | Out-Null
    Write-Host "linked  $($_.Name)  ->  $($_.FullName)"
}

# Optional: also link into Codex (~/.codex/skills). Uncomment if you use Codex.
# $codex = Join-Path $HOME '.codex\skills'
# New-Item -ItemType Directory -Force -Path $codex | Out-Null
# Get-ChildItem -Directory $src | ForEach-Object {
#     $link = Join-Path $codex $_.Name
#     if (Test-Path $link) { Remove-Item $link -Recurse -Force }
#     New-Item -ItemType Junction -Path $link -Target $_.FullName | Out-Null
# }

Write-Host "`nDone. Skills linked into $dest"
