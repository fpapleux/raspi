#!/bin/bash

choice="*"
while [ "$choice" != "0" ]; do

	clear
	echo -e "\n\n"
	echo "          +---------------------------------------------------------------------+"
	echo "          |                                                                     |"
	echo "          |                Raspberry Pi Quick Setup Main Menu                   |"
	echo "          |                                                                     |"
	echo "          +---------------------------------------------------------------------+"
	echo -e "\n\n"
	echo -e "               Please choose one of the following actions:\n\n"
	echo -e "               1. System Update"
	echo -e "\n               0. Exit"
	echo -en "\n\n\nPlease enter your choice [1-0]: "; read choice

	case $choice in
		0)		exit
				;;
		1)		sudo scripts/system.update.sh
				;;
	esac

done
