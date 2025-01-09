#!/bin/bash

# Prompt the user for sudo password instead of hardcoding
read -sp "Enter sudo password: " Password
echo

# Uninstall Docker Desktop

# Uninstall Docker Engine (docker-ce) and related components
echo "------------------ Remove docker engine and cli ... ------------------------"
echo $Password | sudo -S apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Remove Docker-related files
echo $Password | sudo -S rm -rf $HOME/.docker
echo $Password | sudo -S rm -rf ./docker.gpg
echo $Password | sudo -S rm -rf /var/lib/docker
echo $Password | sudo -S rm -rf /var/lib/containerd
echo $Password | sudo -S rm -f /usr/local/bin/com.docker.cli

# Perform cleanup
echo $Password | sudo -S apt autoremove -y
echo $Password | sudo -S apt autoclean -y

echo "Docker and all related components have been successfully uninstalled!"

#uninstall GNS3 and clean up
echo " ----------------- start uninstall GNS3  -----------------------" 
#Remove the gns3-gui, gns3-server, and gns3-iou packages using apt:
echo $Password | sudo -S apt remove --purge gns3-gui gns3-server gns3-iou -y

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
echo $Password | sudo -S dpkg --remove-architecture i386

#Update the System
echo $Password | sudo -S apt update


