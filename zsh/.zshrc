# Path to your oh-my-zsh installation.
export ZSH=/Users/captain/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"

ZSH_THEME="agnoster"
#ZSH_THEME="cobalt2"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/git/bin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:/opt/local/bin:/opt/local/sbin:/opt/X11/bin:/opt/local/bin:/opt/local/sbin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias grep='egrep --color'

# My VPS
alias linux-notes="ssh captain@31.187.70.238"
alias linux-notes-backup="scp -r captain@31.187.70.238:/home/captain/backups/backup-* ~/My\ works/My_sites/backUPs/"
# set colors  
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
#export LSCOLORS=GxFxCxDxBxegedabagaced
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
	alias cat="grc --colour=auto cat"
fi
#==============================HISTORY==============================#
## Command history configuration
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000

# Show history
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
								        
#==============================FUNCTIONS==============================#
# extract archives
extract () {
	  if [ -f $1 ] ; then
		  # display usage if no parameters given
		  # echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
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
#      
# Disable globbing on the remote path.
alias scp='noglob scp_wrap'
function scp_wrap {
  local -a args
  local i
  for i in "$@"; do case $i in
    (*:*) args+=($i) ;;
    (*) args+=(${~i}) ;;
  esac; done
  command scp "${(@)args}"
}

