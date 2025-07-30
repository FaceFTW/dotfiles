# Versions for all the binaries we are pulling if they need it

$oh_my_posh_version = "v26.17.2"
$vim_w32_version = "9.1.1591"
$bat_version = "v0.25.0"

# Remove Old stuff
Remove-Item -Path "~/.local/bin/oh-my-posh.exe" -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/vim" -Recurse -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/vim.exe" -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/bat.exe" -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/_bat.ps1" -ErrorAction Ignore

If(Test-Path -LiteralPath "$Env:USERPROFILE/tmp"){
	Remove-Item -LiteralPath "$Env:USERPROFILE/tmp" -Recurse -Force
}

New-Item -ItemType Directory -Name "tmp" -Path $Env:USERPROFILE  >$null

# Oh-My-Posh
Invoke-WebRequest `
	-Uri "https://github.com/jandedobbeleer/oh-my-posh/releases/download/$oh_my_posh_version/posh-windows-amd64.exe" `
	-Outfile "~/.local/bin/oh-my-posh.exe"

# Vim
Invoke-WebRequest `
	-Uri "https://github.com/vim/vim-win32-installer/releases/download/v$vim_w32_version/gvim_$($vim_w32_version)_x64.zip" `
	-Outfile "$Env:USERPROFILE/tmp/vim.zip"
Expand-Archive -Path "$Env:USERPROFILE/tmp/vim.zip" -DestinationPath "$Env:USERPROFILE/tmp" >$null
# NOTE This will change with vim version changes
Move-Item -Path $Env:USERPROFILE/tmp/vim/vim91 -Destination ~/.local/bin/vim
# New-Item -ItemType SymbolicLink -Path "~/.local/bin/vim.exe" -Value "~/.local/bin/vim/vim.exe" >$null

# bat
Invoke-WebRequest `
	-Uri "https://github.com/sharkdp/bat/releases/download/$bat_version/bat-$bat_version-x86_64-pc-windows-msvc.zip" `
	-OutFile "$Env:USERPROFILE/tmp/bat.zip"
Expand-Archive -Path "$Env:USERPROFILE/tmp/bat.zip" -DestinationPath "$Env:USERPROFILE/tmp"
Move-Item -Path "$Env:USERPROFILE/tmp/bat-$bat_version-x86_64-pc-windows-msvc/bat.exe" -Destination "~/.local/bin/bat.exe"
Move-Item -Path "$Env:USERPROFILE/tmp/bat-$bat_version-x86_64-pc-windows-msvc/autocomplete/_bat.ps1" -Destination "~/.local/bin/_bat.ps1"

Remove-Item -Path $Env:USERPROFILE/tmp -Recurse