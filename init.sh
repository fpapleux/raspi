#!/bin/bash

echo "Initializing new raspberry pi... -- Make sure the raspberry pi is connected to the Internet..."
echo "."
echo "."
echo "."

#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

echo -n "Refresh apt-get from library ('y' for yes) ? "
read -n 1 q
echo $q
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "Updating APT-GET libraries and installed packages"
	echo "---------------------------------------------------------------------------------"
	sudo apt-get -y update
	sudo apt-get -y upgrade
fi

#####################################################################################
## System Settings
#####################################################################################

echo -n "Set US Keyboard ('y' for yes) ? "
read -n 1 q
echo $q
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "."
	echo "Setting US Keyboard"
	echo "---------------------------------------------------------------------------------"
	sudo cp -f files/keyboard /etc/default/keyboard
fi


