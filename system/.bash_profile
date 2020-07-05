#
# ~/.bash_profile
#
# Load at login process
#

# Set our umask value. Avoid access for others
umask 0007

# Execute update & upgrade
case $(lsb_release -d) in
    *Manjaro*) export DISTRIBUTION='Manjaro' ;;
    *Debian*)  export DISTRIBUTION='Debian' ;;
esac

[[ -f ~/.extend.bash_profile ]] && . ~/.extend.bash_profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

