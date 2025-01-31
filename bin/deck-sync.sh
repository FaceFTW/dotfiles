#!/bin/zsh

if [[ ! $1 || ! $2 ]]; then
	echo "\033[31mERROR: Not Enough Arguments!\033[0m"
	return 1
fi



echo "\033[33mTesting Connection to ${1}...\033[0m"
ping -c 3 $1 &> /dev/null
if [ $? -ne 0 ]; then
	echo "\033[31mERROR: Destination IP Not Reachable!\033[0m"
	return 1
else
	echo "\033[32m Destination IP Responded to Ping!\033[0m\n"
fi

if [[ $2 =~ "skyrim" ]]; then
	echo "\033[32mGame Selected: Skyrim AE\033[0m"
	echo "\033[33m=============Initializing rsync for Data Folder=============\033[0m"
	rsync -aP -e "ssh -p 22" --delete-before /mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/Skyrim\ Special\ Edition/Data "deck@${1}:/run/media/mmcblk0p1/steamapps/common/Skyrim\ Special\ Edition"	
	if [ $? -ne 0 ]; then
		echo "\033[31mERROR: rsync experienced an issue!\033[0m"
		return $?
	fi
	echo "\033[33m=============Initializing rsync for Load Order=============\033[0m"
	rsync -aP -e "ssh -p 22" --delete-before /mnt/c/Users/awest/AppData/Local/Skyrim\ Special\ Edition "deck@${1}:/home/deck/.steam/steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/AppData/Local"
	if [ $? -ne 0 ]; then
		echo "\033[31mERROR: rsync experienced an issue!\033[0m"
		return $?
	fi
	echo "\033[32mSuccessfully Synced Skyrim AE Install to the Deck!\033[0m"
	return 0
elif [[ $2 =~ "falloutnv" ]]; then
	echo "\033[32mGame Selected: Fallout: New Vegas\033[0m"
	echo "\033[33m=============Initializing rsync for Data Folder=============\033[0m"
	rsync -aP -e "ssh -p 22" --delete-before /mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/Fallout\ New\ Vegas/Data "deck@${1}:/run/media/mmcblk0p1/steamapps/common/Fallout\ New\ Vegas"
	if [ $? -ne 0 ]; then
		echo "\033[31mERROR: rsync experienced an issue!\033[0m"
		return $?
	fi
	echo "\033[33m=============Initializing rsync for Load Order=============\033[0m"
	rsync -aP -e "ssh -p 22" --delete-before /mnt/c/Users/awest/AppData/Local/falloutnv "deck@${1}:/home/deck/.steam/steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/AppData/Local"
	if [ $? -ne 0 ]; then
		echo "\033[31mERROR: rsync experienced an issue!\033[0m"
		return $?
	fi
	echo "\033[32mSuccessfully Synced Fallout: New Vegas Install to the Deck!\033[0m"
	return 0
elif [[ $2 =~ "ggst" ]]; then
	echo "\033[32mGame Selected: GUILTY GEAR -STRIVE-\033[0m"
	echo "\033[33m=============Initializing rsync for Data Folder=============\033[0m"
	rsync -aP -e "ssh -p 22" --delete-before /mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/GUILTY\ GEAR\ STRIVE/RED/Content/Paks/\~mods "deck@${1}:/run/media/mmcblk0p1/steamapps/common/GUILTY\ GEAR\ STRIVE/RED/Content/Paks"
	if [ $? -ne 0 ]; then
		echo "\033[31mERROR: rsync experienced an issue!\033[0m"
		return $?
	fi
	echo "\033[32mSuccessfully Synced GUILTY GEAR -STRIVE- Install to the Deck!\033[0m"
	return 0
elif [[ $2 =~ "cover-art" ]]; then
	echo "\033[32mGame Selected: Steam Library Custom Art\033[0m"
	echo "\033[33m=============Initializing rsync for Data Folder=============\033[0m"
	rsync -aP -e "ssh -p 22" --delete-before /mnt/c/Program\ Files\ \(x86\)/Steam/userdata/113455428/config/grid "deck@${1}:~/.steam/steam/userdata/113455428/config"
	if [ $? -ne 0 ]; then
		echo "\033[31mERROR: rsync experienced an issue!\033[0m"
		return $?
	fi
	echo "\033[32mSuccessfully Synced Steam Library Custom Art to the Deck!\033[0m"
	return 0
fi


echo "\033[31mERROR: Game Not Expected!\033[0m"
