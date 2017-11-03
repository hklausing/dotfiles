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
# name of distribution
g_dist=''
# List of assigned functionality
g_code=''
#set +x





#==========================================================================
# Get the current distribution and set the variable g_dist.
# Param1:   -
#==========================================================================
function distribution()
{
    local dist=$(lsb_release -i | sed 's/Distributor.ID\:\s*//')
    case ${dist,,} in
        manjarolinux)
            g_dist='manjaro'
#           g_list='B1 B2 B3 B4 S1 G1 G2 P1 T1 T2'
            g_list='TT'
            ;;
        raspbian)
            g_dist='debian'
            g_list=''
            ;;
    esac
}
#==========================================================================
# Check if the execution line code is listed in the supported lines of
# the current distribution.
# Param1:   Name of the line code for the execution
# Return:   0 if the code was found, otherwise 1
#==========================================================================
function enabled()
{
    # get line code
    line_code=$1
    [[ -z $1 ]] && return 1

    local rgex=\\b${line_code}\\b
    [[ $g_list =~ $rgex ]] && return 0

    return 1
}



#::#==========================================================================
#::# Get the current processed source path.
#::# Param1:   source directory, relative to dotfile directory
#::# Param2:   file name
#::#==========================================================================
#::function getSourceFile()
#::{
#::    echo "${g_trgdir}/$1/$2"
#::}
#::
#::
#::
#==========================================================================
# Get the current processed source path.
# Param1:   source directory, relative to dotfile directory
# Param2:   [optional]file name
#==========================================================================
function getSource()
{
    local trg="${g_trgdir}/$1/$2"

    # remove trailing slashes if existing
    echo $(echo ${trg} | sed 's|/$||g' | sed 's|\/\/|/|g')
}


#::#==========================================================================
#::# Get the current processed source path.
#::# Param1:   source directory, relative to dotfile directory
#::#==========================================================================
#::function getSourceDir()
#::{
#::    echo "${g_trgdir}/$1"
#::}


#::#==========================================================================
#::# Get the current processed target path.
#::# Param1:   target directory, relative to home directory or absolute path
#::# Param2:   file name
#::#==========================================================================
#::function getTargetFile()
#::{
#::    local trg="$1/$2"
#::
#::    if [[ $2 =~ ^/ ]]; then
#::        # target path is absolute
#::        trg="$2/$3"
#::    elif [[ "$2" == "." ]]; then
#::        # ignore dor directory
#::        trg="~/$3"
#::    fi
#::    # replace existing tilde '~'
#::    trg=$(eval echo "${trg}")
#::
#::    echo ${trg}
#::}
#::
#::
#==========================================================================
# Get the current processed target path.
# Param1:   target directory
# Param2:   [optional]file name
#==========================================================================
function getTarget()
{
    local trg=$(eval echo "$1/$2")

    # remove trailing slashes if existing
    echo $(echo ${trg} | sed 's|/$||g' | sed 's|\/\/|/|g')
}


#::#==========================================================================
#::# Get the current processed target path.
#::# Param1:   target directory, relative to home directory or absolute path
#::#==========================================================================
#::function getTargetDir()
#::{
#::    local trg="~/$1"
#::
#::    # replace existing tilde '~'
#::    trg=$(eval echo "${trg}")
#::
#::    echo ${trg}
#::}


#==========================================================================
# If the source file is not a link than copy the file to a storage
# location.
# Param1:   source directory, relative to dotfile directory
# Param2:   target directory, relative to home directory or absolute path
# Param3:   file name
#==========================================================================
function saveOriginal()
{
    local trg="$1"
    local trgdir="$2"

    # test if original file exists and it's not a symbolic link
    if [[ -f "${trg}" && ! -L "${trg}" ]]; then

        local storedir="${g_trgdir}/${g_store}"

        echo
        echo "file '${trg}' not a symbolic link"

        # copy file
    echo mkdir -p ${storedir}/${trgdir}/
    echo cp ${trg} ${storedir}/${trgdir}/
    echo rm ${trg}
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
    local src=$(getSource "$1" "$3")
    local trg=$(getTarget "$2" "$3")
    echo "1:$1, 2:$2, 3:$3"

    # test if source file exists
    if [[ ! -z "$3" && ! -f ${src} ]]; then

        echo "ERROR: source file '${src}' not found"
        exit 1

    # test if source file exists
    elif [[ -z "$3" && ! -d ${src} ]]; then

        echo "ERROR: source directory '${src}' not found"
        exit 1

    fi

    echo -n "$line_code: create link ${src} to ${trg}"

    # create target directory
    mkdir -p $(dirname ${trg})

    # save file/directory if not a link
    if [[ -f ${trg} ]]; then
        echo -n "  file: $trg"

        # store existing source file if not a link
        saveOriginal "${trg}" "$1"

    elif [[ -d ${trg} ]]; then
        echo -n "  dir: $trg"

        # save files if not a symbolic link
        if [[ ! -L ${trg} ]]; then
            # list of files
            for file in ${trg}/*; do

                saveOriginal "${file}" "$1"

            done

            rm -rf ${trg}

            src="${src}/"
        fi

    fi

    # make a link if link does not exists
    [[ ! -L ${trg} ]] && ln -sf ${src} ${trg}

    # test if original file exists
    if [[ ! -f "${trg}" && ! -d "${trg}" ]]; then
        echo
        echo "ERROR: file/dir '${src}' not linked."
        exit 1
    fi

    echo "   ... OK"

}


#::#==========================================================================
#::# This function does some actions:
#::# - Copies existing original directory to a storage location.
#::# - Creates a link to the given parameter
#::# Param1:   source directory, relative to .dotfile directory
#::# Param2:   target directory, relative to home directory or absolute path
#::#==========================================================================
#::function setLinkDir()
#::{
#::#   local regex=\\bsetLingDir\\b
#::#   [[ $g_list =~ ${regex} ]] || return
#::
#::    local src=$(getSourceDir "$1")
#::    local trg=$(getTargetDir "$2")
#::    #echo "s: $src"
#::    #echo "t: $trg"
#::
#::    # test if source file exists
#::    if [[ ! -d ${src} ]]; then
#::        echo "ERROR: directory '${src}' not found"
#::        exit 1
#::    fi
#::
#::    echo -n "$line_code: create ${src} to ${trg}"
#::
#::    # create target directory
#::    mkdir -p $(dirname ${trg})
#::
#::    # store existing target directory if not a link
#::
#::    if [[ ! -h ${trg} ]]; then
#::        # list of files
#::        for file in ${trg}/*; do
#::
#::            saveOriginal "${file}" "$1"
#::
#::        done
#::
#::        rm -rf ${trg}
#::    fi
#::
#::    # make a link
#::    ln -sf ${src} ${trg}
#::
#::    echo "   ... OK"
#::
#::}


# determine the current distribution and set the supported line codes
distribution
echo "Install dotfiles for '${g_dist}':"


###########################################################################
#
# system
#
enabled B1 && setLink system ~ .bashrc
enabled B2 && setLink system ~ .bash_aliases
enabled B3 && setLink system ~ .bash_fzf
enabled B4 && setLink system ~ .bash_profile
enabled S1 && setLink system ~ .inputrc



###########################################################################
#
# git
#
enabled G1 && setLink system ~ .git-prompt.sh
enabled G2 && setLink git ~ .gitconfig



###########################################################################
#
# tmux
#
enabled T1 && setLink tmux ~ .tmux.conf
#enabled T2 && setLinkDir tmuxp .tmuxp
enabled T2 && setLink tmuxp ~/.tmuxp



enabled TT && setLink testdir1/ ~/testdir
enabled TT && setLink testdir2 ~/ testfile2



###########################################################################
#
# mc - skin
#
#enabled P1 && setLinkDir mc/skins .local/share/mc/skins
enabled P1 && setLink mc/skins .local/share/mc/skins


exit 0

