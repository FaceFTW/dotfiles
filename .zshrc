# Should make things explicit
export LANG=en_US.UTF-8
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_ALL="en_US.UTF-8"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Oh My Zsh Plugins
plugins=(colorize colored-man-pages dircycle cp lol {{ if ne .chezmoi.hostname "steamdeck" }} vscode ssh-agent gpg-agent {{ end }})
{{ if ne .chezmoi.hostname "steamdeck" }}
zstyle :omz:plugins:keychain agents gpg,ssh
zstyle :omz:plugins:keychain options --quiet --quick --noask
zstyle :omz:plugins:ssh-agent lazy yes
{{ end }}

source $ZSH/oh-my-zsh.sh

if [[ $(stat -c %a ~/.local/bin/sh-toy) != "755" ]]
then
	chmod 755 ~/.local/bin/sh-toy
fi

# User configuration
export GPG_TTY=$(tty)

# ALIAS
alias zshconfig="vim ~/.zshrc"
alias doafunny="sh-toy"
alias clearmemcache="echo 3 | sudo tee /proc/sys/vm/drop_caches"

alias clear="/bin/clear; sh-toy"

path+=('/home/face/.local/bin')
eval "$(oh-my-posh --init --shell zsh --config ~/.config/.mytheme.omp.json)"
enable_poshtransientprompt

sh-toy