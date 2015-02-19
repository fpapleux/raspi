#!/bin/bash

echo "Initializing new raspberry pi... -- Make sure the raspberry pi is connected to the Internet..."
echo "\n\n\n"
reboot=0



#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

echo -n "Refresh system and apt-get from library ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo -n "\n\nUpdating APT-GET libraries and installed packages... "
	sudo apt-get -y update 								# Update library
	sudo apt-get -y upgrade 							# Upgrade all local libraries
	echo "done\n\n"
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
		echo -n "\n\nSetting up wireless networking... "
		cat files/interfaces | sed -e "s/\#INTERFACE/$interface/" -e "s/\#SSID/$ssid/" -e "s/\#WPA/$wpa/" > ./interfaces
		sudo mv -f ./interfaces /etc/network/
		reboot=1
		echo "done\n\n"
	fi
fi






#####################################################################################
## ADJUSTING SYSTEM SETTINGS
#####################################################################################

echo -n "Set US locale and keyboard ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo -n "\n\nSetting US locale and keyboard... "
	sudo cp -f files/locale.gen /etc/locale.gen 		# Set locale to US
	sudo cp -f files/keyboard /etc/default/keyboard		# Set keyboard layout to US
	echo "done\n\n"
fi






#####################################################################################
## SETTING UP USER ENVIRONMENT
#####################################################################################

# Manage users

q="y"
while [ "$q" == "y" ] || [ "$q" == "Y" ]; do
	echo -n "Need to add a new admin user ('y' for yes) ? "
	read -n 1 q; echo
	if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
		echo -n "Enter username: "; read user
		echo -n "Enter full name: "; read userFullName
		echo -n "Enter password: "; read password
		if [ "$user" != "" ]; then
			echo -n "\n\nAdding new user... "
			cat files/userinfo | sed -e "s/\#PASSWORD/$password/" -e "s/\#USERFULLNAME/$userFullName/" -e "s/\#CR/\n/" > ./userinfo
			sudo adduser --home /home/"$user" "$user" < ./userinfo	# Creating user
			sudo cp -f files/.bashrc /home/"$user"/					# Set bash environment
			sudo cp -f files/.nanorc /home/"$user"/					# Set bash environment
			# Use deluser USER to remove users (deluser --group GROUP for groups)
			echo "done\n\n"
		fi
	fi	
done






#####################################################################################
## Setting Tools & Development Environment
#####################################################################################

# 1. Install git

echo -n "Install git ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo -n "\n\ninstalling git... "
	sudo apt-get -y install git-core
	echo -n "Enter system username to setup: "; read user
	echo -n "Enter git user.name: "; read gitUser
	echo -n "Enter git user.email: "; read gitEmail
	sudo echo "[core]\n    editor = nano\n" > /home/"$user"/.gitconfig
	sudo echo "[user]\n    name = $gitUser\n" >> /home/"$user"/.gitconfig
	sudo echo "    email = $gitEmail\n" >> /home/"$user"/.gitconfig
	echo "done\n\n"
fi



	# sudo apt-get -y install build-essential			# Essentials compilers, etc. 
														# --> ONLY USE with large SD Card

## INCOMPLETE

echo -n "Install Node.js ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "Setting up Node.js"
	echo "---------------------------------------------------------------------------------"
	sudo apt-get install -y curl
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

