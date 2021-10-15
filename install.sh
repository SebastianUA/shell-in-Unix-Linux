#!/usr/bin/env bash -x

# CREATED by Vitalii Natarov [vitaliy.natarov@yahoo.com]
# Unix/Linux blog: https://linux-notes.org

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Global vars
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set some colors for status OK, FAIL and titles
SETCOLOR_SUCCESS="echo -en \\033[1;32m"			# Green
SETCOLOR_FAILURE="echo -en \\033[1;31m"			# Red
SETCOLOR_NORMAL="echo -en \\033[0;39m"			# White

SETCOLOR_TITLE="echo -en \\033[1;36m" 			# Fuscia
SETCOLOR_TITLE_GREEN="echo -en \\033[0;32m"	# Green
SETCOLOR_NUMBERS="echo -en \\033[0;34m" 		# BLUE

PROJECT_DIR="."
CP_DIR=$(which cp)
MV_DIR=$(which mv)
RM_DIR=$(which rm)
GIT_DIR=$(which git)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# For logs
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LOG_FILE="./configures.log"
if [ ! -f "$LOG_FILE" ]; then
	touch $LOG_FILE
else
	${RM_DIR} -rf touch $LOG_FILE
	touch $LOG_FILE	
fi

${SETCOLOR_TITLE}
echo "$LOG_FILE file has been created in the '${PROJECT_DIR}' folder."
${SETCOLOR_NORMAL}

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


function install_pkgs_redhats () {
	# Update OS
	yum update -y && yum upgrade -y
	
	# Install some utilites
	if ! type -path "wget" > /dev/null 2>&1; then sudo yum install wget -y; fi
	if ! type -path "git" > /dev/null 2>&1; then sudo yum install git -y; fi
	if ! type -path "pv" > /dev/null 2>&1; then sudo yum install pv -y; fi
}


function install_pkgs_debs () {
	# Update OS
	apt-get update -y && apt-get upgrade -y

	# Install some utilites
	if ! type -path "wget" > /dev/null 2>&1; then sudo apt-get install wget -y; fi
	if ! type -path "git" > /dev/null 2>&1; then sudo apt-get install git -y; fi
	if ! type -path "pv" > /dev/null 2>&1; then sudo apt-get install pv -y; fi
}


function install_pkgs_macos () {
	which -s brew
		if [[ $? != 0 ]] ; then
			# Install Homebrew
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

			FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
		else
			# Update homebrew
			brew update && brew upgrade
		fi

		# Install some utilites
		if ! type -path "wget" > /dev/null 2>&1; then brew install wget; fi
		if ! type -path "git" > /dev/null 2>&1; then brew install git; fi
		if ! type -path "pv" > /dev/null 2>&1; then brew install pv; fi

		if [ -f ./brew/brew_list_pkgs.txt ]; then
			brew install $(cat ${PROJECT_DIR}/brew/brew_list_pkgs.txt | xargs -I{} -n1 echo {})
		fi
		if [ -f ./brew/brew_list_cask_pkgs.txt ]; then
			# xargs brew install < ${PROJECT_DIR}/brew/brew_list_cask_pkgs.txt
			brew install $(cat ${PROJECT_DIR}/brew/brew_list_cask_pkgs.txt | xargs -I{} -n1 echo {})
		fi
}


function os_check () {
	if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ] ; then
    	Redhat_lsb_core="rpm -qa | grep redhat-lsb-core"
		if [ ! -n "`$Redhat_lsb_core`" ]; then 
			yum install redhat-lsb-core -y 
		fi
    
		OS=$(lsb_release -ds | cut -d '"' -f2 | awk '{print $1}')
		OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/redhat-release`
		OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/redhat-release`
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
		
		$SETCOLOR_GREEN
		echo "RedHat's OS with $OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION and $Bit_OS bit arch"
		$SETCOLOR_NORMAL

		install_pkgs_redhats		
	elif [ -f /etc/fedora_version ]; then
		OS=$(lsb_release -ds | cut -d '"' -f2 | awk '{print $1}')
		OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/fedora_version`
		OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/fedora_version`
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/') 
		
		$SETCOLOR_GREEN
		echo "Fedora with $OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION($CODENAME) and $Bit_OS bit arch"
		$SETCOLOR_NORMAL

		install_pkgs_redhats
	elif [ -f /etc/debian_version ]; then
		OS=$(lsb_release -ds | cut -d '"' -f2 | awk '{print $1}')
		OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/debian_version`
		OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/debian_version`
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
		
		CODENAME=`cat /etc/*-release | grep "VERSION="`
		CODENAME=${CODENAME##*\(}
		CODENAME=${CODENAME%%\)*}
		
		$SETCOLOR_GREEN
		echo "Debian's OS with $OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION($CODENAME) and $Bit_OS bit arch"
		$SETCOLOR_NORMAL
		
		install_pkgs_debs
	elif [ -f /usr/sbin/system_profiler ]; then
		OS=$(uname)
		Mac_Ver=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
		
		${SETCOLOR_TITLE}
		echo "MacOS with $OS-$Mac_Ver and $Bit_OS bit arch"
		${SETCOLOR_NORMAL}
		
		install_pkgs_macos
	else
		OS=$(uname -s)
		VER=$(uname -r)
		echo 'OS=' $OS 'VER=' $VER
	fi

}


function configure_shell () {
	if [ ! -d "${PROJECT_DIR}" ]; then
		sudo mkdir ${PROJECT_DIR}
	fi

	$SETCOLOR_TITLE_GREEN
	read -p 'Would you like to install shell (bash/zsh): ' SHELL
	$SETCOLOR_NORMAL

	case ${SHELL} in
		b|B|bash|BASH) {
			# Backuping
			if [ -f "~/.bash_profile" ]; then
				sudo ${MV_DIR} ~/.bash_profile{,_BK}
			fi

			if [ -f "~/.bash_login" ]; then
				sudo ${MV_DIR} ~/.bash_login{,_BK}
			fi

			if [ -f "~/.bashrc" ]; then
				sudo ${MV_DIR} ~/.bashrc{,_BK}
			fi

			# Copying
			if [ -f "${PROJECT_DIR}/shells/bash/bash_profile" ]; then
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/bash/bash_profile ~/.bash_profile
			fi

			if [ -f "${PROJECT_DIR}/shells/bash/bash_login" ]; then
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/bash/bash_login ~/.bash_login
			fi

			if [ -f "${PROJECT_DIR}/shells/bash/bashrc" ]; then
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/bash/bashrc ~/.bashrc
			fi
			source ~/.bashrc
		};;
		z|Z|zsh|ZSH|zSH) {
			# Backuping
			if [ -d "~/.oh-my-zsh" ]; then
				sudo ${RM_DIR} -rf ~/.oh-my-zsh_BK*
				sudo ${MV_DIR} ~/.oh-my-zsh{,_BK}
			fi

			if [ -f "~/.zsh_profile" ]; then
				sudo ${MV_DIR} ~/.zsh_profile{,_BK}
			fi

			if [ -f "~/.zshrc" ]; then
				sudo ${MV_DIR} ~/.zshrc{,_BK}
			fi

			# Copying
			if [ -d "${PROJECT_DIR}/shells/zsh/oh-my-zsh" ]; then
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/zsh/oh-my-zsh/custom/plugins/* $ZSH_CUSTOM/plugins/
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/zsh/oh-my-zsh/custom/themes/* $ZSH_CUSTOM/themes/

				${CP_DIR} -rfn ${PROJECT_DIR}/shells/zsh/oh-my-zsh/plugins/* ~/.oh-my-zsh/plugins/
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/zsh/oh-my-zsh/themes/* ~/.oh-my-zsh/themes/

				${GIT_DIR} clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
				${GIT_DIR} clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
			fi

			if [ -f "${PROJECT_DIR}/shells/zsh/zsh_profile" ]; then
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/zsh/zsh_profile ~/.zsh_profile
			fi

			if [ -f "${PROJECT_DIR}/shells/zsh/zshrc" ]; then
				${CP_DIR} -rfn ${PROJECT_DIR}/shells/zsh/zshrc ~/.zshrc
			fi
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
	
	# Backuping
	if [ -d "~/.vim" ]; then
		sudo ${RM_DIR} -rf ~/.vim_BK*
		sudo ${MV_DIR} ~/.vim{,_BK}
	fi

	if [ -f "~/.vimrc" ]; then
		sudo ${MV_DIR} ~/.vimrc{,_BK}
	fi
	
	${CP_DIR} -rfn ${PROJECT_DIR}/vim/vim ~/.vim
	${CP_DIR} -rfn ${PROJECT_DIR}/vim/vimrc ~/.vimrc
	
	vim +PluginInstall +qall
	source ~/.vimrc
}

os_check
configure_shell; operation_status
configure_vim; operation_status

$SETCOLOR_TITLE_GREEN
echo "==============================================================================================";
echo "===========================================FINISHED===========================================";
echo "==============================================================================================";
$SETCOLOR_NORMAL
