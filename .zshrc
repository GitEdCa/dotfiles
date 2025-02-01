# ~~~ Path configuration ~~~
setopt extended_glob null_glob

path=(
        $HOME/.local/bin
        $path
)

# Remove duplicate entries and non-existent directories
typeset -U path
path=($^path(N-/))

export PATH

# ~~~ history ~~~
setopt HIST_IGNORE_SPACE # Don't save when prefixed with spaces
setopt HIST_IGNORE_DUPS  # Don't save duplicate lines
setopt SHARE_HISTORY     # Share history between sessions

# ~~~ Prompt ~~~
set -o vi  # use vi keybindings

PURE_GIT_PULL=0

# install pure instructions
# mkdir -p "$HOME/.zsh"
# git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure" 
[ -d $HOME/.zsh/pure ] && fpath+=($HOME/.zsh/pure)

# autocomplete
autoload -U promptinit; promptinit
prompt pure


# ~~~ Aliases ~~~
alias v=nvim
alias scripts='cd $LAB/scripts'
alias c=clear
alias lab='cd $LAB'
alias repos='cd $REPOS'

# ls
alias ls='ls --color=auto'
alias la='ls -lathr'
alias t='tmux'
alias e='exit'

# Git
alias gp='git pull'
alias gs='git status'
alias lg='lazygit'

# dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# ~~~ Completion ~~~
autoload -Uz compinit; compinit -u

zstyle ':completion:*' menu select


# ~~~ Sourcing ~~~

source <(fzf --zsh) # activate fzf
eval "$(zoxide init zsh)" # activate zoxide
