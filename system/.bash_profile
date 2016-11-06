#
# ~/.bash_profile
#

# Set our umask value. Avoid access for others
umask 0027

[[ -f ~/.extend.bash_profile ]] && . ~/.extend.bash_profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

