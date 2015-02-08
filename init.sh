echo "Initializing new raspberry pi... -- Make sure the raspberry pi is connected to the Internet..."
echo "."
echo "."
echo "."

echo "Refresh apt-get from library ('y' for yes) ? "
read -n 1 q
if [ "$q" == "y" || "$q" == "Y" ]; then
	scripts/update-system.sh
fi



echo "."
echo "."
echo "."
echo "Setting US Keyboard"
echo "---------------------------------------------------------------------------------"
sudo cp -f files/keyboard /etc/default/keyboard


