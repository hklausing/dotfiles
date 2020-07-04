#
# ~/.bashrc
#

# Set following variable to 1 to start with default .bashrc settings
DEFAULT_BASHRC=0


if ((DEFAULT_BASHRC == 1)); then

    ################################################################################
    # Default .bashrc version
    ################################################################################


    [[ $- != *i* ]] && return

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

    [ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

    # Change the window title of X terminals
    case ${TERM} in
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
            PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
            ;;
        screen*)
            PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
            ;;
    esac

    use_color=true

    # Set colorful PS1 only on colorful terminals.
    # dircolors --print-database uses its own built-in database
    # instead of using /etc/DIR_COLORS.  Try to use the external file
    # first to take advantage of user additions.  Use internal bash
    # globbing instead of external grep binary.
    safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
    match_lhs=""
    [[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
    [[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
    [[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
    [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

    if ${use_color} ; then
        # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
        if type -P dircolors >/dev/null ; then
            if [[ -f ~/.dir_colors ]] ; then
                eval $(dircolors -b ~/.dir_colors)
            elif [[ -f /etc/DIR_COLORS ]] ; then
                eval $(dircolors -b /etc/DIR_COLORS)
            fi
        fi

        if [[ ${EUID} == 0 ]] ; then
            PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
        else
            PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
        fi

        alias ls='ls --color=auto'
        alias grep='grep --colour=auto'
        alias egrep='egrep --colour=auto'
        alias fgrep='fgrep --colour=auto'
    else
        if [[ ${EUID} == 0 ]] ; then
            # show root@ when we don't have colors
            PS1='\u@\h \W \$ '
        else
            PS1='\u@\h \w \$ '
        fi
    fi

    unset use_color safe_term match_lhs sh

    alias cp="cp -i"                          # confirm before overwriting something
    alias df='df -h'                          # human-readable sizes
    alias free='free -m'                      # show sizes in MB
    alias np='nano -w PKGBUILD'
    alias more=less

    xhost +local:root > /dev/null 2>&1

    complete -cf sudo

    # Bash won't get SIGWINCH if another process is in the foreground.
    # Enable checkwinsize so that bash will check the terminal size when
    # it regains control.  #65623
    # http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
    shopt -s checkwinsize

    shopt -s expand_aliases

    # export QT_SELECT=4

    # Enable history appending instead of overwriting.  #139609
    shopt -s histappend

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


else

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

    [[ -f ~/.bashrc_contents/bash_aliases ]] && source ~/.bashrc_contents/bash_aliases
    [[ -f ~/.bashrc_contents/bash_functions ]] && source ~/.bashrc_contents/bash_functions
    [[ -f ~/.bashrc_contents/bash_colors ]] && source ~/.bashrc_contents/bash_colors
    [[ -f ~/.bashrc_contents/bash_lscolors ]] && source ~/.bashrc_contents/bash_lscolors
    [[ -f ~/.bashrc_contents/bash_variables ]] && source ~/.bashrc_contents/bash_variables

    # Bash won't get SIGWINCH if another process is in the foreground.
    # Enable checkwinsize so that bash will check the terminal size when
    # it regains control.  #65623
    # http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
    shopt -s checkwinsize

    # ???
    shopt -s expand_aliases

    alias cp="cp -i"                          # confirm before overwriting something
    alias df='df -h'                          # human-readable sizes
    #alias free='free -m'                      # show sizes in MB
    alias np='nano -w PKGBUILD'
    alias more=less
    # export QT_SELECT=4

    # Enable history appending instead of overwriting.  #139609
    shopt -s histappend

    # Change the window title of X terminals
    case ${TERM} in
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
            PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
            ;;
        screen*)
            PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
            ;;
    esac

    use_color=true

    # Set colorful PS1 only on colorful terminals.
    # dircolors --print-database uses its own built-in database
    # instead of using /etc/DIR_COLORS.  Try to use the external file
    # first to take advantage of user additions.  Use internal bash
    # globbing instead of external grep binary.
    safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
    match_lhs=""
    [[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
    [[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
    [[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
    [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

    if [[ ${use_color} == "true" ]] ; then
        # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
        if type -P dircolors >/dev/null ; then
            if [[ -f ~/.dir_colors ]] ; then
                eval $(dircolors -b ~/.dir_colors)
            elif [[ -f /etc/DIR_COLORS ]] ; then
                eval $(dircolors -b /etc/DIR_COLORS)
            fi
        fi

        if [[ ${EUID} == 0 ]] ; then
            PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
        else
            PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
        fi

        alias ls='ls --color=auto'
        alias grep='grep --colour=auto'
        alias egrep='egrep --colour=auto'
        alias fgrep='fgrep --colour=auto'
    else
        if [[ ${EUID} == 0 ]] ; then
            # show root@ when we don't have colors
            PS1='\u@\h \W \$ '
        else
            PS1='\u@\h \w \$ '
        fi
    fi

    unset use_color safe_term match_lhs sh

    # better yaourt colors
    export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

#   #
#   # # ex - archive extractor
#   # # usage: ex <file>
#   ex ()
#   {
#     if [ -f $1 ] ; then
#       case $1 in
#         *.tar.bz2)   tar xjf $1   ;;
#         *.tar.gz)    tar xzf $1   ;;
#         *.bz2)       bunzip2 $1   ;;
#         *.rar)       unrar x $1   ;;
#         *.gz)        gunzip $1    ;;
#         *.tar)       tar xf $1    ;;
#         *.tbz2)      tar xjf $1   ;;
#         *.tgz)       tar xzf $1   ;;
#         *.zip)       unzip $1     ;;
#         *.Z)         uncompress $1;;
#         *.7z)        7z x $1      ;;
#         *)           echo "'$1' cannot be extracted via ex()" ;;
#       esac
#     else
#       echo "'$1' is not a valid file"
#     fi
#   }

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
                printf " %-9s" "${seq0:-(default)}"
                printf " ${seq0}TEXT\e[m"
                printf "\e[${vals:+${vals+$vals;}}1mBOLD\e[m"
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

    # Set default system editor for the current user.
    export EDITOR=vim

    # required for update of multisystem
    export VISUAL=vim

    # required for grafical editor
    export GVISUAL=gvim

    # load Fuzzy File Finder tool and realated helpers
    [[ -f ~/.bash_fzf ]] && source ~/.bash_fzf

    [[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

    # load tmuxp tool for tmux
    [[ -d ~/.local/bin/ ]] && [[ ":$PATH:" != *":~/.local/bin:"* ]] && PATH="${PATH}:~/.local/bin:"

    if [[ -d $HOME/.config/base16-shell/ ]]; then
      # include base16 function
      BASE16_SHELL=$HOME/.config/base16-shell/
      [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
    fi

    # Fix for tilix
    if [[ -r /etc/profile.d/vte.sh ]] || [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
        source /etc/profile.d/vte.sh
    fi

fi
