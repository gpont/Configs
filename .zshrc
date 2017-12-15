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
    #eval ${color}_bold='%{$fg_bold[${color}]%}'
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

# PROMPT="${host}${bracket_o}${magenta}%2~${bracket_c}${reset} "
# RPROMPT='$vcs_info_msg_0_'"$reset"

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
export BROWSER="chromium-browser"

# grep colors
export GREP_COLORS="mt=33"
export GREP_OPTIONS='--color=auto'

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

alias l='ls -lAh --color=auto --group-directories-first'
alias ls='ls --color=auto --group-directories-first'
alias g='grep'
alias se='sudoedit'

alias df='df -h'
alias du='du -h --max-depth=1 | sort -h'

alias off='sleep 1; xset dpms force off'

# timer
tm() { (sleep "$1" && cd /storage/music/fav && mpg123 -q "$(ls | shuf -n1)" ) & }
 t() { (sleep "$1" && mpg123 -q /storage/dropbox/sound/mailinbox.mp3 ) & }

# aptitude
alias  a='nocorrect sudo aptitude install'
alias au='nocorrect sudo aptitude update && sudo aptitude safe-upgrade'
alias ai='aptitude show'
alias as='aptitude search'
alias arm='nocorrect sudo aptitude remove'
alias aptitude='nocorrect aptitude'

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
    #eval ${color}_bold='%{$fg_bold[${color}]%}'
done

reset="%{$reset_color%}"

# Promt
# if [ "$EUID" -eq 0 ]; then
#   PROMPT="${host}${red}[${magenta}%2`${red}]${reset} " # root
# else
#   PROMPT="${host}${black}[${magenta}%2`${black}]${reset} " # user
# fi

setopt notify
setopt correctall

# Coloring aptitude search
aptsearch ()
{
    # Search and highlight keyword  in the restuls
    export GREP_COLOR='1'
    # Remove regexp patterns from the keyword to highlight
    keyword=`echo -n "$1" | sed -e 's/[^[:alnum:]|-]//g'`
    echo_bold "Highlight keyword: $keyword"
    aptitude search "$1" --disable-columns | egrep --color "$keyword" 

    # Use the matching results to complete our install command
    matching=$(aptitude search --disable-columns -F "%p" "$1" | tr '\n' ' ') 
    count=0
    for i in $matching ; do
        count=$((count + 1))
    done
    complete -W '$matching' aptinstall
    echo_bold "(Matching packages: $count)"
    if ! [ -z $2 ] ; then
        echo -e "$matching" | egrep --color=always "$keyword"
    fi
}

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

# for magit emacs plugin on mac 
[[ $TERM == "dumb" ]] && {
    # Reset shell so Tramp could parse the prompt
    unsetopt zle
    PS1='$ '
} || {
    # Do other stuff
    test -e "${HOME}/.iterm2_shell_integration.zsh"
    source "${HOME}/.iterm2_shell_integration.zsh"
}

# Sqlplus aliases
alias sql='rlwrap -if ~/.oracle/sqlplus.dict -pgreen sqlplus'
