# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
alias a='cd shadowsocksr&&python mujson_mgr.py -a -k 99 -p'
alias d='cd shadowsocksr&&python mujson_mgr.py -d -p'
alias l='cd shadowsocksr&&python mujson_mgr.py -l -p'
alias c='cd shadowsocksr&&python mujson_mgr.py -c -p'
alias e='cd shadowsocksr&&python mujson_mgr.py -l'
alias q='bash ssr_check.sh a'
alias w='cat 1.log | grep'