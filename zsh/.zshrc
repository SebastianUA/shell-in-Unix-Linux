# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
 
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="afowler"
 
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
 
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"
 
# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"
 
# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"
 
# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"
 
# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"
 
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)
 
source $ZSH/oh-my-zsh.sh
 
# Customize to your needs...
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/git/bin:/opt/local/bin
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
 
# -------------------------------------------------------------------
#			 MY ALIASES
# -------------------------------------------------------------------
# Git aliases
# -------------------------------------------------------------------
alias ga='git add -A'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias gta='git tag -a -m'
alias gf='git reflog'
 
# leverage an alias from the ~/.gitconfig
alias gh='git hist'
alias glg1='git lg1'
alias glg2='git lg2'
alias glg='git lg' 
# -------------------------------------------------------------------
# Capistrano aliases
# -------------------------------------------------------------------
alias capd='cap deploy'
# -------------------------------------------------------------------
# Mercurial (hg)
# -------------------------------------------------------------------
 alias 'h=hg status'
 alias 'hc=hg commit'
 alias 'push=hg push'
 alias 'pull=hg pull'
 alias 'clone=hg clone'

# -------------------------------------------------------------------
# OTHER aliases
# -------------------------------------------------------------------
alias cl='clear'
# -------------------------------------------------------------------

 
 
# -------------------------------------------------------------------
# FUNCTIONS
# -------------------------------------------------------------------
 
# return my IP address
function myip() {
    ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
     ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
     ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
     ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
     ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}
 
# Change directory to the current Finder directory
cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}
extract () {
	if [[ -f $1 ]] then
		if [[ -x /usr/bin/pbzip2 || -x /usr/local/bin/pbzip2 ]] then
			BZIP=pbzip2
		else
			BZIP=bzip2
		fi
		case $1 in
			*.tar.bz2)  `$BZIP -v -d $1`    ;;
			*.tar.gz)   tar -xvzf $1        ;;
			*.rar)      unrar x $1          ;;
			*.deb)      ar -x $1            ;;
			*.bz2)      `$BZIP -d $1`       ;;
			*.lzh)      lha x $1            ;;
			*.gz)       gunzip -d $1        ;;
			*.tar)      tar -xvf $1         ;;
			*.tgz)      tar -xvzf $1        ;;
			*.tbz2)     tar -jxvf $1        ;;
			*.zip)      unzip $1            ;;
			*.Z)        uncompress $1       ;;
			*.xz)       xz -d $1            ;;
			*)          echo "'$1' Error. Please go away" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

rmtex() {
	find . -maxdepth 1 -regex ".*\(\~\|\.log\|\.nav\|\.snm\|\.toc\|\.cp\|\.fn\|\.tp\|\.vr\|\.pg\|\.bbl\|\#\|\.blg\|\.ilg\|\.dvi\|\.aux\)" -exec rm -vf {} \; ; find . -maxdepth 1 -type d -name "auto" -exec rm -vfr {} \;
}


psgrep() {
	if [ ! -z $1 ] ; then
		ps aux | grep $1 | grep -v grep
	else
		echo "!! Need name to grep for"
	fi
}

pskill() {
	if  [ ! -z $1 ] ; then
		kill -9 `ps aux | grep $1 | grep -v grep  | awk '{ print $2}'`
	else 
		echo "!! Need name to grep for"
	fi
}

mcd () {
	mkdir "$@" && cd "$@"
}

