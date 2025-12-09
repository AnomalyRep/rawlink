$zipUrl = "https://drive.usercontent.google.com/download?id=1U1F_5vZ0mauJJspzxO_q6XwOb8xlOi1T&export=download&authuser=0&confirm=t&uuid=19b04677-97e2-4e5c-b280-7f254df00e9e&at=ALWLOp5TXK_EoWWjeUqzXcMdkQG_%3A1765317952324"

$tempDir = "$env:TEMP\mc_mods_install"
$zipPath = "$tempDir\mods.zip"
$mcModsDir = "$env:APPDATA\.minecraft\mods"

# Prepare temp
New-Item $tempDir -ItemType Directory -Force | Out-Null

# Download zip
Invoke-WebRequest $zipUrl -OutFile $zipPath

# Ensure mods dir exists
New-Item $mcModsDir -ItemType Directory -Force | Out-Null

# Extract
Expand-Archive $zipPath -DestinationPath $tempDir -Force

# Copy mods
Copy-Item "$tempDir\mods\*" $mcModsDir -Recurse -Force

# Cleanup
Remove-Item $tempDir -Recurse -Force

Write-Host "✅ Mods installed successfully!"
Pause
