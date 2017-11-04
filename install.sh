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
g_srcdir=~/.dotfiles
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
            g_list='B1 B2 B3 B4 S1 G1 G2 P1 T1 T2'
            ;;
        raspbian)
            g_dist='debian'
            g_list='S1 G2 P1 T1 T2'
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



#==========================================================================
# Get the current processed source path.
# Param1:   source directory, relative to dotfile directory!
# Return:   source path name without wildcard characters
#==========================================================================
function srcPathName()
{
    local src="${g_srcdir}/$1"

    # remove trailing and double slashes if existing
    echo $(echo ${src} | sed 's|/$||g' | sed 's|\/\/|/|g')
}


#==========================================================================
# Get the current processed target path.
# Param1:   target directory
# Return:   target path name without wildcard characters
#==========================================================================
function trgPathName()
{
    local trg=$(eval echo "$1")

    # remove trailing and double slashes if existing
    echo $(echo ${trg} | sed 's|/$||g' | sed 's|\/\/|/|g')
}



#==========================================================================
# If the target path exists and it is not a link than copy a storage
# location.
# Param1:   target path, can be a file or a directory
#==========================================================================
function saveOriginal()
{
    local trg="$1"

    # test if original file exists and it's not a symbolic link
    if [[ -e "${trg}" && ! -L "${trg}" ]]; then

        local storedir="${g_srcdir}/${g_store}"

        echo
        echo "path '${trg}' not a symbolic link"

        if [[ -f ${trg} ]]; then

            # copy file
            local trg_dir=$(dirname ${trg})
            mkdir -p ${storedir}/${trg_dir}/
            cp ${trg} ${storedir}/${trg_dir}/
            rm ${trg}
            echo "  ${trg} moved to '${storedir}/${trg_dir}/'"

        elif [[ -d ${trg} ]]; then

            # copy path
            mkdir -p ${storedir}/${trg}/
            cp -a ${trg} ${storedir}/${trg}/
            rm -rf ${trg}

        fi
        echo -n "  create link "
    fi
}


#==========================================================================
# This function does some actions:
# - Copies existing original files to a storage location.
# - Creates a link to the given parameter
# Param1:   exceution code to check if link creation is enabled for this
#           distribution.
# Param2:   source path, relative to .dotfile directory; path can be
#           a file or a directory
# Param3:   target path, relative to home directory or absolute path;
#           path can be a file or a directory
#==========================================================================
function makeLink()
{
    local src=$(srcPathName "$2")
    local trg=$(trgPathName "$3")
    local trg_dir=$(dirname ${trg})

    enabled $1 || return

    #echo "code:$1, src:$src, trg:$trg"

    # source path must exists, test it here
    if [[ ! -e ${src} ]]; then

        echo "ERROR: source path '${src}' not found! *****"
        exit 1

    fi

    # Information for user
    if [[ -f ${src} ]]; then
        echo -n "file) $line_code: create link ${src} to ${trg}"
    elif [[ -d ${src} ]]; then
        echo -n "dir)  $line_code: create link ${src} to ${trg}"
    fi

    # create target directory
    mkdir -p ${trg_dir}

    # save file/directory if not a link
    if [[ -f ${trg} ]]; then

        # store existing source file if not a link
        saveOriginal "${trg}"

    elif [[ -d ${trg} ]]; then

        # save whole directory structure
        saveOriginal "${trg}"

        src="${src}/"

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


# determine the current distribution and set the supported line codes
distribution
echo "Install dotfiles for '${g_dist}':"


###########################################################################
#
# system
#
makeLink 'B1' system/.bashrc          ~/.bashrc
makeLink 'B2' system/.bash_aliases    ~/.bash_aliases
makeLink 'B3' system/.bash_fzf        ~/.bash_fzf
makeLink 'B4' system/.bash_profile    ~/.bash_profile
makeLink 'S1' system/.inputrc         ~/.inputrc



###########################################################################
#
# git
#
makeLink 'G1' system/.git-prompt.sh   ~/.git-prompt.sh
makeLink 'G2' git/.gitconfig          ~/.gitconfig



###########################################################################
#
# tmux
#
makeLink 'T1' tmux/.tmux.conf         ~/.tmux.conf
makeLink 'T2' tmuxp/                  ~/.tmuxp



###########################################################################
#
# mc - skin
#
makeLink 'P1' mc/skins/               ~/.local/share/mc/skins


exit 0

