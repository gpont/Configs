# Oh My Zsh
source ~/.zsh/oh_my_zsh.zshrc

# -----------------------------
# Prompt + Title
# -----------------------------

# colors
export TERM='xterm-256color'
autoload -U colors && colors

for color in red green yellow blue magenta cyan black white; do
    eval $color='%{$fg_no_bold[${color}]%}'
done

reset="%{$reset_color%}"

# Add ssh-agent on login
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s` &> /dev/null
  ssh-add &> /dev/null
fi

# check if we are on SSH or not
if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
  host="${black}[${blue}%m${black}] " #SSH
else
  unset host # no SSH
fi

# git
setopt prompt_subst
autoload -U add-zsh-hook
autoload -Uz vcs_info

add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*'   enable git
zstyle ':vcs_info:*:*' check-for-changes true # Can be slow on big repos.
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' actionformats "${black}[${cyan}%b%u%c %a${black}]"
zstyle ':vcs_info:*:*' formats       "${black}[${cyan}%b%u%c${black}]"

# root / user
if [ "$EUID" -eq 0 ]; then
  bracket_o="${red}["
  bracket_c="${red}]"
else
  bracket_o="${black}["
  bracket_c="${black}]"
fi

# title
case $TERM in
  xterm*|rxvt*|screen*)
    precmd() { print -Pn "\e]0;%m:%~\a" }
    preexec () { print -Pn "\e]0;$1\a" }
  ;;
esac

# -----------------------------
# Misc
# -----------------------------

# zsh
setopt auto_cd
setopt extended_glob
setopt interactive_comments

# better word separators (ctrl-w will become much more useful)
WORDCHARS=''

# editor
export EDITOR="nvim"

# grep colors
export GREP_COLORS="mt=33"
export GREP_OPTIONS='-G'

# disable speaker
unsetopt beep

# -----------------------------
# History
# -----------------------------

HISTFILE=$HOME/.zsh_history
HISTSIZE=9999
SAVEHIST=9999

setopt extended_history

setopt inc_append_history
setopt share_history

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# -----------------------------
# Completion
# -----------------------------

# Enable zsh auto-completion
autoload -U compinit && compinit

_comp_options+=(globdots) # completion fot dotfiles

zstyle ':completion:*' menu select

# -----------------------------
# Bindings
# -----------------------------

# emacs style
bindkey -e

bindkey "\e[3~" delete-char #delete

bindkey "^[[H"  beginning-of-line #home
bindkey "^[[F"  end-of-line       #end

bindkey "^[[A"  history-beginning-search-backward #up
bindkey "^[[B"  history-beginning-search-forward  #down
bindkey '^R' history-incremental-search-backward #Ctrl+Rs

bindkey '^[[1;5D'   backward-word #ctrl+left
bindkey '^[[1;5C'   forward-word  #ctrl+right

# -----------------------------
# Aliases
# -----------------------------

# permissions
perms() {
  if [[ -z "$1" ]]; then
    find .    -type d -print0 | xargs -0 chmod 700
    find .    -type f -print0 | xargs -0 chmod 600
  else
    find "$*" -type d -print0 | xargs -0 chmod 700
    find "$*" -type f -print0 | xargs -0 chmod 600
  fi
}
permsg() {
  if [[ -z "$1" ]]; then
    find .    -type d -print0 | xargs -0 chmod 770
    find .    -type f -print0 | xargs -0 chmod 660
  else
    find "$*" -type d -print0 | xargs -0 chmod 770
    find "$*" -type f -print0 | xargs -0 chmod 660
  fi
}

alias l='ls -lAh -G'
alias ls='ls -G'
alias df='df -h'
alias du='du -h --max-depth=1 | sort -h'

# PATHS
[[ -s /etc/profile.d/autojump.sh ]] && . /etc/profile.d/autojump.sh

# source ~/.profile

# Colors
autoload -U colors && colors

for color in red green yellow blue magenta cyan black white; do
    eval $color='%{$fg_no_bold[${color}]%}'
done

reset="%{$reset_color%}"

setopt notify

# Disable autocorrect
unsetopt correct_all

if [ -f /usr/bin/grc ]; then
	alias ping='grc --colour=auto ping'
	alias traceroute='grc --colour=auto traceroute'
	alias make='grc --colour=auto make'
	alias diff='grc --colour=auto diff»'
	alias cvs='grc --colour=auto cvs'
	alias netstatinstall='grc --colour=auto netstat'
	alias logc="grc cat"
	alias tail='grc --colour=auto tail -n 200 -f'
	alias logh="grc head"
fi

# Ror magit emacs plugin on mac
[[ $TERM == "dumb" ]] && {
    # Reset shell so Tramp could parse the prompt
    unsetopt zle
    PS1='$ '
} || {
    # Do other stuff
    test -e "${HOME}/.iterm2_shell_integration.zsh"
    source "${HOME}/.iterm2_shell_integration.zsh"
}

# Nvm configure
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Zshrc edit
alias zshrc='code ~/.zshrc'

# Bat (https://github.com/sharkdp/bat)
alias cat='bat'
