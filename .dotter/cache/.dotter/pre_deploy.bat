# mode:Handlebars

@echo off
REM Check if Powershell 7 is installed
REM If it isn't, install it via winget
where.exe /Q pwsh.exe
if %ERRORLEVEL% EQU 0 goto pwsh_exists
winget install Microsoft.PowerShell

:pwsh_exists
pwsh -NoLogo -NoProfile -File .dotter/deploy_scripts/pull_deps.ps1
