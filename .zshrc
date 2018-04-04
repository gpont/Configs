# Oh My Zsh
source ~/.zshrc_oh_my_zsh

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

# tmux
alias tmux='tmux attach || tmux new'

# ssht
ssht () { ssh -t "$1" 'tmux attach || tmux new' }

# history
h() {
  if [[ -z "$1" ]]; then
    history
  else
    history 0 | grep "$*"
  fi
}

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

# search
ss() { find . | xargs grep "$1" -sl }

alias l='ls -lAh -G'
alias ls='ls -G'
alias g='grep'
alias se='sudoedit'

alias df='df -h'
alias du='du -h --max-depth=1 | sort -h'

alias off='sleep 1; xset dpms force off'

alias deploy='ssh_agent && cap production deploy'

# ssh
ssh_agent() {
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    pkill ssh-agent
    eval $(ssh-agent)
    ssh-add
  fi
}

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
setopt correctall

extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1   ;;
      *.tar.gz)  tar xvzf $1   ;;
      *.tar.xz)  tar xvfJ $1   ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar x $1    ;;
      *.gz)      gunzip $1     ;;
      *.tar)     tar xvf $1    ;;
      *.tbz2)    tar xvjf $1   ;;
      *.tgz)     tar xvzf $1   ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1       ;;
      *)         echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

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

# Weather in Tomsk showing
alias weather='curl wttr.in/Томск'

# Neovim aliases
alias nvim='nocorrect nvim'

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

# Sqlplus `sql user/pass@host`
alias sql='rlwrap -if ~/Applications/SQL*Port/sqlplus.dict -pgreen ~/Applications/SQL*Port/sqlplus'

# Ert Humax 9000 emulator
alias ert='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "http://localhost:1300/emulator.html#" --enable-ipv6 --inspect --auto-open-devtools-for-tabs --disable-web-security --user-data-dir="/Users/gpont/tmp/chrome" --user-agent="Opera/9.80 (Linux 7405b0-smp; U; HbbTV/1.1.1 (; Humax; HD 9000i; 1.00.36; 1.0; ); ce-html/1.0; xx) Presto/2.9.167 Version/11.50"'

# Git rebase with force push
alias grwp='nocorrect git rebase -i origin/master --preserve-merges && git push --force-with-lease origin'

