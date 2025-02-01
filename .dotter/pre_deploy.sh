# mode:Handlebars

{{#if (eq dotter.os "windows")}}
@echo off
REM Check if Powershell 7 is installed
REM If it isn't, install it via winget
where.exe /Q pwsh.exe
if %ERRORLEVEL% EQU 0 goto pwsh_exists
winget install Microsoft.PowerShell

:pwsh_exists
pwsh -NoLogo -NoProfile -File .dotter/deploy_scripts/pull_deps.ps1
{{/if}}
{{$if (eq dotter.os "unix")}}
{{$if (eq arch "x86_64")}}
chmod +x .dotter/deploy_scripts/deploy_linux.sh
sh .dotter/deploy_scripts/deploy_linux.sh
{{/if}}
{{$if (eq arch "arm64")}}
chmod +x .dotter/deploy_scripts/deploy_linux_arm.sh
sh .dotter/deploy_scripts/deploy_linux_arm.sh
{{/if}}
{{/if}}