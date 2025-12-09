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
New-Item $mcDir -ItemType Directory -Force |
