#
# Raspberry Pi Setup System
#

I created this system to accelerate provisioning a Raspberry Pi from scratch, which is something I do on a regular basis, at least every time I start a new project. I hope you find this useful.

<i>I am in the process of moving the contents of this documentation into the wiki because it is getting too big to just stand in a README file. Links are provided below for the sections already documented.</i>

The first step I normally go through is to grab the latest Raspbian distribution and [load it onto an SD card](https://github.com/fpapleux/raspi/wiki/Step-1:-Loading-Raspbian-onto-an-SD-Card) to get started.

<h3>Step 2: Run your Raspberry Pi for the first time</h3>

In order to run the next steps, please make sure your raspberry pi is connected to the internet.  On first boot, you would ideally plug in an ethernet cable.  Note that the process will take you through configuring a wireless adapter (I am always using the EDIMAX EW7811, which is a tiny 802.11n USB adapter).

1. Start your Raspberry Pi. It will boot automatically into the configuration tool, raspi-config. It's a good tool but it's insufficient for our use so just exit.

2. Install this system by cloning this repository. It is done by typing the following commands:
	```
	cd ~
	git clone https://github.com/fpapleux/raspi
	cd raspi
	```

3. Execute ``` sudo ./init.sh ``` to go through the initialization process.

4. Reboot the system as suggested and log in with your new user. This should be safe to work now.

<h3>Acknowledgments</h3>

I need to thank whoever wrote Wheezy installation self-help guide at Instant Support Site for the valuable information (http://www.instantsupportsite.com). It has been extremely useful.
