$zipUrl = "https://drive.usercontent.google.com/download?id=1U1F_5vZ0mauJJspzxO_q6XwOb8xlOi1T&export=download&confirm=t"

$tempDir = "$env:TEMP\mc_mods_install"
$zipPath = "$tempDir\mods.zip"
$modsDir = "$env:APPDATA\.minecraft\mods"

Write-Host "Preparing installation..."

New-Item $tempDir -ItemType Directory -Force | Out-Null
New-Item $modsDir -ItemType Directory -Force | Out-Null

Write-Host "Downloading mods pack..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($zipUrl, $zipPath)

Write-Host "Extracting mods..."
Expand-Archive $zipPath -DestinationPath $tempDir -Force

Write-Host "Installing mods..."
Copy-Item "$tempDir\mods\*" $modsDir -Recurse -Force

Write-Host "Cleaning up..."
Remove-Item $tempDir -Recurse -Force

Write-Host "✅ Mods installed successfully!"
Pause

