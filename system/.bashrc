#
# ~/.bashrc
#

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
[[ -r ~/.bashrc_case/bash_tools ]] && source ~/.bashrc_case/bash_tools
[[ -r ~/.bashrc_case/bash_fzf ]] && source ~/.bashrc_case/bash_fzf

##################################
#=== Set system related values ===

[[ -r ~/.bash_system ]] && source ~/.bash_system
true        # set return code to 0, if the last condition failed

# vim: set filetype=bash:
