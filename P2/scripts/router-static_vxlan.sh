#!/bin/bash

# Variables (change based on the router identity)
ROUTER_NAME=$(hostname)

if [[ $ROUTER_NAME == "routeur_kadjane-1" ]]; then
    LOCAL_IP="10.1.1.1"
    VXLAN_IP="30.1.1.3"
    REMOTE_IP="10.1.1.2"
elif [[ $ROUTER_NAME == "routeur_kadjane-2" ]]; then
    LOCAL_IP="10.1.1.2"
    VXLAN_IP="30.1.1.3"
    REMOTE_IP="10.1.1.1"
else
    echo "[ERROR] Unknown router name."
    exit 1
fi

# Cleanup existing VXLAN and bridge interfaces
if ip link show vxlan10 &>/dev/null; then
    ip link set vxlan10 down
    ip link delete vxlan10
fi

if ip link show br0 &>/dev/null; then
    ip link set br0 down
    ip link delete br0
fi

# Set static IP addresses on eth0 and eth1
ip addr add $LOCAL_IP/24 dev eth0
ip addr add $VXLAN_IP/24 dev eth1

# Create VXLAN interface
VXLAN_NAME="vxlan10"
VXLAN_ID=10
ip link add $VXLAN_NAME type vxlan \
    id $VXLAN_ID \
    dev eth0 \
    local $LOCAL_IP \
    remote $REMOTE_IP \
    dstport 4789

# Bring VXLAN interface up
ip link set $VXLAN_NAME up
ip addr add $VXLAN_IP/24 dev $VXLAN_NAME

# Create bridge and add interfaces
BRIDGE_NAME="br0"
ip link add name $BRIDGE_NAME type bridge
ip link set $BRIDGE_NAME up

ip link set $VXLAN_NAME master $BRIDGE_NAME
ip link set eth1 master $BRIDGE_NAME

# Verify configuration
ip -d link show $VXLAN_NAME
ip a
