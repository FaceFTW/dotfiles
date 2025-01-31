function Set-CurrentDir {
	param($dir)
	Set-Location $dir
	Get-ChildItem
}

function Invoke-GitGCRecursive {
	param($dir)

	$originalpath = $PWD
	foreach ($path in Get-ChildItem $dir -Attributes Directory+Hidden -ErrorAction SilentlyContinue -Filter ".git" -Recurse) {

		Set-Location $path
		Set-Location .\..
		Write-Host -ForegroundColor Yellow "====================================================="
		Write-Host -ForegroundColor Yellow $path
		Write-Host -ForegroundColor Yellow "====================================================="
		git fsck
		git prune
		git gc --aggressive --prune
	}

	Set-Location $originalpath
}

function doAFunny() {
	sh-toy
}

function newClear() {
	Clear-Host
	doAFunny
}

function getUserPath() {
	return [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
}

function appendUserPath($toAppend) {
	$userPath = getUserPath
	[Environment]::SetEnvironmentVariable("Path", $userPath + $toAppend, [EnvironmentVariableTarget]::User)
	Write-Host "Path updated"
}


######### ALIAS DEFINITIONS #########
Set-Alias cdl Set-CurrentDir -Option AllScope
Set-Alias git-recurseclean Invoke-GitGCRecursive
Set-Alias cowsay sh-toy
Set-Alias doFunny doAFunny
Set-Alias clear newClear


######## ENVIRONMENT VARS ########
# if (!$env:FORTUNE_FILE) {
# 	[Environment]::SetEnvironmentVariable("FORTUNE_FILE", "$($env:USERPROFILE)\.config\fortunes.txt", [System.EnvironmentVariableTarget]::User)
# }

######## ADD CHEZMOI EXTERNALS TO PATH ###########
# if (!(getUserPath -match "%USERPROFILE%\\.local\\bin")) {
# 	appendUserPath "%USERPROFILE%\.local\bin;"
# }
# if (!(getUserPath -match "%USERPROFILE%\\.local\\bin\\vim")) {
# 	appendUserPath "%USERPROFILE%\.local\bin\vim;"
# }
# if (!(getUserPath -match "%USERPROFILE%\\.local\\bin\\gsudo")) {
# 	appendUserPath "%USERPROFILE%\.local\bin\gsudo;"
# }
# if (!(getUserPath -match "%USERPROFILE%\\.local\\bin\\btop")) {
# 	appendUserPath "%USERPROFILE%\.local\bin\btop;"
# }

if (Test-Path "$($Env:USERPROFILE)\.local\bin\gsudo"){
	Import-Module -Name "$($Env:USERPROFILE)\.local\bin\gsudo\gsudoModule.psm1"
}

######## STARTUP ########
doAFunny

oh-my-posh --init --shell pwsh --config "$env:USERPROFILE\.config\theme.omp.json" | Invoke-Expression
Enable-PoshTransientPrompt
