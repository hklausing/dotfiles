#
# ~/.bashrc
#


################################################################################
# My .bashrc version
################################################################################

if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# allow root to execute GUI appliactions
xhost +local:root > /dev/null 2>&1

# set auto completion for sudo
complete -cf sudo

# source bash files
[[ -r ~/.bashrc_case/bash_aliases ]] && source ~/.bashrc_case/bash_aliases
[[ -r ~/.bashrc_case/bash_functions ]] && source ~/.bashrc_case/bash_functions
[[ -r ~/.bashrc_case/bash_colors ]] && source ~/.bashrc_case/bash_colors
[[ -r ~/.bashrc_case/bash_lscolors ]] && source ~/.bashrc_case/bash_lscolors
[[ -r ~/.bashrc_case/bash_variables ]] && source ~/.bashrc_case/bash_variables
[[ -r ~/.bashrc_case/bash_ps1 ]] && source ~/.bashrc_case/bash_ps1

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

#hk alias cp="cp -i"                          # confirm before overwriting something
#hk alias df='df -h'                          # human-readable sizes
#hk #alias free='free -m'                      # show sizes in MB
#hk alias np='nano -w PKGBUILD'
#hk alias more=less
#hk # export QT_SELECT=4

# Check if terminal connection is created via SSH. If variable
# SESSION_TYPE is defined an SSH session is active.
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  export SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) export SESSION_TYPE=remote/ssh ;;
  esac
fi

unset use_color safe_term match_lhs sh

#hk # better yaourt colors
#hk export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

#hk #
#hk # # ex - archive extractor
#hk # # usage: ex <file>
#hk ex ()
#hk {
#hk   if [ -f $1 ] ; then
#hk     case $1 in
#hk       *.tar.bz2)   tar xjf $1   ;;
#hk       *.tar.gz)    tar xzf $1   ;;
#hk       *.bz2)       bunzip2 $1   ;;
#hk       *.rar)       unrar x $1     ;;
#hk       *.gz)        gunzip $1    ;;
#hk       *.tar)       tar xf $1    ;;
#hk       *.tbz2)      tar xjf $1   ;;
#hk       *.tgz)       tar xzf $1   ;;
#hk       *.zip)       unzip $1     ;;
#hk       *.Z)         uncompress $1;;
#hk       *.7z)        7z x $1      ;;
#hk       *)           echo "'$1' cannot be extracted via ex()" ;;
#hk     esac
#hk   else
#hk     echo "'$1' is not a valid file"
#hk   fi
#hk }

#hk colors() {
#hk 	local fgc bgc vals seq0
#hk
#hk 	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
#hk 	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
#hk 	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
#hk 	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"
#hk
#hk 	# foreground colors
#hk 	for fgc in {30..37}; do
#hk 		# background colors
#hk 		for bgc in {40..47}; do
#hk 			fgc=${fgc#37} # white
#hk 			bgc=${bgc#40} # black
#hk
#hk 			vals="${fgc:+$fgc;}${bgc}"
#hk 			vals=${vals%%;}
#hk
#hk 			seq0="${vals:+\e[${vals}m}"
#hk 			printf "  %-9s" "${seq0:-(default)}"
#hk 			printf " ${seq0}TEXT\e[m"
#hk 			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
#hk 		done
#hk 		echo; echo
#hk 	done
#hk }

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
BROWSER=/usr/bin/xdg-open
#hk # Don't put duplicate lines or lines starting with space in the history.
#hk # See bash(1) for more options
#hk export HISTCONTROL=ignoreboth
#hk
#hk # For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#hk export HISTSIZE=10000
#hk
#hk # A colon-separated list of patterns used to ignore saving on the history list.
#hk export HISTIGNORE="&:clear:exit:[bf]g:h *:ls:mount:umount:pwd:[ \t]"


# Load additional aliases and functions
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases

# Set up Git to automatically have Bash shell completion
[[ -r /usr/share/git/completion/git-completion.bash ]] && . /usr/share/git/completion/git-completion.bash

# load tmuxp tool for tmux
[[ -d ~/.local/bin/ ]] && [[ ":$PATH:" != *":~/.local/bin:"* ]] && PATH="${PATH}:~/.local/bin:"

    if [[ -d $HOME/.config/base16-shell/ ]]; then
      # include base16 function
      BASE16_SHELL=$HOME/.config/base16-shell/
      [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
    fi

##################################
#=== Set system related values ===
[[ -r ~/.bash_system ]] && source ~/.bash_system

# start terminal with return code 0
true


[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# load tmuxp tool for tmux
[[ -d ~/.local/bin/ ]] && [[ ":$PATH:" != *":~/.local/bin:"* ]] && PATH="${PATH}:~/.local/bin:"

if [[ -d $HOME/.config/base16-shell/ ]]; then
  # include base16 function
  BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
fi

#if type -p thefuck; then
#    eval $(thefuck --alias)
#fi


##################################
#=== Set system related values ===

[[ -r ~/.bash_system ]] && source ~/.bash_system

