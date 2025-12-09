Clear-Host
$Host.UI.RawUI.WindowTitle = "Minecraft Mods Installer"

# ================= CONFIG =================
$zipUrl = "https://drive.usercontent.google.com/download?id=1U1F_5vZ0mauJJspzxO_q6XwOb8xlOi1T&export=download&confirm=t"
$mcDir = "$env:APPDATA\.minecraft"
$modsDir = "$mcDir\mods"
$tempDir = "$env:TEMP\mc_mods_install"
$zipPath = "$tempDir\mods.zip"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
# ========================================

function Line {
    Write-Host "----------------------------------------" -ForegroundColor DarkGray
}

Line
Write-Host " Minecraft Mods Installer" -ForegroundColor Cyan
Line

Write-Host "[1/5] Preparing installation..."
New-Item $tempDir -ItemType Directory -Force | Out-Null
New-Item $mcDir -ItemType Directory -Force | Out-Null

Write-Host "[2/5] Downloading mods pack..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($zipUrl, $zipPath)

Write-Host "[3/5] Backing up old mods folder..."
if (Test-Path $modsDir) {
    $backupDir = "$mcDir\mods_old_$timestamp"
    Rename-Item $modsDir $backupDir
    Write-Host "      Old mods moved to: mods_old_$timestamp"
}

New-Item $modsDir -ItemType Directory -Force | Out-Null

Write-Host "[4/5] Extracting new mods..."
Expand-Archive $zipPath -DestinationPath $tempDir -Force
Copy-Item "$tempDir\mods\*" $modsDir -Recurse -Force

Write-Host "[5/5] Cleaning up..."
Remove-Item $tempDir -Recurse -Force

Line
Write-Host "INSTALLATION COMPLETE" -ForegroundColor Green
Write-Host "Mods installed successfully."
Write-Host "Old mods have been safely preserved."
Line

Pause
