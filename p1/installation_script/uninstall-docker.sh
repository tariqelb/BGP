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
echo $Password | sudo -S rm -rf /etc/apt/keyrings/docker.gpg
echo $Password | sudo -S rm -rf /var/lib/docker
echo $Password | sudo -S rm -rf /var/lib/containerd
echo $Password | sudo -S rm -f /usr/local/bin/com.docker.cli

# Perform cleanup
echo $Password | sudo -S apt autoremove -y
echo $Password | sudo -S apt autoclean -y

echo "Docker and all related components have been successfully uninstalled!"

