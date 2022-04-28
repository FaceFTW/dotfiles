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

##
## Cowsay 3.03
##
## Original cowsay (c) 1999-2000 Tony Monroe.
## Original cowsay-psh (c) 2013 Luke Sampson
## Modified 'lite' port for Powershell 7 (c) 2022 Alex "FaceFTW" Westerman
## http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz
##
function docowsay([string] $cowfile, $message, $think) {
	function maxlength($msg) {
		$l = 0; $m = -1
		$msg | ForEach-Object { 
			$l = $_.length
			if ($l -gt $m) { $m = $l }
		}
		return $m
	}

	function construct_balloon($msg, $think) {
		$balloon_lines = @()
		$thoughts = " "
		if (!$msg) { return $balloon_lines, $thoughts }

		$max = maxlength $msg
		$max2 = $max + 2 # border space fudge
		$format = "{0} {1,-$max} {2}"
		$border = @() # up-left, up-right, down-left, down-right, left, right
		if ($think) {
			$thoughts = 'o'
			$border = '()()()'.tochararray()
		}
		elseif ($msg.length -lt 2) {
			$thoughts = '\'
			$border = '<>'.tochararray()
		}
		else {
			$thoughts = '\'
			$border = '/\\/||'.tochararray()
		}

		$middle = if ($msg.length -lt 3) { $null } else {
			$msg[1..($msg.length - 2)] | ForEach-Object { [string]::format($format, $border[4], $_, $border[5]) }
		}
		$last = if ($msg.length -lt 2) { $null } else {
			[string]::format($format, $border[2], $msg[-1], $border[3])
		}

		$balloon_lines += " $('-'*$max2) ", [string]::format($format, $border[0], $msg[0], $border[1])

		if ($middle) { $balloon_lines += $middle }
		$balloon_lines += $last, " $('-'*$max2) "
		($balloon_lines | Where-Object { $_ -ne $null }), $thoughts
	}

	function get_cow([string] $f) {
		 if (!($f.endsWith('.cow'))) { $f += ".cow" }

		$fpath = "$($Env:COWPATH)$($f)"	

		if (!(test-path $fpath)) { "$script:progname: could not find $f cowfile!" }
		$script = Get-Content -raw $fpath
		$script = $script -replace 'binmode STDOUT, ":utf8";[\r]?\n\$the_cow =<<EOC;[\r]\n', '"'
		$script = $script -replace 'EOC', '"'
		$script = $script -replace '\\e', '`e'
		$script = $script -replace '\\N\{U\+([0-9a-fA-F]{4})\}', '`u{$1}'

		$the_cow = ""
		Invoke-Expression $script
		$the_cow
	}

	$cowpath = $Env:COWPATH

	$cowmsg = $message
	if ($cowmsg -is [string]) {
		$cowmsg = $cowmsg.split("`r?`n")
	}
	$balloon_lines, $thoughts = construct_balloon $cowmsg $think

	$the_cow = get_cow $cowfile

	Write-Output ([string]::join("`n", $balloon_lines))
	Write-Output $the_cow
}

function docowthink($cowfile, $message){
	docowsay $cowfile $message $true
}

function doRandomCowsay($message){
	$cowfile = Get-ChildItem -Path $Env:COWPATH -Name | Select-Object -Index $(Get-Random $((Get-ChildItem -Path $Env:COWPATH).Count))

	docowsay $cowfile $message 0
}

function doRandomCowthink($message){
	$cowfile = Get-ChildItem -Path $Env:COWPATH -Name | Select-Object -Index $(Get-Random $((Get-ChildItem -Path $Env:COWPATH).Count))
	docowthink $cowfile $message 1
}


######### ALIAS DEFINITIONS #########
Set-Alias cdl Set-CurrentDir -Option AllScope
Set-Alias git-recurseclean Invoke-GitGCRecursive
Set-Alias cowsay docowsay
Set-Alias cowthink docowthink
Set-Alias cowsay-random doRandomCowsay
Set-Alias cowthink-random doRandomCowthink



######## ENVIRONMENT VARS ########
if (!$env:XDG_CONFIG_HOME) {
	[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$($env:USERPROFILE)\.devenv\", [System.EnvironmentVariableTarget]::User)
}
if (!$env:COWPATH) {
	[Environment]::SetEnvironmentVariable("COWPATH", "$($env:USERPROFILE)\.devenv\cowsay\cows\", [System.EnvironmentVariableTarget]::User)
}
if (!$env:FORTUNE_FILE){
	[Environment]::SetEnvironmentVariable("FORTUNE_FILE", "$($env:USERPROFILE)\.devenv\fortune.txt", [System.EnvironmentVariableTarget]::User)
}


######## STARTUP ########
$qotd = fortune
doRandomCowsay $qotd
oh-my-posh --init --shell pwsh --config "$($env:USERPROFILE)\.devenv\.mytheme.omp.json" | Invoke-Expression
Enable-PoshTransientPrompt
