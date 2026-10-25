fpath=( ~/.config/zsh/.zfuncs "${fpath[@]}" )
export ZSH="$HOME/.config/zsh/.oh-my-zsh"
export ZSHZ_DATA=$HOME/.config/z_data

zstyle ':omz:update' mode disabled
COMPLETION_WAITING_DOTS="true"

plugins=(
	colorize
	colored-man-pages
	cp
	dircycle
	fancy-ctrl-z
	gh
	git-extras
	gitfast
	lol
	npm
	rsync
	rust
	systemd
	uv
	z
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

autoload -Xu jump-into
autoload -Xu remote-reboot

if [[ $(stat -c %a ~/.local/bin/sh-toy) != "755" ]]
then
	chmod 755 ~/.local/bin/sh-toy
fi

# User configuration
export GPG_TTY=$(tty)

# ALIAS
alias zshconfig="vim ~/.zshrc"
alias clearmemcache="echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias clear="/bin/clear; sh-toy"

path+=('/home/face/.local/bin')
eval "$(starship init zsh)"

sh-toy
