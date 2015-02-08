echo "Initializing new raspberry pi... -- Make sure the raspberry pi is connected to the Internet..."
echo "."
echo "."
echo "."

echo "Refresh apt-get from library ('y' for yes) ? "
read -n 1 q
if [ $q == "y" || $q == "Y" ]; then
	echo "."
	echo "."
	echo "."
	echo "Updating APT-GET libraries and installed packages"
	echo "---------------------------------------------------------------------------------"
	sudo apt-get -y update
	sudo apt-get -y upgrade
fi


echo "."
echo "."
echo "."
echo "Setting US Keyboard"
echo "---------------------------------------------------------------------------------"
sudo cp -f files/keyboard /etc/default/keyboard


