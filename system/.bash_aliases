#
# ~/.bash_aliases
#
# This is an automatic generated file via script system-setup.pl
# Do changes to 10_bash.sdf, remove ~/.bash_aliases and execute
# system-setup 10_bash.sdf
#


############################################################
# Define access to used tools
AWK=$(which awk)
GREP=$(which grep)
LS=$(which ls)
TAC=$(which tac)


# Define system colors
BLACK="\[\033[0;30m\]"
DGRAY="\[\033[1;30m\]"
RED="\[\033[0;31m\]"
LRED="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
LGREEN="\[\033[1;32m\]"
BROWN="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
LBLUE="\[\033[1;34m\]"
PURPLE="\[\033[0;35m\]"
LPURPLE="\[\033[1;35m\]"
DCYAN="\[\033[0;36m\]"
CYAN="\[\033[1;36m\]"
LGRAY="\[\033[0;37m\]"
WHITE="\[\033[1;37m\]"
DEFAULT="\[\033[0m\]"


unset PS1


if [[ "$TERM" = "dumb" ]]; then
    # bash was started from gvim; special handling for PS1
    PS1='\u@\h (\W) \$ '
else
    # Standard console handling
    PS1="$DGRAY-($GREEN\u@\h$DGRAY)"    # user and host
    PS1+="-($RED\t$DGRAY)"              # current time
    PS1+="-($YELLOW\w$DGRAY)-"          # current directory
    if [[ -r /home/$USER/.git-prompt.sh ]]; then
        . /home/$USER/.git-prompt.sh
        export GIT_PS1_SHOWDIRTYSTATE=1
        # Define bash prompt for git branch information
        PS1+="\$(__git_ps1 \"($CYAN%s$DGRAY)-\")"   # current branch name if git path
        PS1+="$DEFAULT\n$ "
    else
        # Define bash prompt
        PS1+="$DEFAULT\n$ "
    fi
fi
export PS1

# disable CAPS-LOCK key
[[ -x /usr/bin/setxkbmap ]] && /usr/bin/setxkbmap -option 'ctrl:nocaps'
#xmodmap /home/$USER/.Xmodmap

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
    mkdir -p $1;
    [ -d $1 ] && cd $1
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
alias pf='ps waux | grep -i'
alias pF='ps waux | grep'

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
alias cdinfo='cd /mnt/heiko/public/Intranet/Info/InfoPool/src/'
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

# Convert FLAC to mp3, keep all metadata
alias flactomp3_256k='find . -name "*.flac" -exec ffmpeg -i {} -ab 256k -map_metadata 0 -id3v2_version 3 {}.mp3 \;'
alias flactomp3_320k='find . -name "*.flac" -exec ffmpeg -i {} -ab 320k -map_metadata 0 -id3v2_version 3 {}.mp3 \;'

# Copy bash setting of current user to root
alias bash4root='sudo /bin/cp ~/.bashrc /root/;sudo /bin/cp ~/.bash_aliases /root/'

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

# makevideodir
makevideodir() {
    mkdir -p data
    mkdir -p data/Video
    mkdir -p data/Video/FullMovie
    mkdir -p data/Video/FullMovie/400
    mkdir -p data/Video/FullMovie/720
    mkdir -p data/Video/Scene
    mkdir -p data/Video/Scene/576
    mkdir -p data/Video/Scene/720
    mkdir -p data/Video/Scene/1080
}
