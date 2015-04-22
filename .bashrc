#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# for examples
case $- in
    *i*) ;;
        *) return;;
esac

# Add vim as default editor
export EDITOR=vim
export TERMINAL=urxvt
export BROWSER=qupzilla
export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# set pager
export PAGER=/usr/bin/most

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Gtk themes 
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

xhost +local:root > /dev/null 2>&1

complete -cf sudo
complete -cf man

# Shopt
shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
shopt -s nocaseglob

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Bash Completion
if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

# Alias definitions.
if [ -x ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Function definitions.
if [ -x ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Prompt definitions.
if [ -x ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

## MISC ALIASES ##
alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias vp='vim PKGBUILD'

alias show='pacman -Si'
alias need='pacman -Qi'
alias missing='pacman -Qk'
alias trash='pacman -Qdt'

alias speedtest='speedtest-cli'

alias tint2='killall -SIGUSR1 tint2'

alias wvdial='sudo wvdial'

# Color man pages
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

## COMPRESSION FUNCTION ##
function compress_() {
   # Credit goes to: Daenyth
   FILE=$1
   shift
   case $FILE in
      *.tar.bz2) tar cjf $FILE $*  ;;
      *.tar.gz)  tar czf $FILE $*  ;;
      *.tgz)     tar czf $FILE $*  ;;
      *.zip)     zip $FILE $*      ;;
      *.rar)     rar $FILE $*      ;;
      *)         echo "Filetype not recognized" ;;
   esac
}

## EXTRACT FUNCTION ##
extract ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# test if a file should be opened normally, or as root (edit)
argc () {
        count=0;
        for arg in "$@"; do
                if [[ ! "$arg" =~ '-' ]]; then count=$(($count+1)); fi;
        done;
        echo $count;
}

edit () { if [[ `argc "$@"` > 1 ]]; then vim $@;
                elif [ $1 = '' ]; then vim;
                elif [ ! -f $1 ] || [ -w $1 ]; then vim $@;
                else
                        echo -n "File is Read-only. Edit as root? (Y/n): "
                        read -n 1 yn; echo;
                        if [ "$yn" = 'n' ] || [ "$yn" = 'N' ];
                            then vim $*;
                            else sudo vim $*;
                        fi
                fi
            }

# cd and ls in one
cl() {
    dir=$1
    if [[ -z "$dir" ]]; then
        dir=$HOME
    fi
    if [[ -d "$dir" ]]; then
        cd "$dir"
        ls
    else
        echo "bash: cl: '$dir': Directory not found"
    fi
}

# test encode & decode base64
decode () {
  echo "$1" | base64 -d ; echo
}

encode () {
  echo "$1" | base64 - ; echo
}



# prompt
PS1="[\u@\h \W]\\$ "
