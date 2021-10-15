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


function uninstall_pkgs_redhats () {
	echo "The uninstall pkgs redhats TBD"
}


function uninstall_pkgs_debs () {
	echo "The uninstall pkgs debs TBD"
}


function uninstall_pkgs_macos () {
	which -s brew
    if [[ $? != 0 ]] ; then
        if [ -f ./brew/brew_list_pkgs.txt ]; then
			brew uninstall $(cat ${PROJECT_DIR}/brew/brew_list_pkgs.txt | xargs -I{} -n1 echo {})
		fi
		if [ -f ./brew/brew_list_cask_pkgs.txt ]; then
			brew uninstall $(cat ${PROJECT_DIR}/brew/brew_list_cask_pkgs.txt | xargs -I{} -n1 echo {})
		fi

        brew cleanup
        brew autoremove

        # Uninstall Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
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

		uninstall_pkgs_redhats		
	elif [ -f /etc/fedora_version ]; then
		OS=$(lsb_release -ds | cut -d '"' -f2 | awk '{print $1}')
		OS_MAJOR_VERSION=`sed -rn 's/.*([0-9])\.[0-9].*/\1/p' /etc/fedora_version`
		OS_MINOR_VERSION=`sed -rn 's/.*[0-9].([0-9]).*/\1/p' /etc/fedora_version`
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/') 
		
		$SETCOLOR_GREEN
		echo "Fedora with $OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION($CODENAME) and $Bit_OS bit arch"
		$SETCOLOR_NORMAL

		uninstall_pkgs_redhats
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
		
		uninstall_pkgs_debs
	elif [ -f /usr/sbin/system_profiler ]; then
		OS=$(uname)
		Mac_Ver=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
		Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
		
		${SETCOLOR_TITLE}
		echo "MacOS with $OS-$Mac_Ver and $Bit_OS bit arch"
		${SETCOLOR_NORMAL}
		
		uninstall_pkgs_macos
	else
		OS=$(uname -s)
		VER=$(uname -r)
		echo 'OS=' $OS 'VER=' $VER
	fi

}

os_check; operation_status

$SETCOLOR_TITLE_GREEN
echo "==============================================================================================";
echo "===========================================FINISHED===========================================";
echo "==============================================================================================";
$SETCOLOR_NORMAL
