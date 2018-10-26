#
# ~/.bash_aliases
#
# This script defines common shell environment values.
#


############################################################
# Define access to used tools
AWK=$(which awk)
GREP=$(which grep)
LS=$(which ls)
TAC=$(which tac)


# Define system colors; use script 256-colors.sh
NORM='\[\e[0m\]'
MYBLUE='\[\e[38;5;31m\]'
MYGRAY='\[\e[38;5;238m\]'
MYGREEN='\[\e[38;5;70m\]'
MYRED='\[\e[38;5;166m\]'
MYCYAN='\[\e[38;5;30m\]'
MYYELLOW='\[\e[38;5;227m\]'

unset PS1
if [[ "$TERM" = "dumb" ]]; then
    # bash was started from gvim; special handling for PS1
    PS1='\u@\h (\W) \$ '
else
    # Standard console handling
    PS1="$MYGRAY-(${MYBLUE}\$?${MYGRAY})"   # last return code
    PS1+="-($MYGREEN\u@\h$MYGRAY)"          # user and host
    PS1+="-($MYRED\t$MYGRAY)"               # current time
    PS1+="-($MYYELLOW\w$MYGRAY)-"           # current directory
    if [[ -r /home/$USER/.git-prompt.sh ]]; then
        . /home/$USER/.git-prompt.sh
        export GIT_PS1_SHOWDIRTYSTATE=1
        # Define bash prompt for git branch information
        PS1+="\$(__git_ps1 \"($MYCYAN%s$MYGRAY)-\")"   # current branch name if git path
    fi
    PS1+="$NORM\n\$ "
fi
export PS1

# Check if terminal connection is created via SSH. If variable
# SESSION_TYPE is defined an SSH session is active.
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  export SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) export SESSION_TYPE=remote/ssh ;;
  esac
fi

# CAPS-LOCK key works as CTRL key
case $(lsb_release -d) in
    *Manjaro*) [[ -x /usr/bin/setxkbmap ]] && /usr/bin/setxkbmap -option 'ctrl:nocaps' ;;
esac


#######
###
# file list

## Use trailing slashes
alias ls='${LS} -F --color=auto'
alias ls.='${LS} -aF --color=auto'

## Use a long listing format ##
alias ll='${LS} -l --group-directories-first --color=auto'
alias ll.='${LS} -la --group-directories-first --color=auto'

## Show directories ##
alias ld='${LS} -l | /bin/grep "^d.*"'
alias ld.='${LS} -la | /bin/grep "^d.*"'

## Show hidden files ##
alias lst='${LS} -lrt --color=auto'
alias lst.='${LS} -lart --color=auto'

## Use a long listing format in reverse order ##
alias lr='${LS} -lrt --group-directories-first --color=auto'
alias lr.='${LS} -lart --group-directories-first --color=auto'

#######
###
# Directory change

## get rid of command not found ##
alias cd..='cd ..'

alias ..='cd ..'
alias ...='cd ../..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'

alias cdprj="_cd ~/prj $1"

#######
###
# Create and change to new directory

mcd () {
    [[ -z "$1" ]] && echo "usage: mcd <directory>" && return
    mkdir -p $1
    if [[ -d $1 ]]; then
        cd $1
    else
        error "ERROR: directory $1 not found!"
    fi
}


_cd() {
    if [[ -d "$1/$2" ]]; then
        cd "$1/$2"
    else
        echo "Directory $1/$2 not found!"
        ls $1
    fi
}

#######
###
# Helper

# show history
alias h='history'

# search in history
alias hf='history | grep -i'
alias hF='history | grep'

# clean-up history, remove double lines
alias h-cleanup=''

# search in process list
alias pf='ps -ef | grep -v $$ | grep'

# environment variables
alias envf='env | grep -i'
alias envF='env | grep'
alias envs='env | sort'

alias bashrc.='. ~/.bashrc'
alias bashrc='gvim -p ~/.bashrc ~/.bash_aliases'

# Set vim as default
alias vi='vim -p'
#alias vi='/usr/local/bin/vim -p'
alias gvi='gvim -p'
#alias gvi='/usr/local/bin/gvim -p'
alias svi='sudo vi'
alias vis='vim "+set si"'
alias ed='editor'


######
###
# systemd helper
alias sctl='sudo systemctl'
alias poweroff='sudo systemctl poweroff -i'
alias reboot='sudo systemctl reboot -i'


######
###
# Switch to working directories
alias cdcpp='_cd ~/prj/SW/cpp'
alias cdperl='_cd ~/prj/SW/perl'
alias cdmytools='cd ~/prj/SW/system/mytools'


# Cleans doubles from the history file
alias history-clean-up="\
/bin/cp ~/.bash_history ~/.bash_history.last;\
${GREP} -vP \"^(h|history) -d \d+\" ~/.bash_history | ${TAC} | ${AWK} \"!x[\\\$0]++\" | ${TAC} > ~/.bash-history; \
[ -f ~/.bash-history ] && mv ~/.bash-history ~/.bash_history\
"


# Terminal colors
color-tests() {
    echo ; echo -n "Current used colors (via tput): " ; tput colors ; echo
    for x in 0 1 4 5 7 8; do for i in `seq 30 37`; do for a in `seq 40 47`; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";
}

# Execute update & upgrade
alias system-update='sudo apt-get update;sudo apt-get upgrade'


# extract files. Ignore files with improper extensions.
# Usage: extract file.zip [file2.bz2 ..]
extract () {
    local x
    # echo and execute
    ee() {
        echo "$@"
        $1 "$2"
    }
    for x in "$@"; do
        [[ -f $x ]] || continue
        case "$x" in
            *.tar.bz2 | *.tbz2 )    ee "tar xvjf" "$x"  ;;
            *.tar.gz | *.tgz )      ee "tar xvzf" "$x"  ;;
            *.bz2 )                 ee "bunzip2" "$x"   ;;
            *.rar )                 ee "unrar x" "$x"   ;;
            *.gz )                  ee "gunzip" "$x"    ;;
            *.tar )                 ee "tar xvf" "$x"   ;;
            *.zip )                 ee "unzip" "$x"     ;;
            *.Z )                   ee "uncompress" "$x";;
            *.7z )                  ee "7z x" "$x"      ;;
        esac
    done
}

############################
#=== FuzzyFind Functions ===

# for following functions fuzzy finder must be available
if type -p fzf >/dev/null; then

    # fp - Find Process
    #   usage: fp
    # Select one or multiple processes
    fp() {
        ps waux | fzf +s --multi
    }


    # killp - Kill Process[es]
    #   usage: killp [QUERY] [-SIGNAL]
    # Select one or multiple processes
    killp() {
        local QUERY=
        local SIGNAL=
        [[ "$#" -eq 1 && ${1:0:1} != '-' ]] && QUERY=${1}
        [[ "$#" -eq 1 && ${1:0:1} == '-' ]] && SIGNAL=${1}
        [[ "$#" -eq 2 ]] && { QUERY=${1}; SIGNAL=${2}; }
        ps -ef | sed 1d | fzf --multi --query=${QUERY} | awk '{print $2}' | xargs kill ${SIGNAL} ;
    }


    # preview - Pre View file content
    #   usage: preview
    # Select one or multiple processes
    preview() {
        fzf --multi --preview="head -$LINES {}"
    }


    # fshow - git commit browser
    fshow() {
      local out sha q
      while out=$(
          git log --graph --color=always \
              --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
          fzf --ansi --multi --no-sort --reverse --query="$q" --print-query); do
        q=$(head -1 <<< "$out")
        while read sha; do
          git show --color=always $sha | less -R
        done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
      done
    }

fi


##################################
#=== Set system related values ===

[[ -r ~/.bash_system ]] && source ~/.bash_system

