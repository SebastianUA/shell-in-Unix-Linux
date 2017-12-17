#!/bin/bash -x

# CREATED:
# vitaliy.natarov@yahoo.com
#
# Unix/Linux blog:
# http://linux-notes.org
# Vitaliy Natarov
#
# Set some colors for status OK, FAIL and titles
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

SETCOLOR_TITLE="echo -en \\033[1;36m" #Fuscia
SETCOLOR_TITLE_GREEN="echo -en \\033[0;32m" #green
SETCOLOR_NUMBERS="echo -en \\033[0;34m" #BLUE

function Operation_status {
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

#
# For LOGS
#
LOG_FILE="./install_shell.log"
if [ ! -f "$LOG_FILE" ]; then
	echo "$LOG_FILE file NOT FOUND in the current folder. Creating....";
	touch $LOG_FILE

else
	rm -rf touch $LOG_FILE
	touch $LOG_FILE	
fi							
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

function server_info () {

	if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ] ; then
    echo "RedHat or CentOS";
    Redhat_lsb_core="rpm -qa | grep redhat-lsb-core"
	if [ ! -n "`$Redhat_lsb_core`" ]; then 
		yum install redhat-lsb-core -y 
	fi
    #
    OS=$(lsb_release -ds|cut -d '"' -f2|awk '{print $1}')
    OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/redhat-release`
	OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/redhat-release`
	Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
	#
	$SETCOLOR_GREEN
	echo "$OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION with $Bit_OS bit arch"
	$SETCOLOR_NORMAL

	#update OS
	yum update -y && yum upgrade -y
 
	# install some utilites
	if ! type -path "wget" > /dev/null 2>&1; then sudo yum install wget -y; fi
	if ! type -path "git" > /dev/null 2>&1; then sudo yum install git -y; fi
	if ! type -path "pv" > /dev/null 2>&1; then sudo yum install pv -y; fi
	#
elif [ -f /etc/fedora_version ]; then
	 echo "Fedora";
	 #
	 OS=$(lsb_release -ds|cut -d '"' -f2|awk '{print $1}')
     OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/fedora_version`
	 OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/fedora_version`
	 Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/') 
	 #
	 $SETCOLOR_GREEN
	 echo "$OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION($CODENAME) with $Bit_OS bit arch"
	 $SETCOLOR_NORMAL
	 # 
elif [ -f /etc/debian_version ]; then
    echo "Debian/Ubuntu/Kali Linux";
    #
    OS=$(lsb_release -ds|cut -d '"' -f2|awk '{print $1}')
    OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/debian_version`
	OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/debian_version`
	Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
    #
	CODENAME=`cat /etc/*-release | grep "VERSION="`
	CODENAME=${CODENAME##*\(}
	CODENAME=${CODENAME%%\)*}
	#
	$SETCOLOR_GREEN
	echo "$OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION($CODENAME) with $Bit_OS bit arch"
	$SETCOLOR_NORMAL
	#update OS
	apt-get update -y && apt-get upgrade -y
 
	# install some utilites
	if ! type -path "wget" > /dev/null 2>&1; then sudo apt-get install wget -y; fi
	if ! type -path "git" > /dev/null 2>&1; then sudo apt-get install git -y; fi
	if ! type -path "pv" > /dev/null 2>&1; then sudo apt-get install pv -y; fi
	#
elif [ -f /usr/sbin/system_profiler ]; then
	echo "MacOS!";
	#
	OS=$(uname)
	Mac_Ver=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
	Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
	#
	$SETCOLOR_GREEN
	echo "$OS-$Mac_Ver with $Bit_OS bit arch"
	$SETCOLOR_NORMAL
	#
	which -s brew
	if [[ $? != 0 ]] ; then
    	# Install Homebrew
    	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		# update homebrew
    	brew update && brew upgrade
    	# install some utilites
		if ! type -path "wget" > /dev/null 2>&1; then brew install wget -y; fi
		if ! type -path "git" > /dev/null 2>&1; then brew install git -y; fi
		if ! type -path "pv" > /dev/null 2>&1; then brew install pv -y; fi
		#
	fi

else
    OS=$(uname -s)
    VER=$(uname -r)
    echo 'OS=' $OS 'VER=' $VER
fi

}


function install_shell () {
	 cd /usr/local/src && sudo git clone https://github.com/SebastianUA/shell-in-Unix-Linux.git
	 $SETCOLOR_TITLE_GREEN
	 read -p 'Would you like to install shell (bash/zsh): ' SHELL
	 $SETCOLOR_NORMAL
	 case ${SHELL} in
	 	 b|B|bash|BASH) {
	 		 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/bash/.bash_* ~
	 		 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/bash/.bashrc ~
	 		 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/bash/.vimrc ~
     
	 		 `which tar` -xvf /usr/local/src/shell-in-Unix-Linux/bash/.vim.tar
	 		 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/bash/.vim ~
	 		 # install plugins for vim
	 		 vim +PluginInstall +qall
			 source ~/.vimrc
			 source ~/.bashrc
		 };;
	         z|Z|zsh|ZSH|zSH) {
			 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/zsh/.zsh_* ~
			 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/zsh/.zshrc ~
			 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/zsh/.vimrc ~
			 `which tar` -xvf /usr/local/src/shell-in-Unix-Linux/zsh/.vim.tar
			 `which cp` -rf /usr/local/src/shell-in-Unix-Linux/zsh/.vim ~
			 vim +PluginInstall +qall
	         };;
	 	 e|E|exit) exit 1     ;;
	 	 q|Q|quit) exit 1     ;;
		 h|help|HELP) echo "Use bash or zsh to install selected shell on your server";; 
	 	 *) echo "error: not correct variable, try to start this script again";;
     esac		 
}

server_info
install_shell

$SETCOLOR_TITLE_GREEN
echo "========================================================================================================";
echo "================================================FINISHED================================================";
echo "========================================================================================================";
echo -e "\n"
$SETCOLOR_NORMAL
