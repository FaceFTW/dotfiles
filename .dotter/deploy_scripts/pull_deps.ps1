# Versions for all the binaries we are pulling if they need it

$oh_my_posh_version = "v23.14.2"
$vim_w32_version = "9.1.0516"
$bat_version = "v0.24.0"

# Remove Old stuff
Remove-Item -Path "~/.local/bin/oh-my-posh.exe" -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/vim" -Recurse -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/vim.exe" -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/bat.exe" -ErrorAction Ignore
Remove-Item -Path "~/.local/bin/_bat.ps1" -ErrorAction Ignore

New-Item -ItemType Directory -Name tmp >$null

# Oh-My-Posh
Invoke-WebRequest `
	-Uri "https://github.com/jandedobbeleer/oh-my-posh/releases/download/$oh_my_posh_version/posh-windows-amd64.exe" `
	-Outfile "~/.local/bin/oh-my-posh.exe"

# Vim
Invoke-WebRequest `
	-Uri "https://github.com/vim/vim-win32-installer/releases/download/v$vim_w32_version/gvim_$($vim_w32_version)_x64.zip" `
	-Outfile "tmp/vim.zip"
Expand-Archive -Path "tmp/vim.zip" -DestinationPath tmp >$null
# NOTE This will change with vim version changes
Move-Item -Path tmp/vim/vim91 -Destination ~/.local/bin/vim
New-Item -ItemType SymbolicLink -Path "~/.local/bin/vim.exe" -Value "~/.local/bin/vim/vim.exe" >$null

# bat
Invoke-WebRequest `
	-Uri "https://github.com/sharkdp/bat/releases/download/$bat_version/bat-$bat_version-x86_64-pc-windows-msvc.zip" `
	-OutFile "tmp/bat.zip"
Expand-Archive -Path "tmp/bat.zip" -DestinationPath tmp
Move-Item -Path "tmp/bat-$bat_version-x86_64-pc-windows-msvc/bat.exe" -Destination "~/.local/bin/bat.exe"
Move-Item -Path "tmp/bat-$bat_version-x86_64-pc-windows-msvc/autocomplete/_bat.ps1" -Destination "~/.local/bin/_bat.ps1"

Remove-Item -Path tmp -Recurse