

#==============================ALIASES==============================#
# ls
alias ls="ls -G"  
#alias ll="ls -l"
alias la="ls -la"
alias lk='ls -lSr'
#
alias jump2="ssh vitaly.n@gvojump2.com"
alias jump1="ssh vitaly.n@gvojump1.com"
#
alias grep='egrep --color'
#==============================My VPS==============================#
#alias linux-notes="ssh USER@IP" 
#alias linux-notes-backup="scp -r USER@IP:/home/captain/backups/backup-* ~/My\ works/My_sites/backUPs/"
#==============================Set colors==============================#
export CLICOLOR=1  
export LSCOLORS=Gxfxcxdxbxegedabagacad
#export LSCOLORS=GxFxCxDxBxegedabagaced
#==============================PS==============================#
PS1="
\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\H'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]
\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"
PS2=" > "
#=====================================================================#
if [ -f /usr/local/bin/grc ]; then
  alias cvs="grc --colour=auto cvs"
  alias diff="grc --colour=auto diff"
  alias esperanto="grc --colour=auto esperanto"
  alias gcc="grc --colour=auto gcc"
  alias irclog="grc --colour=auto irclog"
  alias ldap="grc --colour=auto ldap"
  alias log="grc --colour=auto log"
  alias netstat="grc --colour=auto netstat"
  alias ping="grc --colour=auto ping"
  alias proftpd="grc --colour=auto proftpd"
  alias traceroute="grc --colour=auto traceroute"
  alias wdiff="grc --colour=auto wdiff"
  alias dig="grc --colour=auto dig"
  alias ll="grc --colour=auto ls -l"
fi
#==============================History Tweaks==============================#
export HISTIGNORE=pwgen*
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
#=====================================================================#
