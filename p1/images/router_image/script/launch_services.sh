#!/bin/sh
#


#Setup three vxlan interface and mapped them to ethernet interface

#vxlan10
#ip link add vxlan10 type vxlan id 10 dev eth0 dstport 4789
#ip link set vxlan10 up

#vxlan20
#ip link add vxlan20 type vxlan id 20 dev eth1 dstport 4789
#ip link set vxlan20 up

#assign an IP address 
#ip addr add 192.168.10.1/24 dev vxlan0

#display the interface
#ip addr show vxlan0

#Create the Bridge Interface:
#ip link add name br10 type bridge

#ip link add name br20 type bridge

#map vxlan10 to eth0 by Bridge:
#ip link set vxlan10 master br10
#ip link set eth1 master br10

#ip link set vxlan20 master br10
#ip link set eth1 master br20

#Bring Up All Interfaces:
#ip link set vxlan10 up
#ip link set br10 up
#ip link set eth1 up

#ip link set vxlan20 up
#ip link set br20 up
#ip link set eth1 up


#start routing services

/usr/sbin/ospfd -d -f /etc/quagga/ospfd.conf  
/usr/sbin/isisd -d -f /etc/quagga/isisd.conf 
/usr/sbin/bgpd  -d -f /etc/quagga/bgpd.conf 
/usr/sbin/zebra -d -f /etc/quagga/zebra.conf

/bin/sh
