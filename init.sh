#!/bin/bash

clear
echo "Initializing new RaspberryPi"
echo "Make sure it is connected to the Internet..."
echo -e "\nWhen done, reboot and log in using your new user account before continuing.\n\n"


#####################################################################################
## GATHERING USER INPUT
#####################################################################################

set setupWifi = 0
echo -n "Set up wireless adapter ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	set setupWifi = 1
	set cont = "n"
	while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
		echo -n "Enter your SSID: "; read ssid
		echo -n "Enter your WPA key: "; read wpa
		echo -n "Wifi information ok [y/n]? "; read -n 1 cont; echo
	done
fi

echo -e "\nSetting up primary user...\n"
set cont = "n"
while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
	echo -n "Enter username: "; read user
	echo -n "Enter full name: "; read userFullName
	echo -n "Enter password: "; read password
	echo -n "User information ok [y/n]? "; read -n 1 cont; echo
	if [ "$user" == "" ]; then cont = "n"; fi
done

#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

echo -e "\n\nUpdating APT-GET libraries and installed packages... "
sudo apt-get -y -qq update 							# Update library
sudo apt-get -y -qq upgrade 						# Upgrade all local libraries
echo -e "\n\nAPT-GET update complete\n\n"

#####################################################################################
## ADJUSTING SYSTEM SETTINGS
#####################################################################################

echo -en "\n\nSetting US locale and keyboard... "
sudo cp -f files/locale.gen /etc/locale.gen 		# Set locale to US
sudo cp -f files/keyboard /etc/default/keyboard		# Set keyboard layout to US
echo -e "\n\nUS Locale & Keyboard setup complete\n\n"

#####################################################################################
## SETTING UP WIRELESS NETWORKING
#####################################################################################

if [ "$setupWifi" == "1" ]; then

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
		echo -e "\n\nSetting up wireless networking... "
		cat files/interfaces | sed -e "s/\#INTERFACE/$interface/" -e "s/\#SSID/$ssid/" -e "s/\#WPA/$wpa/" > ./interfaces
		sudo mv -f ./interfaces /etc/network/
		echo -e "\n\nWireless Networking setup complete\n\n"
	fi

fi

#####################################################################################
## SETTING UP USER ENVIRONMENT
#####################################################################################

if [ "$user" != "" ]; then
	echo -en "\n\nCreating new user... "
	# cat files/userinfo | sed -e "s/\#PASSWORD/$password/" -e "s/\#USERFULLNAME/$userFullName/" > ./userinfo
	echo -e "$password\n$password\n\n\n\n\n\ny\n" > ./userinfo	# Creating user
	sudo adduser --home /home/"$user" "$user" < ./userinfo	# Creating user
	rm ./userinfo

	# Configuring user environment
	sudo cp -f files/.bashrc /home/"$user"/					# Set bash environment
	sudo cp -f files/.nanorc /home/"$user"/					# Set bash environment

	# Setting up sudo rights
	echo -e "$user\tALL=NOPASSWD:\tALL" > ./user"$user"
	chmod 440 ./user"$user"
	sudo mv -f ./user"$user" /etc/sudoers.d
	
	# Setting up raspi in new user's environment to enable next steps
	cd /home/"$user"
	sudo git clone https://github.com/fpapleux/raspi

	echo -e "\n\nUser environment setup complete\n\n"
fi


#####################################################################################
## Protect the Pi user from being exploited
#####################################################################################
# @TODO



#####################################################################################
## Determine whether need to reboot or not
#####################################################################################
echo "---------------------------------------------------------------------------------"
echo "Based on the work that was just completed we recommend that you restart your"
echo "machine and log back in using your new user account to continue this process."
echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
read -n 1 q; echo
sudo shutdown -r now

