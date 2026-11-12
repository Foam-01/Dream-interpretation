# Release build that does not trip over a debug build's plugin registrant.
#
# After any debug build or test run, android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
# lists dev-only plugins (integration_test). `flutter build ... --release` keeps that stale file instead of
# writing the release one, and javac then fails with
#   package dev.flutter.plugins.integration_test does not exist
# Deleting the generated file first makes Flutter write the release version (without dev dependencies).
#
# Usage (from DreamApp):
#   .\scripts\build_release.ps1 appbundle --obfuscate --split-debug-info=build/symbols
#   $env:ALLOW_DEBUG_SIGNING = 'true'; .\scripts\build_release.ps1 apk      # local test build only
param(
  [Parameter(Mandatory = $true, Position = 0)][ValidateSet('apk', 'appbundle')][string]$Target,
  [Parameter(ValueFromRemainingArguments = $true)][string[]]$Rest
)
# No ErrorActionPreference=Stop: Flutter writes warnings to stderr, which PowerShell 5.1 would treat as fatal.
Set-Location (Join-Path $PSScriptRoot '..')
$registrant = 'android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java'
if (Test-Path $registrant) { Remove-Item $registrant }
flutter build $Target --release @Rest
exit $LASTEXITCODE
