
#!/bin/bash

# Check if the correct interface exists and rename if needed
INTERFACE=$(ip -o link show | grep "eth0" | awk -F': ' '{print $2}')
if [[ $INTERFACE == "eth0" ]]; then
    ip link set eth0 down
    ip link set eth0 name eth1
    ip link set eth1 up
    echo "[INFO] Interface renamed to eth1"
fi

# Set static IP based on hostname
HOSTNAME=$(hostname)

if [[ $HOSTNAME == "host_kadjane-1" ]]; then
    ip addr add 30.1.1.1/24 dev eth1
    ip route add default via 30.1.1.3
    echo "[INFO] Configured host_kadjane-1"
elif [[ $HOSTNAME == "host_kadjane-2" ]]; then
    ip addr add 30.1.1.2/24 dev eth1
    ip route add default via 30.1.1.3
    echo "[INFO] Configured host_kadjane-2"
else
    echo "[ERROR] Unknown host. Exiting."
    exit 1
fi

# Confirm configuration
ip a
ip r
