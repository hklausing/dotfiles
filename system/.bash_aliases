#
# ~/.bash_aliases
#
# This script defines common shell environment values.
#


#hk ############################################################
#hk # Define access to used tools
#hk AWK=$(which awk)
#hk GREP=$(which grep)
#hk LS=$(which ls)
#hk TAC=$(which tac)
#hk
#hk
#hk # Define system colors; use script 256-colors.sh
#hk NORM='\[\e[0m\]'
#hk MYBLUE='\[\e[38;5;31m\]'
#hk MYGRAY='\[\e[38;5;238m\]'
#hk MYGREEN='\[\e[38;5;70m\]'
#hk MYRED='\[\e[38;5;166m\]'
#hk MYCYAN='\[\e[38;5;30m\]'
#hk MYYELLOW='\[\e[38;5;227m\]'
#hk
#hk if [[ 1 == 0 ]]; then
#hk unset PS1
#hk if [[ "$TERM" = "dumb" ]]; then
#hk     # bash was started from gvim; special handling for PS1
#hk     PS1='\u@\h (\W) \$ '
#hk else
#hk     # Standard console handling
#hk     PS1="$MYGRAY-(${MYBLUE}\$?${MYGRAY})"   # last return code
#hk     PS1+="-($MYGREEN\u@\h$MYGRAY)"          # user and host
#hk     PS1+="-($MYRED\t$MYGRAY)"               # current time
#hk     PS1+="-($MYYELLOW\w$MYGRAY)-"           # current directory
#hk     if [[ -r /home/$USER/.git-prompt.sh ]]; then
#hk         . /home/$USER/.git-prompt.sh
#hk         export GIT_PS1_SHOWDIRTYSTATE=1
#hk         # Define bash prompt for git branch information
#hk         PS1+="\$(__git_ps1 \"($MYCYAN%s$MYGRAY)-\")"   # current branch name if git path
#hk     fi
#hk     PS1+="$NORM\n\$ "
#hk fi
#hk export PS1
#hk
#hk else
#hk
#hk #    # color definitions
#hk #    COL_GRAY='\[\e[38;5;238m\]'
#hk #    COL_BGRED='\[\e[7;103;31m\]'
#hk #
#hk #    # functional colors
#hk #    C_GRAY=${COL_GRAY}
#hk #    C_RCODE=${COL_BGRED}
#hk #
#hk #__prompt_command()
#hk #{
#hk ##    echo 1
#hk #    local EXIT_CODE=$?
#hk #    local ps="${C_GRAY}"
#hk #    if [[ $EXIT_CODE -gt 0 ]]; then
#hk #        ps="${COL_BGRED} ${EXIT_CODE} ${NORM}${C_GRAY}"
#hk #    fi
#hk #    # Standard console handling
#hk #    #ps="$MYGRAY-(${MYBLUE}\$?${MYGRAY})"   # last return code
#hk #    ps+="-($MYGREEN\u@\h$MYGRAY)"          # user and host
#hk #    ps+="-($MYRED\t$MYGRAY)"               # current time
#hk #    ps+="-($MYYELLOW\w$MYGRAY)-"           # current directory
#hk #    if [[ -r /home/$USER/.git-prompt.sh ]]; then
#hk #        . /home/$USER/.git-prompt.sh
#hk #        export GIT_PS1_SHOWDIRTYSTATE=1
#hk #        # Define bash prompt for git branch information
#hk #        ps+="\$(__git_ps1 \"($MYCYAN%s$MYGRAY)-\")"   # current branch name if git path
#hk #    fi
#hk #    ps+="$NORM\n\$ "
#hk #    PS1=${ps}
#hk #}
#hk #
#hk ##__prompt_command
#hk #export PROMPT_COMMAND=__prompt_command
#hk
#hk [[ -f ~/.bashrc_case/bash_ps1 ]] && source ~/.bashrc_case/bash_ps1
#hk
#hk fi





#hk # Check if terminal connection is created via SSH. If variable
#hk # SESSION_TYPE is defined an SSH session is active.
#hk if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#hk   export SESSION_TYPE=remote/ssh
#hk else
#hk   case $(ps -o comm= -p $PPID) in
#hk     sshd|*/sshd) export SESSION_TYPE=remote/ssh ;;
#hk   esac
#hk fi

## CAPS-LOCK key works as CTRL key
#case $(lsb_release -d) in
#    *Manjaro*) [[ -x /usr/bin/setxkbmap ]] && /usr/bin/setxkbmap -option 'ctrl:nocaps' ;;
# --> Sitzungs- und Startverhalten:
#   Name: Disable CAPS LOCK
#   Beschreibung: Disable CAPS LOCK
#   Befehl: setxkbmap -option caps:none
#   Auslöser: on login
#esac


#######
###
# file list

#hk ## Use trailing slashes
#hk alias ls='${LS} -F --color=auto'
#hk alias ls.='${LS} -aF --color=auto'
#hk
#hk ## Use a long listing format ##
#hk alias ll='${LS} -l --group-directories-first --color=auto'
#hk alias ll.='${LS} -la --group-directories-first --color=auto'
#hk
#hk ## Show directories ##
#hk alias ld='${LS} -l | /bin/grep "^d.*"'
#hk alias ld.='${LS} -la | /bin/grep "^d.*"'
#hk
#hk ## Show hidden files ##
#hk alias lst='${LS} -lrt --color=auto'
#hk alias lst.='${LS} -lart --color=auto'
#hk
#hk ## Use a long listing format in reverse order ##
#hk alias lr='${LS} -lrt --group-directories-first --color=auto'
#hk alias lr.='${LS} -lart --group-directories-first --color=auto'

#hk #######
#hk ###
#hk # Directory change
#hk
#hk ## get rid of command not found ##
#hk alias cd..='cd ..'
#hk
#hk alias ..='cd ..'
#hk alias ...='cd ../..'
#hk alias ..2='cd ../..'
#hk alias ..3='cd ../../..'
#hk alias ..4='cd ../../../..'


#######
###
# Create and change to new directory

#hk mcd () {
#hk     # Create a directory and than change to it
#hk     # e.g. mcd ~/demodir
#hk     #      creates a ~/demodir directory and change to it
#hk     [[ -z "$1" ]] && echo "usage: mcd <directory>" && return
#hk     mkdir -p $1
#hk     if [[ -d $1 ]]; then
#hk         cd $1
#hk     else
#hk         error "ERROR: mcd: $1: directory not created!"
#hk     fi
#hk }
#hk
#hk
#hk ccd() {
#hk     # concatenate names and change to that directory
#hk     # e.g. ccd /home heiko data
#hk     #      this will change directory to /home/heiko/data
#hk     #      equal to ccd ~ data
#hk     local targetdir=
#hk     for item in "$@"; do
#hk         if [[ -z ${targetdir} ]]; then
#hk             targetdir=${item}
#hk         else
#hk             targetdir=${targetdir}/${item}
#hk         fi
#hk     done
#hk     if [[ -d "${targetdir}" ]]; then
#hk         cd "${targetdir}"
#hk     else
#hk         echo "ERROR: ccd: ${targetdir}: directory not found!"
#hk     fi
#hk }

#hk #######
#hk ###
#hk # Helper
#hk
#hk # show history
#hk alias h='history'
#hk
#hk # search in history
#hk alias hf='history | grep -i'
#hk alias hF='history | grep'
#hk
#hk # clean-up history, remove double lines
#hk alias h-cleanup=''
#hk
#hk # search in process list
#hk alias pf='ps -ef | grep -v $$ | grep'
#hk
#hk # environment variables
#hk alias envf='env | grep -i'
#hk alias envF='env | grep'
#hk alias envs='env | sort'
#hk
#hk alias bashrc.='. ~/.bashrc'
#hk alias bashrc='gvim -p ~/.bashrc ~/.bash_aliases'
#hk
#hk # Set vim as default
#hk alias vi='vim -p'
#hk #alias vi='/usr/local/bin/vim -p'
#hk alias gvi='gvim -p'
#hk #alias gvi='/usr/local/bin/gvim -p'
#hk alias svi='sudo vi'
#hk alias vis='vim "+set si"'
#hk alias ed='editor'
#hk
#hk
#hk ######
#hk ###
#hk # systemd helper
#hk alias sctl='sudo systemctl'
#hk alias poweroff='sudo systemctl poweroff -i'
#hk alias reboot='sudo systemctl reboot -i'
#hk
#hk
#hk ######
#hk ###
#hk # Switch to working directories
#hk alias cdcpp='ccd ~/prj/SW/cpp'
#hk alias cdperl='ccd ~/prj/SW/perl'
#hk alias cdmytools='ccd ~/prj/SW/system/mytools'
#hk alias cdprj='ccd ~/prj'


#hk # Cleans doubles from the history file
#hk alias history-clean-up="\
#hk   /bin/cp ~/.bash_history ~/.bash_history.last;\
#hk   ${GREP} -vP \"^(h|history) -d \d+\" ~/.bash_history | ${TAC} | ${AWK} \"!x[\\\$0]++\" | ${TAC} > ~/.bash-history; \
#hk   [ -f ~/.bash-history ] && mv ~/.bash-history ~/.bash_history\
#hk "


#hk # Terminal colors
#hk color-tests() {
#hk     echo ; echo -n "Current used colors (via tput): " ; tput colors ; echo
#hk     for x in 0 1 4 5 7 8; do for i in `seq 30 37`; do for a in `seq 40 47`; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";
#hk }

#hk # Execute update & upgrade
#hk case $(lsb_release -d) in
#hk     *Manjaro*) ;;
#hk     *Debian*)  alias system-update='sudo apt-get update;sudo apt-get upgrade' ;;
#hk esac


#hk # extract files. Ignore files with improper extensions.
#hk # Usage: extract file.zip [file2.bz2 ..]
#hk extract () {
#hk     local x
#hk     # echo and execute
#hk     ee() {
#hk         echo "$@"
#hk         $1 "$2"
#hk     }
#hk     for x in "$@"; do
#hk         [[ -f $x ]] || continue
#hk         case "$x" in
#hk             *.tar.bz2 | *.tbz2 )    ee "tar xvjf" "$x"  ;;
#hk             *.tar.gz | *.tgz )      ee "tar xvzf" "$x"  ;;
#hk             *.bz2 )                 ee "bunzip2" "$x"   ;;
#hk             *.rar )                 ee "unrar x" "$x"   ;;
#hk             *.gz )                  ee "gunzip" "$x"    ;;
#hk             *.tar )                 ee "tar xvf" "$x"   ;;
#hk             *.zip )                 ee "unzip" "$x"     ;;
#hk             *.Z )                   ee "uncompress" "$x";;
#hk             *.7z )                  ee "7z x" "$x"      ;;
#hk         esac
#hk     done
#hk }

#hk ############################
#hk #=== FuzzyFind Functions ===
#hk
#hk # for following functions fuzzy finder must be available
#hk if type -p fzf >/dev/null; then
#hk
#hk     # fp - Find Process
#hk     #   usage: fp
#hk     # Select one or multiple processes
#hk     fp() {
#hk         ps waux | fzf +s --multi
#hk     }
#hk
#hk
#hk     # killp - Kill Process[es]
#hk     #   usage: killp [QUERY] [-SIGNAL]
#hk     # Select one or multiple processes
#hk     killp() {
#hk         local QUERY=
#hk         local SIGNAL=
#hk         [[ "$#" -eq 1 && ${1:0:1} != '-' ]] && QUERY=${1}
#hk         [[ "$#" -eq 1 && ${1:0:1} == '-' ]] && SIGNAL=${1}
#hk         [[ "$#" -eq 2 ]] && { QUERY=${1}; SIGNAL=${2}; }
#hk         ps -ef | sed 1d | fzf --multi --query=${QUERY} | awk '{print $2}' | xargs kill ${SIGNAL} ;
#hk     }
#hk
#hk
#hk     # preview - Pre View file content
#hk     #   usage: preview
#hk     # Select one or multiple processes
#hk     preview() {
#hk         fzf --multi --preview="head -$LINES {}"
#hk     }
#hk
#hk
#hk     # fshow - git commit browser
#hk     fshow() {
#hk       local out sha q
#hk       while out=$(
#hk           git log --graph --color=always \
#hk               --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
#hk           fzf --ansi --multi --no-sort --reverse --query="$q" --print-query); do
#hk         q=$(head -1 <<< "$out")
#hk         while read sha; do
#hk           git show --color=always $sha | less -R
#hk         done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
#hk       done
#hk     }
#hk
#hk fi


#hk ##################################
#hk #=== Set system related values ===
#hk
#hk [[ -r ~/.bash_system ]] && source ~/.bash_system

