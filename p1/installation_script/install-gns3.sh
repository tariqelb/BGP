#!/bin/bash
#
read -sp "Enter sudo password: " Password
echo

#Install GNS
#
echo "--------------------- install GNS3 ----------------------"
echo $Password | sudo -S add-apt-repository ppa:gns3/ppa -y
echo $Password | sudo -S apt update

echo "---------------- install gns3-gui -----------------"

#Set the first gui configuration opetion to yes
echo "ubridge ubridge/install-setuid boolean true" | sudo debconf-set-selections

#Set the second gui configuration opetion to yes
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

echo $Password | sudo -S apt install gns3-gui -y 

echo "---------------- install gns3-server -----------------"
echo $Password | sudo -S apt install gns3-server -y

echo "---------- add user to groups--------------"
#add user to groups
sleep 15
echo $Password | sudo -S usermod -aG ubridge,libvirt,kvm,wireshark $(whoami)

