#
# Raspberry Pi Setup System
#

I created this system to accelerate provisioning a Raspberry Pi from scratch, which is something I do on a regular basis, at least every time I start a new project. I hope you find this useful.

<h3>Step 1: Load Raspbian onto a Micro SD card<h3>

Note that these instructions work on my Macbook Pro running Mac OS X Mavericks. I haven't tested this on any other system. If you are using a different system and you would like to add to this, please let me know and I'll be glad to make room for your contribution.

1. Dowload the latest Raspbian build ZIP file from http://www.raspberrypi.org/downloads/

2. Open your terminal (Found in Applications/Utilities) for the rest of the operations. I created a directory where my raspbian images live at ~/dev/raspi_os. You should CD into that directory.

3. Unzip the raspbian image: ``` unzip ~/Downloads/<Raspbian image filename>.zip ./ ``` and remove the zip file from your Downloads: ``` rm -f ~/Downloads/<Raspbian image filename>.zip ```



1 - Make sure your raspberry pi is connected to the internet.  For me it's as simple as plugging an ethernet cable. The process takes you through configuring a wireless adapter (I am always using the EDIMAX EW7811, which is a tiny 802.11n USB adapter).

2 - Log into your raspberry pi using the 'pi' user and 'raspberry' as password. This the standard defined user. This process will secure this account so don't worry for now.

3 - Ensure that you have git installed (just type 'git' at the command prompt and see if it works). If it isn't installed, install it by typing:

```
	sudo apt-get install git-core
```

4 - Clone this repository: 

```
	cd ~
	git clone https://github.com/fpapleux/raspi
```
This will have created a raspi directory in the pi user's home.

5 - Next, execute 'init.sh' to go through the first part of the process:

```
	cd ~/raspi
	sudo ./init.sh
```
After updating the system, the script will force you to restart the machine. This is just a precaution I included to make sure that the next script will run with a fresh start.

6 - After rebooting, log in using your new user credentials and execute the second part of the process:

```
	cd ~/raspi
	sudo ./raspi.sh
```
Just follow the script's instructions. It should be clear enough. If it isn't, drop me a note...

