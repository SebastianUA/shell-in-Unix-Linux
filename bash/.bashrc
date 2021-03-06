

#==============================ALIASES==============================#
# ls
alias ls="ls -G"  
#alias ll="ls -l"
alias la="ls -la"
alias lk='ls -lSr'
#jumps
alias jump2="ssh vitaly.n@gvojump2.com"
alias jump1="ssh vitaly.n@gvojump1.com"
#
alias grep='egrep --color'
#My VPS
#alias linux-notes="ssh USER@IP" 
#alias linux-notes-backup="scp -r USER@IP:/home/captain/backups/backup-* ~/My\ works/My_sites/backUPs/"
# GIT
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias ga='git add '
alias gau='git add --update'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'
#==============================Set colors==============================#
export CLICOLOR=1  
export LSCOLORS=Gxfxcxdxbxegedabagacad
#export LSCOLORS=GxFxCxDxBxegedabagaced
#==============================PS==============================#
PS1="
\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\H'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]
\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"
PS2=" > "
#[ ! "$UID" = "0" ] && archbey -c white
#[  "$UID" = "0" ] && archbey -c green
#PS1="\[\e[01;39m\]┌─[\[\e[00;32m\u\e[01;39m\]]──[\[\e[00;32m\]${HOSTNAME%%.*}\[\e[01;39m\]]:\e[00;33m\\w\e[01;32m\$\[\e[01;39m\]\n\[\e[01;39m\]└──\[\e[01;39m\]>>\[\e[0m\]"
#==============================GRC==============================#
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
export HISTCONTROL=ignoredups:ignorespace # no duplicate entries
export HISTSIZE=1000 # custom history size
export HISTFILESIZE=2000 # custom history file size
shopt -s histappend  # append to history, don't overwrite it
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"  # Save and reload the history after each command finishes           
#==============================FUNCTIONS==============================#
#==============================FUNCTIONS==============================#
# extract archives
 extract () {
           if [ -f $1 ] ; then
                   # display usage if no parameters given
                   echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
                   case $1 in
                           *.tar.bz2)   tar xvjf "$1"    ;;
                           *.tar.gz)    tar xvzf "$1"    ;;
                           *.tar.xz)    tar xvJf "$1"    ;;
                           *.lzma)      unlzma "$1"      ;;
                           *.bz2)       bunzip2 "$1"     ;;
                           *.rar)       rar x "$1"       ;;
                           *.gz)        gunzip "$1"      ;;
                           *.tar)       tar xvf "$1"     ;;
                           *.tbz2)      tar xvjf "$1"    ;;
                           *.tgz)       tar xvzf "$1"    ;;
                           *.zip)       unzip "$1"       ;;
                           *.xz)        unxz "$1"        ;;
                           *.Z)         uncompress "$1"  ;;
                           *.7z)        7z x "$1"        ;;
                           *)           echo "don't know how to extract '$1'..." ;;
                   esac
           else
                   echo "'$1' is not a valid file!"
           fi
}
# pack directories
   function pack() {
       target=${2%/}
           case $1 in
                       	gz)
                               tar czvf ${target}.tar.gz $target ;;
                       	bz)
			                         tar cjvf ${target}.tar.bz2 $target ;;
			                  xz)
				                        tar cJvf ${target}.tar.xz $target ;;
			                  7z)
				                        7zr a ${target}.7z $target ;;
			                  rar)
				                        rar a ${target}.rar $target ;;
			                  zip)
				                        zip -r ${target}.zip $target ;;
			                  *)
				                        echo "Usage: pack [gzip|bzip2|xz|7z|rar|zip] [target]" ;;
	esac
}
