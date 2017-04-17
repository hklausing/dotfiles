#!/usr/bin/env bash
###########################################################################
# File      : install.sh
# Author    : Heiko Klausing
# Creation  : 2016-11-05
#
# This script creates symlinks from the home directory to any
# desired dotfiles in ~/.dotfiles. Existing files will be stored
# in the directory ~/.dotfiles/.original.
# The directory ~/.dotfiles is version controlled.
#
###########################################################################


# Name of the directory of dotfile locations.
g_trgdir=~/.dotfiles
# Name of storage location relative to dotfile directory
g_store=".original"





#==========================================================================
# Get the current processed source path.
# Param1:   source directory, relative to ditfile directory
# Param2:   file name
#==========================================================================
function getSourceFile()
{
    echo "${g_trgdir}/$1/$2"
}


#==========================================================================
# Get the current processed target path.
# Param1:   target directory, relative to home directory or absolute path
# Param2:   file name
#==========================================================================
function getTargetFile()
{
    local trg="~/$1/$2"

    if [[ $2 =~ ^/ ]]; then
        # target path is absolute
        trg="$2/$3"
    elif [[ "$2" == "." ]]; then
        # ignore dor directory
        trg="~/$3"
    fi
    # replace existing tilde '~'
    trg=$(eval echo "${trg}")

    echo ${trg}
}


#==========================================================================
# If the source file is not a link than copy the file to a storage
# location.
# Param1:   source directory, relative to ditfile directory
# Param2:   target directory, relative to home directory or absolute path
# Param3:   file name
#==========================================================================
function saveOriginal()
{
    local trg="$1"
    local trgdir="$2"

    # test if original file exists
    if [[ -f "${trg}" && ! -L "${trg}" ]]; then

        local storedir="${g_trgdir}/${g_store}"

        echo
        echo "file '${trg}' not a symbolic link"

        # copy file
        mkdir -p ${storedir}/${trgdir}/
        cp ${trg} ${storedir}/${trgdir}/
        rm ${trg}
        echo "  ${trg} moved to '${storedir}/${trgdir}/'"
        echo -n "  create link "
    fi
}


#==========================================================================
# This function does some actions:
# - Copies existing original files to a storage location.
# - Creates a link to the given parameter
# Param1:   source directory, relative to dotfile directory
# Param2:   target directory, relative to home directory or absolute path
# Param3:   file name
#==========================================================================
function setLink()
{
    local src=$(getSourceFile "$1" "$3")
    local trg=$(getTargetFile "$2" "$3")

    # test if source file exists
    if [[ ! -f ${src} ]]; then
        echo "ERROR: file '${src}' not found"
        exit 1
    fi

    echo -n "create ${src} to ${trg}"

    # create target directory
    mkdir -p $(dirname ${trg})

    # store existing source file if not a link
    saveOriginal "${trg}" "$1"

    # make a link
    ln -sf ${src} ${trg}

    # test if original file exists
    if [[ ! -f "${trg}" ]]; then
        echo
        echo "ERROR: file '${src}' not linked."
        exit 1
    fi

    echo "   ... OK"

}



echo "Install dotfiles:"


###########################################################################
#
# system
#
setLink system . .bashrc
setLink system . .bash_aliases
setLink system . .bash_fzf
setLink system . .inputrc
setLink system . .bash_profile
setLink system . .git-prompt.sh



###########################################################################
#
# git
#
setLink git . .gitconfig



# reload the updated enviroment
source ~/.bashrc

