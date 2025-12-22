Clear-Host
$Host.UI.RawUI.WindowTitle = "Installer Mods & Shaderpack Minecraft"

# ================= CONFIG =================
$modsUrl = "https://www.dropbox.com/scl/fi/b1shthyisxpnn0jk2krro/mods.zip?rlkey=rj22tq9sx8zkavamgv13czu26&st=njl5wzv0&dl=1"
$shadersUrl = "https://www.dropbox.com/scl/fi/8zhck7t45l7n2lpnievpw/shaderpacks.zip?rlkey=ghi6x169r1so4zzv7yfz3osc2&st=5j8y5atq&dl=1"
$serverIP = "premium-3.alstore.space:20042"
$mcDir = "$env:APPDATA\.minecraft"
$modsDir = "$mcDir\mods"
$shadersDir = "$mcDir\shaderpacks"
$configDir = "$mcDir\config"
$customBrandFile = "$configDir\customclientbrand.json"
$tempDir = "$env:TEMP\mc_install"
$modsZip = "$tempDir\mods.zip"
$shadersZip = "$tempDir\shaderpacks.zip"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
# ========================================

function Line {
    Write-Host "========================================" -ForegroundColor DarkGray
}

function DoubleLine {
    Write-Host "========================================" -ForegroundColor Cyan
}

DoubleLine
Write-Host "                                        " -BackgroundColor DarkBlue
Write-Host "  INSTALLER MODS & SHADERPACK MC 1.21.11  " -ForegroundColor White -BackgroundColor DarkBlue
Write-Host "         Server Private Edition         " -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host "                                        " -BackgroundColor DarkBlue
DoubleLine
Write-Host ""
Write-Host "  Dipersembahkan untuk:" -ForegroundColor Magenta
Write-Host "    [*] Arvin (The Installer)" -ForegroundColor Cyan
Write-Host "    [*] Bang Abi" -ForegroundColor Cyan
Write-Host "    [*] Bang Dendra" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Selamat bermain di server private kami!" -ForegroundColor Yellow
Line

Write-Host "[1/8] Nyiapin folder..." -ForegroundColor White
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item $tempDir -ItemType Directory -Force | Out-Null
New-Item $mcDir -ItemType Directory -Force | Out-Null
New-Item $configDir -ItemType Directory -Force | Out-Null
Write-Host "      Siap bos!" -ForegroundColor Green

Write-Host "[2/8] Nge-download mods pack..." -ForegroundColor White
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($modsUrl, $modsZip)
Write-Host "      Mods udah ke-download!" -ForegroundColor Green

Write-Host "[3/8] Backup mods lama dulu..." -ForegroundColor White
if (Test-Path $modsDir) {
    $backupModsDir = "$mcDir\mods_backup_$timestamp"
    Rename-Item $modsDir $backupModsDir
    Write-Host "      Mods lama dipindahin ke: mods_backup_$timestamp" -ForegroundColor Yellow
}
New-Item $modsDir -ItemType Directory -Force | Out-Null

Write-Host "[4/8] Extract & install mods..." -ForegroundColor White
Expand-Archive $modsZip -DestinationPath "$tempDir\mods_extract" -Force
if (Test-Path "$tempDir\mods_extract\mods") {
    Copy-Item "$tempDir\mods_extract\mods\*" $modsDir -Recurse -Force
    Write-Host "      Ketemu folder mods, lagi di-copy..." -ForegroundColor Cyan
} else {
    $jarFiles = Get-ChildItem -Path "$tempDir\mods_extract" -Filter "*.jar" -Recurse
    if ($jarFiles.Count -gt 0) {
        $jarFiles | ForEach-Object {
            Copy-Item $_.FullName $modsDir -Force
        }
        Write-Host "      Berhasil copy $($jarFiles.Count) file mod" -ForegroundColor Cyan
    } else {
        Write-Host "      PERHATIAN: Gak nemu file .jar di ZIP!" -ForegroundColor Red
    }
}

# Hapus SEMUA sisa extract mods dan file mods.zip
Write-Host "      Bersihin sisa file mods..." -ForegroundColor Cyan
Remove-Item "$tempDir\mods_extract" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $modsZip -Force -ErrorAction SilentlyContinue

Write-Host "[5/8] Nge-download shaderpack..." -ForegroundColor White
$wc.DownloadFile($shadersUrl, $shadersZip)
Write-Host "      Shaderpack udah ke-download!" -ForegroundColor Green

Write-Host "[6/8] Backup & install shaderpack..." -ForegroundColor White
if (Test-Path $shadersDir) {
    $backupShadersDir = "$mcDir\shaderpacks_backup_$timestamp"
    Rename-Item $shadersDir $backupShadersDir
    Write-Host "      Shaderpack lama dipindahin ke: shaderpacks_backup_$timestamp" -ForegroundColor Yellow
}
New-Item $shadersDir -ItemType Directory -Force | Out-Null

Write-Host "      Lagi extract shaderpack..." -ForegroundColor Cyan
Expand-Archive $shadersZip -DestinationPath "$tempDir\shaders_extract" -Force

# Shaderpacks tetep dalam bentuk .zip, JANGAN di-extract lagi!
if (Test-Path "$tempDir\shaders_extract\shaderpacks") {
    # Kalo ada folder shaderpacks, copy semua file .zip nya
    $shaderZipFiles = Get-ChildItem -Path "$tempDir\shaders_extract\shaderpacks" -Filter "*.zip"
    if ($shaderZipFiles.Count -gt 0) {
        $shaderZipFiles | ForEach-Object {
            Copy-Item $_.FullName $shadersDir -Force
        }
        Write-Host "      Berhasil copy $($shaderZipFiles.Count) shaderpack" -ForegroundColor Cyan
    } else {
        # Kalo gak ada .zip, copy semua file aja
        Copy-Item "$tempDir\shaders_extract\shaderpacks\*" $shadersDir -Recurse -Force
        $allFiles = Get-ChildItem -Path "$tempDir\shaders_extract\shaderpacks" -File
        Write-Host "      Berhasil copy $($allFiles.Count) file dari folder shaderpacks" -ForegroundColor Cyan
    }
} else {
    # Kalo gak ada folder shaderpacks, cari file .zip langsung (tapi BUKAN mods.zip!)
    $shaderZipFiles = Get-ChildItem -Path "$tempDir\shaders_extract" -Filter "*.zip" -Recurse
    if ($shaderZipFiles.Count -gt 0) {
        $shaderZipFiles | ForEach-Object {
            Copy-Item $_.FullName $shadersDir -Force
        }
        Write-Host "      Berhasil copy $($shaderZipFiles.Count) shaderpack" -ForegroundColor Cyan
    } else {
        Write-Host "      PERHATIAN: Gak nemu file shader di ZIP!" -ForegroundColor Red
    }
}

Write-Host "[7/8] Bikin custom client brand..." -ForegroundColor White
$customBrandJson = @"
{
  "customBrand": "acumalaka"
}
"@
Set-Content -Path $customBrandFile -Value $customBrandJson -Encoding UTF8
Write-Host "      File customclientbrand.json udah dibuat!" -ForegroundColor Green

Write-Host "[8/8] Bersihin sampah..." -ForegroundColor White
Remove-Item $tempDir -Recurse -Force
Write-Host "      Beres!" -ForegroundColor Green

Line
Write-Host "INSTALASI SELESAI!" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "[OK] Mods & shaderpack udah ke-install semua." -ForegroundColor Cyan
Write-Host "[OK] Custom client brand 'acumalaka' udah diset." -ForegroundColor Magenta
Write-Host "[OK] File lama udah di-backup aman kok." -ForegroundColor Yellow
Line

Write-Host ""
Write-Host "[SERVER] INFO SERVER PRIVATE:" -ForegroundColor Cyan -BackgroundColor Black
Write-Host ""
Write-Host "   Server IP: " -NoNewline -ForegroundColor White
Write-Host "$serverIP" -ForegroundColor Green
Write-Host ""

# Copy IP ke clipboard
try {
    Set-Clipboard -Value $serverIP
    Write-Host "[CLIPBOARD] IP Server udah di-copy ke clipboard!" -ForegroundColor Yellow
    Write-Host ""
} catch {
    Write-Host "[INFO] Gagal copy otomatis, tapi tenang!" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "[TUTORIAL] CARA CONNECT KE SERVER:" -ForegroundColor Magenta
Write-Host "   1. Buka Minecraft 1.21.11" -ForegroundColor White
Write-Host "   2. Pilih 'Multiplayer'" -ForegroundColor White
Write-Host "   3. Klik 'Add Server'" -ForegroundColor White
Write-Host "   4. Paste IP: $serverIP" -ForegroundColor Green
Write-Host "   5. Langsung join & main bareng!" -ForegroundColor White
Write-Host ""

DoubleLine
Write-Host ""
Write-Host "  Special thanks to:" -ForegroundColor Yellow
Write-Host "  Arvin, Bang Abi & Bang Dendra" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Have fun gaming together!" -ForegroundColor White
Write-Host ""
DoubleLine

Pause
