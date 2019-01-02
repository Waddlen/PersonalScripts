#!/bin/bash

#manual apps: chrome, discord, steam

### Disable apport
# apport is a tool to report bugs, but seems to pop up frequently
# under normal Chrome usage and just serves to waste time and look scary
sudo systemctl disable apport.service
sudo systemctl mask apport.service

### Lower shutdown wait time
# Some applications don't shutdown until forced, making all shutdowns take the
# longest time allowed (default 90s), this changes it to 100ms for a speedy shutdown
sudo sed -i 's/#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=100ms/g' /etc/systemd/system.conf
sudo systemctl daemon-reexec

### Enable partner repository
# Necessary for some proprietary drivers, e.g. some laptop wi-fi chips
sudo sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list
sudo apt update

### Add Nvidia drivers PPA
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update

### Add AMD drivers PPA
# Not currently using AMD on main machine
#sudo add-apt-repository ppa:paulo-miguel-dias/pkppa
#sudo apt-get update

### Setup Flatpak & Flathub
sudo add-apt-repository ppa:alexlarsson/flatpak
sudo apt update
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

### Software
sudo apt install gnome-tweaks
# sudo apt purge firefox
flatpak install flathub org.gimp.GIMP

# Change time to AM/PM
# Change Steam interface to turn off ads
