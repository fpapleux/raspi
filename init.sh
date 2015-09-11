#!/bin/bash

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e "-------------------------------------------------------------------------------------"
echo -e "| Initializing new RaspberryPi                                                      |"
echo -e "-------------------------------------------------------------------------------------"
echo -e "\n- Make sure it is connected to the Internet... (probably use an ethernet cable at this point)"
echo -en "\n\n-- Press any key to continue --"; read -n 1 cont; echo




#####################################################################################
## GATHERING USER INPUT
#####################################################################################

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e " Gathering configuration input"
echo -e "-------------------------------------------------------------------------------------"
echo -e "\n"

# ----- Refresh System --------------------------------------
cont="n"
refreshSystem=0
echo -n "update & upgrade apt-get packages? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	refreshSystem=1
fi
# echo -e "\n"

# ----- Install Avahi Zeroconf ------------------------------
cont="n"
installAvahi=0
echo -n "Install Avahi daemon package to access this pi with raspberrypi.local? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	installAvahi=1
fi
# echo -e "\n"

# ----- Install Bluetooth suite -----------------------------
installBluetooth=0
echo -n "Install bluetooth USB adapter software? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	installBluetooth=1
fi
# echo -e "\n"

# ----- Setting up US Locale & Keyboard ---------------------
cont="n"
setupLocale=0
echo -n "Set up US locale and keyboard? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	setupLocale=1
fi
# echo -e "\n"

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
# echo -e "\n"

# ----- change pi password --------------------------------
cont="n"
changePiPwd=0
echo -n "Change pi user password? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	changePiPwd=1
	while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
		echo -n "Enter new pi user password: "; read piPassword
		echo -n "User information ok [y/n]? "; read -n 1 cont; echo
		if [ "$piPassword" == "" ]; then cont="n"; fi
	done
fi
# echo -e "\n"

# ----- Setup New user ------------------------------------
cont="n"
setupPrimaryUser=0
echo -n "Set up new user? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	setupPrimaryUser=1
	echo -e "\n\nLet's set up a new primary user..."
	while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
		echo -n "Enter username: "; read user
		echo -n "Enter full name: "; read userFullName
		echo -n "Enter password: "; read password
		echo -n "User information ok [y/n]? "; read -n 1 cont; echo
		if [ "$user" == "" ]; then cont="n"; fi
	done
fi
# echo -e "\n"

# ----- Set Up file system expansion ---------------------
cont="n"
expandFilesytem=0
echo -n "Expand file system to the whole card? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	expandFilesystem=1
fi
# echo -e "\n"

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
# echo -e "\n"

# ----- Install node.js --------------------------------------
cont="n"
installNode=0
compileNode=0
echo -n "Install node.js? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	installNode=1
	cont="n"
	echo -n "Do you want to install node.js from source (compile)? ('y' for yes) "
	read -n 1 q; echo
	if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
		compileNode=1
	fi
fi
# echo -e "\n"


# ----- Install node.js --------------------------------------
cont="n"
installJava8=0
echo -n "Install Oracle Java 8? ('y' for yes) "
read -n 1 q; echo
if [ "$q" == "y" ] || [ "$q" == "Y" ]; then
	installJava8=1
fi
# echo -e "\n"




#####################################################################################
## DEFAULT CHANGES
#####################################################################################
sudo cp -f files/.bashrc /home/pi					# Set bash environment
sudo cp -f files/.nanorc /home/pi					# Set bash environment
sudo chown pi:pi /home/pi/.bashrc
sudo chown pi:pi /home/pi/.nanorc
mkdir ~/temp




#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

if [ "$refreshSystem" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Updating APT-GET libraries and installed packages..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get -y -qq update 							# Update library
	sudo apt-get -y -qq upgrade 						# Upgrade all local libraries
	sudo apt-get -y autoremove							# removes redundant packages after upgrade
	echo -e "\n\nAPT-GET update complete\n\n"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

fi





#####################################################################################
## Install Avahi Daemon for zeroconf access (raspberrypi.local)
#####################################################################################

if [ "$installAvahi" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Installing Avahi..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get -y install avahi-daemon 
	echo -e "\n\nAvahi Daemon Installed...\n\n"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

fi





#####################################################################################
## Installing bluetooth tools
#####################################################################################

if [ "$installBluetooth" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Installing Bluetooth tools..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get -y install bluez
	sudo apt-get -y install python-gobject
	echo -e "\n\nVerify that your bluetooth adapter is displayed below:"
	hcitool dev
	echo -e "\n\nBluetooth installed...\n\n"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

fi





#####################################################################################
## ADJUSTING SYSTEM SETTINGS
#####################################################################################

if [ "$setupLocale" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Setting US locale and keyboard..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo cp -f files/locale.gen /etc/locale.gen 		# Set locale to US
	sudo cp -f files/keyboard /etc/default/keyboard		# Set keyboard layout to US
	echo -e "\n\nUS Locale & Keyboard setup complete\n\n"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

fi





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
		## Grab encoded PSK from SSID and WPA Key
		# wpaPsk=$(wpa_passphrase "$ssid" "$wpa" | grep 'psk=[^"]' | tr -d "\tpsk=")

		cat files/interfaces | sed -e "s/\#INTERFACE/$interface/" -e "s/\#SSID/$ssid/" -e "s/\#WPA/$wpa/" > ./interfaces
		sudo mv -f ./interfaces /etc/network/
		sudo ifdown $interface
		sudo ifup $interface
		echo -e "\n\nWireless Networking setup complete\n\n"
	fi
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

fi





#####################################################################################
## SETTING UP USER ENVIRONMENT
#####################################################################################

if [ "$setupPrimaryUser" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Setting up new primary user..."
	echo -e "-------------------------------------------------------------------------------------"

	if [ "$user" != "" ]; then
		# Code updated to deprecate below system of 
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
		sudo chmod 440 ./"$user"
		
		sudo mv -f ./"$user" /etc/sudoers.d

		# Setting up raspi in new user's environment to enable next steps
		cd /home/"$user"
		sudo git clone https://github.com/fpapleux/raspi 		# clone git repo into new user home
		sudo chown -R "$user":"$user" *									# change owner of repo files to new user

		echo -e "\n\nUser environment setup complete\n\n"
	fi
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

fi





#####################################################################################
## Changing Pi Password
#####################################################################################

if [ "$changePiPwd" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Changing Pi Password..."
	echo -e "-------------------------------------------------------------------------------------"

	echo "pi:$piPassword" | sudo chpasswd
	echo -e "\n\npi user passowrd changed...\n\n"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi





#####################################################################################
## Expand filesystem to the maximum on the card
#####################################################################################

if [ "$expandFilesystem" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Expanding file system..."
	echo -e "-------------------------------------------------------------------------------------"
	
	$HOME/raspi/expand_filesystem.sh
	echo -e "\n\nFilesystem expansion complete"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi




#####################################################################################
## Set up new hostname
## --- Thanks to raspi-config, published under the MIT license
#####################################################################################

if [ "$setupHostname" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Setting up new host name..."
	echo -e "-------------------------------------------------------------------------------------"
	
	currentHostname=`sudo cat /etc/hostname | tr -d " \t\n\r"`
	if [ $? -eq 0 ]; then
		echo $newHostname > ~/hostname
		sudo mv -f ~/hostname /etc
		sudo cp /etc/hosts ~
		sudo sed -i "s/127.0.1.1.*$currentHostname/127.0.1.1\t$newHostname/g" ~/hosts
		sudo mv -f ~/hosts /etc
		set HOSTNAME="$newHostname"
	fi
	echo -e "\n\nHostname setup complete"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi






#####################################################################################
## Install node.js
#####################################################################################

if [ "$installNode" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Installing node.js..."
	echo -e "-------------------------------------------------------------------------------------"

	if [ "$compileNode" == "1" ]; then
		cd ~/temp
		wget http://nodejs.org/dist/v0.12.2/node-v0.12.2.tar.gz
		tar -xvf node-v0.12.2.tar.gz
		cd node-v0.12.2
		sudo ./configure
		sudo make
		sudo make install
	else
		curl -sLs https://apt.adafruit.com/add | sudo bash
		sudo apt-get install node
	fi
	node --version

	echo -e "\n\n Node JS install complete -- current version is $(node -v)"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi






#####################################################################################
## Install Oracle Java 8
#####################################################################################

if [ "$installJava8" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Installing Oracle Java 8..."
	echo -e "-------------------------------------------------------------------------------------"

	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get -y install oracle-java8-installer
	sudo apt-get -y install oracle-java8-set-default

	echo -e "\n\n Oracle Java 8 install complete"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi







#####################################################################################
## Install Cassandra 2.2
#####################################################################################
# NOTE: ONLY WORKS WITH VERSION 2.2 -- Need to find the "current version" directory...

if [ "$installCassandra" == "1" ]; then

	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Installing Apache Cassandra 2.2.1..."
	echo -e "-------------------------------------------------------------------------------------"

	sudo sh -c 'echo "deb http://debian.datastax.com/community/ stable main" >> /etc/apt/sources.list.d/datastax.list'
	curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -
	sudo apt-get update
	sudo apt-get -y install dsc22
	sudo service cassandra start

	echo -e "\n\n Apache Cassandra 2.2.1 install complete"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi



#####################################################################################
## Install maven 3
#####################################################################################

if [ "$installMaven" == "1" ]; then
	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Installing Apache Maven 3..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get -y install maven

	echo -e "\n\n Apache Maven 3 install complete"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi



#####################################################################################
## Install Usergrid
#####################################################################################

if [ "$installUsergrid" == "1" ]; then
	clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
	echo -e " Installing Apache Usergrid..."
	echo -e "-------------------------------------------------------------------------------------"

	cd ~
	git clone http://github.com/apache/usergrid
	cd usergrid/stack
	

	echo -e "\n\n Apache Maven 3 install complete"
	# echo -n "-- Press any key to continue --"; read -n 1 cont; echo
fi



#####################################################################################
## Reboot the machine
#####################################################################################

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo "---------------------------------------------------------------------------------"
echo "Based on the work that was just completed we recommend that you restart your"
echo "machine and log back in using your new user account to continue this process."
echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
read -n 1 q; echo
sudo shutdown -r now

