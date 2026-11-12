# Creates the Play upload key once, outside the repo. keytool asks for the password and owner details itself;
# nothing is stored by this script. It never overwrites an existing key: losing or replacing the upload key
# means asking Google to reset it.
#
# Usage (from DreamApp):  powershell -ExecutionPolicy Bypass -File scripts/create_upload_key.ps1
$keysDir = Join-Path $PSScriptRoot '..\..\keys'
$keystore = Join-Path $keysDir 'upload-keystore.jks'
if (Test-Path $keystore) {
  Write-Host "Upload key already exists: $keystore (not overwritten)."
  exit 1
}
$keytool = Get-ChildItem 'C:\Program Files\Android' -Recurse -Filter keytool.exe -ErrorAction SilentlyContinue |
  Select-Object -First 1 -ExpandProperty FullName
if (-not $keytool) { $keytool = (Get-Command keytool -ErrorAction SilentlyContinue).Source }
if (-not $keytool) {
  Write-Host 'keytool not found. Install Android Studio or a JDK first.'
  exit 1
}
New-Item -ItemType Directory -Force $keysDir | Out-Null
& $keytool -genkeypair -v -keystore $keystore -alias upload -keyalg RSA -keysize 2048 -validity 10000
if ($LASTEXITCODE -eq 0) { Write-Host "Created $keystore. Back up this file and its password now." }
exit $LASTEXITCODE
