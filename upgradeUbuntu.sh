#!/bin/bash

#Need to run this as super user

echo "Upgrading ubuntu from 22 to 23"

#note: use lsblk -aO if blkid doesn't have swap... which is weird
sudo printf "RESUME=UUID=$(blkid | awk -F\" '/swap/ {print $2}')\n" | sudo tee /etc/initramfs-tools/conf.d/resume

echo "downloading updates to minimize incompatibility..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install update-manager-core -y
sudo apt-get dist-upgrade -y

echo "performing release upgrade..."
do-release-upgrade
sed -i 's/lts/normal/g' /etc/update-manager/release-upgrades
sed -i 's/jammy/lunar/g' /etc/apt/sources.list

echo "performing new distro updates...."
#Update packages list
sudo apt-get update -y

#Upgrade packages
sudo apt-get upgrade -y

#Run full upgrade
sudo apt-get dist-upgrade -y

#If any error re-run
#sudo apt-get update
#sudo apt-get dist-upgrade

echo "cleaning up"
#Run cleanup
sudo apt-get autoremove -y
sudo apt-get clean -y

echo "disabling windows preview"
sudo gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'cycle-windows'

echo "rebooting system"
#Reboot the system
sudo reboot
