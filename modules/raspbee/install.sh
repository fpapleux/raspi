#!/bin/sh
sudo dpkg -i ./gcfflasher-latest.deb
sudo dpkg -i ./deconz-latest.deb
sudo dpkg -i ./deconz-dev-latest.deb
sudo apt-get install -y qt4-qmake libqt4-dev

git clone https://github.com/dresden-elektronik/basic-aps-plugin.git
cd basic-aps-plugin
qmake-qt4 && make
sudo cp libbasic_aps_plugin.so /usr/share/deCONZ/plugins

cd ..
git clone https://github.com/dresden-elektronik/deconz-rest-plugin.git
cd deconz-rest-plugin
qmake-qt4 && make

# run deConz by typing $ deCONZ --dbg-info=1
