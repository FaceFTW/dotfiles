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
	# zsh-autosuggestions
	# zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"
HISTORY_IGNORE='(cd *|ls*|pwd|git add .|git commit *)'
HISTFILE="/home/face/.config/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

# Set shell options
set_opts=(
  HIST_FCNTL_LOCK APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS
  HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS SHARE_HISTORY NO_EXTENDED_HISTORY
  NO_HIST_EXPIRE_DUPS_FIRST NO_HIST_FIND_NO_DUPS
)
for opt in "${set_opts[@]}"; do
  setopt "$opt"
done
unset opt set_opts

autoload -Uz jump-into
autoload -Uz remote-reboot

if [[ $(stat -c %a ~/.local/bin/sh-toy) != "755" ]]
then
	chmod 755 ~/.local/bin/sh-toy
fi

# User configuration
export GPG_TTY=$(tty)

# ALIAS
alias la='ls -a'
alias ll='ls -al'
alias clearmemcache="echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias clear="/bin/clear; sh-toy"
alias search='rg -p --glob '\''!node_modules/*'\''  $@'

path+=('/home/face/.local/bin')
eval "$(starship init zsh)"

sh-toy
