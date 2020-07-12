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

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
#alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
# export QT_SELECT=4

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

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
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
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
BROWSER=/usr/bin/xdg-open
# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000

# A colon-separated list of patterns used to ignore saving on the history list.
export HISTIGNORE="&:clear:exit:[bf]g:h *:ls:mount:umount:pwd:[ \t]"


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
