#!/bin/sh


ip addr add 1.1.1.4/32 dev lo
ip addr del 127.0.0.1/8 dev lo
ip addr add 192.168.1.10/30 dev eth1


ip link add vxlan10 type vxlan id 10 dev eth1 dstport 4789
ip link set vxlan10 up
ip link add br10 type bridge
ip link set br10 up
brctl addif br10 eth0
brctl addif br10 vxlan10

vtysh

configure terminal

router ospf

no network 10.0.0.0/24 area 0
network 192.168.1.8/30 area 0
network 192.168.2.0/24 area 0
network 1.1.1.0/24 area 0
exit

router bgp 65001
no bgp default ipv4-unicast
bgp router-id 1.1.1.4
neighbor 1.1.1.1 remote-as 65001
neighbor 1.1.1.1 update-source lo
address-family l2vpn evpn 
neighbor 1.1.1.1 activate
advertise-all-vni
exit
exit
exit