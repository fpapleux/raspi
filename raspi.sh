#!/bin/bash

clear
echo -e "#####################################################################################"
echo -e "## RASPBERRY PI SETUP SYSTEM"
echo -e "#####################################################################################"
echo -e "\n\n\n"

#####################################################################################
## Protect the Pi user from being exploited
#####################################################################################

echo "It is highly recommended to remove the Pi user from the system for security."
echo -n "Delete Pi user from the system ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo -e "\n\nDeleting Pi user... "
	sudo deluser --remove-home pi	
	echo -e "\n\nPi user deleted\n\n"
fi

#####################################################################################
## Change the root password
#####################################################################################

echo -n "change the root password for added security ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	set cont = "n"
	while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
		echo -n "Enter new root password: "; read rootpwd
		echo -n "New password ok [y/n]? "; read -n 1 cont; echo
		if [ "$cont" == "" ]; then cont = "n"; fi
	done
	echo "root:$rootpwd" | sudo chpasswd
fi

#####################################################################################
## SETTING UP WIRELESS NETWORKING
#####################################################################################

echo -n "Set up wireless adapter ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then

	sudo apt-get -y install wireless-tools				# drivers for wifi
	sudo apt-get -y install wpasupplicant				# Other command for wifi drivers

	interface="$(ifconfig -a | grep -i wlan | cut -c1-5)"
	if [ "$interface" == "" ]; then
		echo "---------------------------------------------------------------------------------"
		echo "Your wireless adapter hasn't been detected. You may need to reboot before it"
		echo "can be configured by this script."
		echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
		read -n 1 q; echo
	else
		echo -n "Enter your SSID: "; read ssid
		echo -n "Enter your WPA key: "; read wpa
		echo -en "\n\nSetting up wireless networking... "
		cat files/interfaces | sed -e "s/\#INTERFACE/$interface/" -e "s/\#SSID/$ssid/" -e "s/\#WPA/$wpa/" > ./interfaces
		sudo mv -f ./interfaces /etc/network/
		echo -e "\n\nDone\n\n"
	fi
fi

#####################################################################################
## Setting Tools & Development Environment
#####################################################################################

# 1. Setting up git

echo -n "Want to configure git ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo -n "Enter system username to setup: "; read user
	echo -n "Enter git user.name: "; read gitUser
	echo -n "Enter git user.email: "; read gitEmail
	echo -e "\n\nSetting up git... "
	sudo echo -e "[core]\n    editor = nano\n" > ~/.gitconfig
	sudo echo -e "[user]\n    name = $gitUser\n" >> ~/.gitconfig
	sudo echo -e "    email = $gitEmail\n" >> ~/.gitconfig
	echo -e "\n\nDone\n\n"
fi

# 2. Install node.js

echo -n "Install node.js ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "Setting up Node.js"
	echo "---------------------------------------------------------------------------------"
	sudo apt-get -y install -y curl
	sudo curl -sL https://deb.nodesource.com/setup | bash -
	sudo apt-get install -y nodejs
fi





#####################################################################################
## Determine whether need to reboot or not
#####################################################################################
if [ $reboot == 1 ]; then
		echo "---------------------------------------------------------------------------------"
		echo "Based on the setup we have just executed, you need to reboot the machine for"
		echo "the changes to take effect. We will reboot now."
		echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
		read -n 1 q; echo
		sudo shutdown -r now
fi

