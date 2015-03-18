#!/bin/bash

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e "-------------------------------------------------------------------------------------"
echo -e "| Initializing new RaspberryPi                                                      |"
echo -e "-------------------------------------------------------------------------------------"
echo -e "\n- Make sure it is connected to the Internet..."
echo -e "- The system will force you to create a new primary user for security. In the next step the Pi user will be deleted."
echo -e "- When done you will be asked to reboot. After reboot, run ~/raspi/raspi.sh"
echo -n "-- Press any key to continue --"; read -n 1 cont; echo




#####################################################################################
## GATHERING USER INPUT
#####################################################################################

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e " Gathering all user input"
echo -e "-------------------------------------------------------------------------------------"

# ----- Setup Wifi ------------------------------------------
setupWifi=0
echo -n "Set up wireless adapter? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	setupWifi=1
	cont="n"
	while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
		echo -n "Enter your SSID: "; read ssid
		echo -n "Enter your WPA key: "; read wpa
		echo -n "Wifi information ok [y/n]? "; read -n 1 cont; echo
	done
fi

# ----- Setup New username ----------------------------------
cont="n"
setupPrimaryUser=1
echo -e "\n\nLet's set up a new primary user..."
while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
	echo -n "Enter username: "; read user
	echo -n "Enter full name: "; read userFullName
	echo -n "Enter password: "; read password
	echo -n "User information ok [y/n]? "; read -n 1 cont; echo
	if [ "$user" == "" ]; then cont="n"; fi
done
echo -n "-- Press any key to continue --"; read -n 1 cont; echo

# ----- Setup hostname --------------------------------------
cont="n"
setupHostname=0
echo -n "Set up new hostname? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	setupHostname=1
	cont="n"
	while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
		echo -n "Enter new hostname: "; read newHostname
		echo -n "Hostname ok [y/n]? "; read -n 1 cont; echo
	done
fi




#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e " Updating APT-GET libraries and installed packages..."
echo -e "-------------------------------------------------------------------------------------"
sudo apt-get -y -qq update 							# Update library
sudo apt-get -y -qq upgrade 						# Upgrade all local libraries
echo -e "\n\nAPT-GET update complete\n\n"
echo -n "-- Press any key to continue --"; read -n 1 cont; echo





#####################################################################################
## ADJUSTING SYSTEM SETTINGS
#####################################################################################

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e " Setting US locale and keyboard..."
echo -e "-------------------------------------------------------------------------------------"
sudo cp -f files/locale.gen /etc/locale.gen 		# Set locale to US
sudo cp -f files/keyboard /etc/default/keyboard		# Set keyboard layout to US
echo -e "\n\nUS Locale & Keyboard setup complete\n\n"
echo -n "-- Press any key to continue --"; read -n 1 cont; echo





#####################################################################################
## SETTING UP WIRELESS NETWORKING
#####################################################################################

if [ "$setupWifi" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Setting up wireless networking..."
	echo -e "-------------------------------------------------------------------------------------"
	
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
		cat files/interfaces | sed -e "s/\#INTERFACE/$interface/" -e "s/\#SSID/$ssid/" -e "s/\#WPA/$wpa/" > ./interfaces
		sudo mv -f ./interfaces /etc/network/
		echo -e "\n\nWireless Networking setup complete\n\n"
	fi
	echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi





#####################################################################################
## SETTING UP USER ENVIRONMENT
#####################################################################################

if [ "$setupPrimaryUser" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Setting up new primary user..."
	echo -e "-------------------------------------------------------------------------------------"
	
	if [ "$user" != "" ]; then
		# cat files/userinfo | sed -e "s/\#PASSWORD/$password/" -e "s/\#USERFULLNAME/$userFullName/" > ./userinfo
		# echo -e "$password\n$password\n\n\n\n\n\ny\n" > ./userinfo	# Creating user
		# sudo adduser --home /home/"$user" "$user" < ./userinfo	# Creating user
		# rm ./userinfo
		sudo adduser "$user" --gecos "$userFullName, , , " --disabled-password
		echo "$user:$password" | sudo chpasswd

		# Configuring user environment
		sudo cp -f files/.bashrc /home/"$user"/					# Set bash environment
		sudo cp -f files/.nanorc /home/"$user"/					# Set bash environment
		sudo chown "$user":"$user" /home/"$user"/.bashrc
		sudo chown "$user":"$user" /home/"$user"/.nanorc

		# Setting up sudo rights
		echo -e "$user ALL=(ALL) NOPASSWD: ALL" > ./"$user"
		sudo chown -R root:root ./"$user"
		chmod 440 ./"$user"

		sudo mv -f ./"$user" /etc/sudoers.d
		
		# Setting up raspi in new user's environment to enable next steps
		cd /home/"$user"
		sudo git clone https://github.com/fpapleux/raspi 		# clone git repo into new user home
		sudo chown -R "$user":"$user" *									# change owner of repo files to new user

		echo -e "\n\nUser environment setup complete\n\n"
	fi
	echo -n "-- Press any key to continue --"; read -n 1 cont; echo

fi





#####################################################################################
## Set up new hostname
## --- Thanks to raspi-config, published under the MIT license
#####################################################################################
currentHostname=`sudo cat /etc/hostname | tr -d " \t\n\r"`
if [ $? -eq 0 ]; then
	sudo echo $newHostname > /etc/hostname
	sudo sed -i "s/127.0.1.1.*$currentHostname/127.0.1.1\t$newHostname/g" /etc/hosts
fi
echo "\n\nHostname setup complete"
echo -n "-- Press any key to continue --"; read -n 1 cont; echo




#####################################################################################
## Expand filesystem to the maximum on the card
#####################################################################################
sudo ./system/expand_filesystem.sh
echo "\n\nFilesystem expansion complete"
echo -n "-- Press any key to continue --"; read -n 1 cont; echo





#####################################################################################
## Reboot the machine
#####################################################################################
echo "---------------------------------------------------------------------------------"
echo "Based on the work that was just completed we recommend that you restart your"
echo "machine and log back in using your new user account to continue this process."
echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
read -n 1 q; echo
sudo shutdown -r now

