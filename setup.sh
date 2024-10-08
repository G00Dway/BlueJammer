#!/bin/bash
clear
cat core/graffiti/banner.txt
echo ""
echo "[i] Installing BlueJammer to System (And Requirements)..."

apt update
apt install bluez bluez-tools bluetooth gnome-bluetooth bluemon blueman -y
apt install xterm zenity ssh -y
pip3 install --upgrade pybluez pwntools --break-system-packages

clear
cat core/graffiti/banner.txt
echo ""
echo "[i] Copying files..."

git clone https://github.com/G00Dway/BlueJammer /usr/share/BlueJammerToolkit &> /var/log/bluejammer.log
cp -r /usr/share/BlueJammerToolkit/core/BlueJammer.sh /usr/bin/bluejammer
chmod +x /usr/bin/bluejammer

clear
cat core/graffiti/banner.txt
echo ""
echo "[+] Installation Finished!"
echo '[i] Execute "bluejammer" In your Terminal to run the Script!'