#!/bin/sh
# This is separated from the pre_deploy.sh for cleanliness

OH_MY_POSH_VERSION="v24.19.0"
#VIM_VERSION="9.1.0516"
BAT_VERSION="v0.25.0"

# Remove existing bin files
rm -rf ~/.oh-my-zsh
rm -f ~/.local/bin/bat
rm -f ~/.local/bin/bat.bash
rm -f ~/.local/bin/bat.zsh
rm -f ~/.local/bin/oh-my-posh

mkdir tmp

# Oh-My-Posh
curl \
	--output "$HOME/.local/bin/oh-my-posh" \
	-L "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/$OH_MY_POSH_VERSION/posh-linux-amd64"
#	--silent \
chmod +x "$HOME/.local/bin/oh-my-posh"

# Oh-My-ZSH
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

#bat
curl \
	--output tmp/bat.tar.gz \
	-L "https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat-$BAT_VERSION-x86_64-unknown-linux-gnu.tar.gz"
	# --silent \
cd tmp || exit
tar -zxf bat.tar.gz
mv "bat-$BAT_VERSION-x86_64-unknown-linux-gnu/bat" ~/.local/bin/bat
mv "bat-$BAT_VERSION-x86_64-unknown-linux-gnu/autocomplete/bat.bash" ~/.local/bin/bat.bash
mv "bat-$BAT_VERSION-x86_64-unknown-linux-gnu/autocomplete/bat.zsh" ~/.local/bin/bat.zsh
cd .. || exit

# Vim is installed by package manager

rm -rf tmp