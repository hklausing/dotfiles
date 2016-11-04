#!/usr/bin/env bash
###########################################################################
# .make.sh
# This script creates symlinks from the home directory to any
# desired dotfiles in ~/.dotfiles. Existing files will be stored
# in the directory ~/.dotfiles/.original.
# The directory ~/.dotfiles is version controlled.
###########################################################################

echo "Install dotfiles:"


# Name of the director of dotfile locations.
trgdir=~/.dotfiles
storedir="${trgdir}/.original"


#==========================================================================
# This function does some actions:
# - Copies existing original files to a storage location.
# - Creates a link to the given parameter
# Param1:   source directory, relative to ditfile directory
# Param2:   target directory, relative to home directory or absolute path
# Param3:   file name
#==========================================================================
function setLink()
{
    local src="${trgdir}/$1/$3"
    local trg="~/$2/$3"

    if [[ $2 =~ ^/ ]]; then
        # target path is absolute
        trg="$2/$3"
    elif [[ "$2" == "." ]]; then
        # ignore dor directory
        trg="~/$3"
    fi
    # replace existing tilde '~'
    trg=$(eval echo "${trg}")

    echo -n "create ${src} to ${trg}"

    # test if source file exists
    if [[ ! -f ${src} ]]; then
        echo
        echo "ERROR: file '${src}' not found"
        exit 1
    fi

    # create target directory
    mkdir -p $(dirname ${trg})

    # test if original file exists
    if [[ -f "${trg}" && ! -L "${trg}" ]]; then
        echo
        echo "file '${trg}' not a symbolic link"

        # copy file
        mkdir -p ${storedir}/$1/
        cp ${trg} ${storedir}/$1/
        rm ${trg}
        echo "  ${trg} moved to '${storedir}/$1/'"
        echo -n "  create link "
    fi

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



###########################################################################
#
# system
#
setLink system . .bashrc
setLink system . .bash_aliases
setLink system . .inputrc



###########################################################################
#
# git
#
setLink git . .gitconfig


