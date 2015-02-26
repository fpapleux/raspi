#
# Raspberry Pi Setup System
#

I created this system because as you start playing with raspberry pi's, you often find yourself refreshing the SD card with the latest raspbian build, at least whenever I start a new project, and then you have to re-build everything you spent so much time configuring during your last project. I thought there needed to be a better way to do this while at the same time not overdoing it. I hope you find this useful.

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

