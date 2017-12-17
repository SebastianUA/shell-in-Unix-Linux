#!/usr/bin/env bash -x

# CREATED by Vitaliy Natarov [vitaliy.natarov@yahoo.com]
#
# Unix/Linux blog: http://linux-notes.org


# Set some colors for status OK, FAIL and titles
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

SETCOLOR_TITLE="echo -en \\033[1;36m" #Fuscia
SETCOLOR_TITLE_GREEN="echo -en \\033[0;32m" #green
SETCOLOR_NUMBERS="echo -en \\033[0;34m" #BLUE

TMP_DIR="/usr/local/src"
CP_DIR=$(which cp)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# For LOGS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LOG_FILE="./configures.log"
if [ ! -f "$LOG_FILE" ]; then
	touch $LOG_FILE
else
	rm -rf touch $LOG_FILE
	touch $LOG_FILE	
fi

echo "$LOG_FILE file has been created in the current folder.";

exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function operation_status {
	if [ $? -eq 0 ]; then
		$SETCOLOR_SUCCESS;
		echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
		$SETCOLOR_NORMAL;
		echo;
	else
		$SETCOLOR_FAILURE;
		echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
		$SETCOLOR_NORMAL;
		echo;
	fi
}

function os_info () {
	if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ] ; then
    	Redhat_lsb_core="rpm -qa | grep redhat-lsb-core"
		if [ ! -n "`$Redhat_lsb_core`" ]; then 
			yum install redhat-lsb-core -y 
		fi
    
		OS=$(lsb_release -ds|cut -d '"' -f2|awk '{print $1}')
		OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/redhat-release`
		OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/redhat-release`
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
		
		$SETCOLOR_GREEN
		echo "RedHat's OS with $OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION and $Bit_OS bit arch"
		$SETCOLOR_NORMAL

		# update OS
		yum update -y && yum upgrade -y
	
		# install some utilites
		if ! type -path "wget" > /dev/null 2>&1; then sudo yum install wget -y; fi
		if ! type -path "git" > /dev/null 2>&1; then sudo yum install git -y; fi
		if ! type -path "pv" > /dev/null 2>&1; then sudo yum install pv -y; fi
	elif [ -f /etc/fedora_version ]; then
		OS=$(lsb_release -ds|cut -d '"' -f2|awk '{print $1}')
		OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/fedora_version`
		OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/fedora_version`
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/') 
		
		$SETCOLOR_GREEN
		echo "Fedora with $OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION($CODENAME) and $Bit_OS bit arch"
		$SETCOLOR_NORMAL
	elif [ -f /etc/debian_version ]; then
		OS=$(lsb_release -ds|cut -d '"' -f2|awk '{print $1}')
		OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/debian_version`
		OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/debian_version`
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
		
		CODENAME=`cat /etc/*-release | grep "VERSION="`
		CODENAME=${CODENAME##*\(}
		CODENAME=${CODENAME%%\)*}
		
		$SETCOLOR_GREEN
		echo "Debian's OS with $OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION($CODENAME) and $Bit_OS bit arch"
		$SETCOLOR_NORMAL
		# update OS
		apt-get update -y && apt-get upgrade -y
	
		# install some utilites
		if ! type -path "wget" > /dev/null 2>&1; then sudo apt-get install wget -y; fi
		if ! type -path "git" > /dev/null 2>&1; then sudo apt-get install git -y; fi
		if ! type -path "pv" > /dev/null 2>&1; then sudo apt-get install pv -y; fi
	elif [ -f /usr/sbin/system_profiler ]; then
		OS=$(uname)
		Mac_Ver=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
		
		${SETCOLOR_TITLE}
		echo "MacOS with $OS-$Mac_Ver and $Bit_OS bit arch"
		${SETCOLOR_NORMAL}
		
		which -s brew
		if [[ $? != 0 ]] ; then
			# Install Homebrew
			ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

			FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
		else
			# update homebrew
			brew update && brew upgrade
		fi

		# install some utilites
		if ! type -path "wget" > /dev/null 2>&1; then brew install wget; fi
		if ! type -path "git" > /dev/null 2>&1; then brew install git; fi
		if ! type -path "pv" > /dev/null 2>&1; then brew install pv; fi

		if [ -f ./brew/brew_list_pkgs.txt ]; then
			xargs brew install < ./brew/brew_list_pkgs.txt
		fi
		if [ -f ./brew/brew_list_cask_pkgs.txt ]; then
			xargs brew install < ./brew/brew_list_cask_pkgs.txt
		fi

	else
		OS=$(uname -s)
		VER=$(uname -r)
		echo 'OS=' $OS 'VER=' $VER
	fi

}


function configure_shell () {
	if [ ! -d "${TMP_DIR}" ]; then
		sudo mkdir ${TMP_DIR}
	fi

	cd ${TMP_DIR} && sudo rm -rf shell-in-Unix-Linux && \
	sudo git clone https://github.com/SebastianUA/shell-in-Unix-Linux.git
	
	$SETCOLOR_TITLE_GREEN
	read -p 'Would you like to install shell (bash/zsh): ' SHELL
	$SETCOLOR_NORMAL

	case ${SHELL} in
		b|B|bash|BASH) {
			${CP_DIR} -rfn ${TMP_DIR}/shell-in-Unix-Linux/shells/bash/bash_profile ~/.bash_profile
			${CP_DIR} -rfn ${TMP_DIR}/shell-in-Unix-Linux/shells/bash/bash_login ~/.bash_login
			${CP_DIR} -rfn ${TMP_DIR}/shell-in-Unix-Linux/shells/bash/bashrc ~/.bashrc
			source ~/.bashrc
		};;
		z|Z|zsh|ZSH|zSH) {
			sudo rm -rf ~/.oh-my-zsh
			${CP_DIR} -rfn ${TMP_DIR}/shell-in-Unix-Linux/shells/zsh/oh-my-zsh ~/.oh-my-zsh
			${CP_DIR} -rfn ${TMP_DIR}/shell-in-Unix-Linux/shells/zsh/zshrc ~/.zshrc
		};;
		e|E|exit) exit 1;;
		q|Q|quit) exit 1;;
		h|help|HELP) echo "Use bash or zsh to install selected shell on your server";; 
		*) echo "error: not correct variable, try to start this script again";;
	esac		 
}

function configure_vim () {
	$SETCOLOR_TITLE
	echo "Configuring Vim"
	$SETCOLOR_NORMAL
	
	sudo rm -rf ~/.vim
	${CP_DIR} -rfn ${TMP_DIR}/shell-in-Unix-Linux/vim/vim ~/.vim
	${CP_DIR} -rfn ${TMP_DIR}/shell-in-Unix-Linux/vim/vimrc ~/.vimrc
	
	vim +PluginInstall +qall
	source ~/.vimrc
}

os_info
configure_shell
configure_vim

$SETCOLOR_TITLE_GREEN
echo "========================================================================================================";
echo "================================================FINISHED================================================";
echo "========================================================================================================";
$SETCOLOR_NORMAL