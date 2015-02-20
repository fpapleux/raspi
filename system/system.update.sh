#!/bin/bash

echo -en "\n\nUpdating APT-GET libraries and installed packages... "

sudo apt-get -y update 								# Update library
sudo apt-get -y upgrade 							# Upgrade all local libraries

echo -e "\n\ndone\n\n"
