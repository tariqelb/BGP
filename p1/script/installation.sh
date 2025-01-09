#!/bin/bash
#
#Install docker

#Get Password
read -sp "Enter sudo password: " Password
echo

###Install Docker on linux ubuntu

#Upadate system
echo "---------------- Update system ---------------------------------"
echo $Password | sudo -S apt update

#Install dependencies
echo "---------------- Install dependencies --------------------------"
echo $Password | sudo -S apt install apt-transport-https ca-certificates curl software-properties-common

#Download Docker gpg key
echo "---------------- Download docker gpg key -----------------------"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o docker.gpg

#Add Docker gpg key to system keyring
echo "---------------- Add docker gpg key to system keyring-----------"
echo $Password | sudo -S apt-key add docker.gpg
rm ./docker.gpg

#Install Docker repository to APT source
echo "---------------- Install docker repo to APT source -------------"
echo $Password | sudo -S add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

#Install Docker
echo "---------------- Install Docker --------------------------------"
echo $Password | sudo -S apt install docker-ce -y

#Add user to Docker group
echo "---------------- Add user to docker group , this action needs a logout to take effect ----------"
echo $Password | sudo -S usermod -aG docker $(whoami)

#Docker version
docker --version
echo "--------------------- installation process of Docker complete --------------------------"

#Install GNS
#
echo "--------------------- install GNS3 ----------------------"
echo $Password | sudo -S add-apt-repository ppa:gns3/ppa
echo $Password | sudo -S apt update                                
echo $Password | sudo -S apt install gns3-gui gns3-server

#add IOU support
echo $Password | sudo -S dpkg --add-architecture i386
echo $Password | sudo -S apt update
echo $Password | sudo -S apt install gns3-iou -y

#add user to groups
echo $Password | sudo -S usermod -aG ubridge,libvirt,kvm,wireshark $(whoami)

#GNS3 version
gns3 --sersion
echo "--------------------- installation process of Docker complete --------------------------"
