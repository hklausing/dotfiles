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

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
BROWSER=/usr/bin/xdg-open

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


#hk [[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -r ~/.bashrc_case/bash_fzf ]] && source ~/.bashrc_case/bash_fzf


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
true        # set return code to 0, if the last condition failed

# vim: set filetype=bash:
