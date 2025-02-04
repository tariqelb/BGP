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
echo $Password | sudo -S apt upgrade -y

#Install dependencies
echo "---------------- Install dependencies --------------------------"
echo $Password | sudo -S apt install -y apt-transport-https ca-certificates curl software-properties-common

#Download Docker gpg key
echo "---------------- Download docker gpg key -----------------------"
echo "---------------- Add docker gpg key to system keyring-----------"
#echo $Password | sudo -S curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/trusted.gpg.d/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Install Docker repository to APT source
echo "---------------- Install docker repo to APT source -------------"
#echo $Password | sudo -S add-apt-repository "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu focal stable"
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable" -y

# Update package index
echo "---------------- Update package index --------------------------"
echo $Password | sudo -S apt update

#Install Docker
echo "---------------- Install Docker --------------------------------"
echo $Password | sudo -S apt install docker-ce -y

#Add user to Docker group
echo "---------------- Add user to docker group , this action needs a logout to take effect ----------"
echo $Password | sudo -S usermod -aG docker $(whoami)

#Docker version
docker --version
echo "--------------------- installation process of Docker complete --------------------------"

