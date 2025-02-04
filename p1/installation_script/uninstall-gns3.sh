#!/bin/bash
#
read -sp "Enter sudo password: " Password
echo
#uninstall GNS3 and clean up
echo " ----------------- start uninstall GNS3  -----------------------" 
#Remove the gns3-gui, gns3-server, and gns3-iou packages using apt:
echo $Password | sudo -S apt remove --purge gns3-gui gns3-server -y

#Remove Additional Dependencies
echo $Password | sudo -S apt autoremove --purge -y

#Remove the GNS3 PPA added during installation:
echo $Password | sudo -S add-apt-repository --remove ppa:gns3/ppa -y

#Clean up any configuration files or residual data:
echo $Password | sudo -S rm -rf ~/.config/GNS3/
echo $Password | sudo -S rm -rf ~/.gns3/

#Remove User from Groups
echo $Password | sudo -S gpasswd -d $(whoami) ubridge
echo $Password | sudo -S gpasswd -d $(whoami) libvirt
echo $Password | sudo -S gpasswd -d $(whoami) kvm
echo $Password | sudo -S gpasswd -d $(whoami) wireshark

#Remove Architecture for IOU Support
#echo $Password | sudo -S dpkg --remove-architecture i386

#Update the System
echo $Password | sudo -S apt update

