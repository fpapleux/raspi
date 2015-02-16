#!/bin/bash

echo "Initializing new raspberry pi... -- Make sure the raspberry pi is connected to the Internet..."
echo "."
echo "."
echo "."




#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

echo -n "Refresh apt-get from library ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "Updating APT-GET libraries and installed packages"
	echo "---------------------------------------------------------------------------------"
	sudo apt-get -y update 								# Update library
	sudo apt-get -y upgrade 							# Upgrade all local libraries
	sudo apt-get -y install build-essential				# Essentials compilers, etc.
	sudo apt-get -y install wireless-tools				# drivers for wifi
	sudo apt-get -y install wpasupplicant				# Other command for wifi drivers
	read -n 4 wlan_exist << ifconfig -a | grep -i wlan
	if [ "$wlan_exist" == ""]; then
		echo "---------------------------------------------------------------------------------"
		echo "Your wireless adapter hasn't been detected. You may need to reboot before it"
		echo "can be configured by this script."
		echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
		read -n 1 q; echo
	fi
	read -n 5 wlan_exist << ifconfig -a | grep -i wlan
fi







#####################################################################################
## SETTING UP WIRELESS NETWORKING
#####################################################################################

echo -n "Set up wireless adapter ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo -n "Enter your SSID: "
	read ssid; echo
	echo -n "Enter your WPA key: "
	read wpa; echo
	echo "."
	echo "."
	echo "."
	echo "Setting up wireless networking"
	echo "---------------------------------------------------------------------------------"

	read -n 4 wlan_exist << ifconfig -a | grep -i wlan
	if [ "$wlan_exist" == ""]; then
		echo "---------------------------------------------------------------------------------"
		echo "Your wireless adapter hasn't been detected. You may need to reboot before it"
		echo "can be configured by this script."
		echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
		read -n 1 q; echo
	else
		# Assuming wlan0 is the network adapter to use

	fi
	read -n 5 wlan_exist << ifconfig -a | grep -i wlan
fi







#####################################################################################
## System Settings
#####################################################################################

echo -n "Set US locale and keyboard ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "Setting US locale and keyboard"
	echo "---------------------------------------------------------------------------------"
	sudo cp -f files/locale.gen /etc/locale.gen 		# Set locale to US
	sudo cp -f files/keyboard /etc/default/keyboard		# Set keyboard layout to US
fi






#####################################################################################
## Setting User Environment
#####################################################################################

## INCOMPLETE

echo -n "Setting user environment ('y' for yes) ? "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "Setting up user environment"
	echo "---------------------------------------------------------------------------------"
	echo -n "Enter user name [end with ENTER]: "
	read user; echo
	echo -n "Enter password for new user [end with ENTER]: "
	read pwd; echo

	sudo cp -f files/.bashrc ~							# Set bash environment
fi





#####################################################################################
## Setting Toole & Development Environment
#####################################################################################

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

