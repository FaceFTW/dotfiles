@echo off

mkdir temp

REM Get all the binaries we want


REM RipGrep by BurntSushi (https://github.com/BurntSushi/ripgrep)
curl -L 'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-pc-windows-msvc.zip' --output rg.zip
tar -xvf rg.zip
cd ripgrep-*-msvc
COPY /Y /B rg.exe %USERPROFILE%\.devenv\bin\rg.exe
if exist %USERPROFILE%\Documents\Powershell\Microsoft.PowerShell_profile.ps1(
	COPY /Y /B autocomplete\_rg.ps1 %USERPROFILE%\Documents\Powershell
REM Add powershell umblock later (can do it myself for now)
)
cd ..

REM fd by sharkdp (https://github.com/sharkdp/fd)
curl -L 'https://github.com/sharkdp/fd/releases/download/v8.3.2/fd-v8.3.2-x86_64-pc-windows-msvc.zip' --output fd.zip
tar -xvf fd.zip
cd fd-*-msvc
COPY /Y /B fd.exe %USERPROFILE%\.devenv\bin\fd.exe
if exist %USERPROFILE%\Documents\Powershell\Microsoft.PowerShell_profile.ps1(
	COPY /Y /B autocomplete\_fd.ps1 %USERPROFILE%\Documents\Powershell
REM Add powershell umblock later (can do it myself for now)
)
cd ..\..

DELTREE temp

