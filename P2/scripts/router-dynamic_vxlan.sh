#!/bin/bash

# Export PATH to ensure commands are found
export PATH="/sbin:/usr/sbin:${PATH}"

# Variables
ROUTER_NAME=$(hostname)

if [[ $ROUTER_NAME == "routeur_kadjane-1" ]]; then
    LOCAL_IP="10.1.1.1"
    VXLAN_IP="30.1.1.3"
elif [[ $ROUTER_NAME == "routeur_kadjane-2" ]]; then
    LOCAL_IP="10.1.1.2"
    VXLAN_IP="30.1.1.3"
else
    echo "[ERROR] Unknown router name."
    exit 1
fi

# Clean up existing VXLAN and bridge (if present)
if ip link show vxlan10 &>/dev/null; then
    ip link set vxlan10 down
    ip link delete vxlan10
fi

if ip link show br0 &>/dev/null; then
    ip link set br0 down
    ip link delete br0
fi

# Set static IP addresses
ip addr add $LOCAL_IP/24 dev eth0

# Create VXLAN interface (Multicast group 239.1.1.1)
VXLAN_NAME="vxlan10"
VXLAN_ID=10
MULTICAST_GROUP="239.1.1.1"

ip link add $VXLAN_NAME type vxlan \
    id $VXLAN_ID \
    dev eth0 \
    group $MULTICAST_GROUP \
    dstport 4789 \
    ttl auto

# Bring VXLAN interface up
ip link set $VXLAN_NAME up

# Create bridge and add interfaces
BRIDGE_NAME="br0"
ip link add name $BRIDGE_NAME type bridge
ip link set $BRIDGE_NAME up

# Connect interfaces to bridge
ip link set $VXLAN_NAME master $BRIDGE_NAME
ip link set eth1 master $BRIDGE_NAME

# Assign IP address to eth1 interface (not both eth1 and vxlan10)
ip addr add $VXLAN_IP/24 dev eth1

# Verify configuration
echo "==== VXLAN Configuration ===="
ip -d link show $VXLAN_NAME
echo "==== Bridge Configuration ===="
brctl show $BRIDGE_NAME
echo "==== Bridge MAC Table ===="
brctl showmacs $BRIDGE_NAME
echo "==== IP Configuration ===="
ip addr show