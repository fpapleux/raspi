#
# Raspberry Pi Setup System
#

I created this system to accelerate provisioning a Raspberry Pi from scratch, which is something I do on a regular basis, at least every time I start a new project. I hope you find this useful.

<h3>Step 1: Load Raspbian onto a Micro SD card</h3>

Note that these instructions work on my Macbook Pro running Mac OS X Mavericks. I haven't tested this on any other system. If you are using a different system and you would like to add to this, please let me know and I'll be glad to make room for your contribution.

1. Dowload the latest Raspbian build ZIP file from http://www.raspberrypi.org/downloads/

2. Open your terminal (Found in Applications/Utilities) for the rest of the operations. I created a directory where my raspbian images live at ~/dev/raspi_os. You should CD into that directory.

3. Unzip the raspbian image: ``` unzip ~/Downloads/<Raspbian image filename>.zip ./ ``` and remove the zip file from your Downloads: ``` rm -f ~/Downloads/<Raspbian image filename>.zip ```. Verify the presence of the image file in your current directory. it should be ``` <Raspbian image filename>.img ```

4. BEFORE you insert the SD Card, type ``` df -h ``` to list the mounted file systems. By doing this, you will be able to see which one is the SD Card.

5. Insert the SD Card into your Mac, wait a few seconds, and type ``` df -h ``` again. Compare the entries to see what device is your SD Card. Mine shows up as ``` /dev/disk1s1 ``` but it could be /dev/disk2s1 when my backup drive is connected. It's important to know that it's not necessarily always the same path.

6. Unmount the disk that you know is the SD Card: ``` sudo diskutil unmount /dev/disk1s1 ```

7. Write the image onto the card: ``` sudo dd bs=1m if=<Raspbian image filename>.img of=/dev/rdisk1 ``` (note that rdisk1 refers to your disk1s1) This operation may take a while.

8. Before removing the card, type ``` sudo diskutil eject /dev/rdisk1 ```

That's it. Remove the SD Card from your computer and load it into your Raspberry Pi. It is ready for first boot. Move on to the next section.

<h3>Step 2: Run your Raspberry Pi for the first time</h3>

In order to run the next steps, please make sure your raspberry pi is connected to the internet.  On first boot, you would ideally plug in an ethernet cable.  Note that the process will take you through configuring a wireless adapter (I am always using the EDIMAX EW7811, which is a tiny 802.11n USB adapter).

1. Start your Raspberry Pi. It will boot automatically into the configuration tool, raspi-config. It's a good tool but it's insufficient for our use so just exit.

2. Install this system by cloning this repository. It is done by typing the following commands:
	```
	cd ~
	git clone https://github.com/fpapleux/raspi
	cd raspi ```

3. Execute ``` sudo ./init.sh ``` to go through the initialization process.

4. Reboot the system as suggested and log in with your new user. This should be safe to work now.

<h3>Acknowledgments</h3>

I need to thank whoever wrote Wheezy installation self-help guide at Instant Support Site for the valuable information (http://www.instantsupportsite.com). It has been extremely useful.
