#!/bin/sh


ip addr add 1.1.1.1/32 dev lo
ip addr del 127.0.0.1/8 dev lo
ip addr add 192.168.1.1/30 dev eth0
ip addr add 192.168.1.5/30 dev eth1
ip addr add 192.168.1.9/30 dev eth2



vtysh



configure terminal

router ospf

no network 10.0.0.0/24 area 0
network 192.168.1.0/30 area 0
network 192.168.1.4/30 area 0
network 192.168.1.8/30 area 0
network 1.1.1.0/24 area 0

exit

router bgp 65001
no bgp default ipv4-unicast
bgp router-id 1.1.1.1
neighbor bgpgr peer-group
neighbor bgpgr remote-as 65001
neighbor bgpgr update-source lo
no neighbor 10.0.0.2 remote-as 65002
bgp listen range 1.1.1.0/24 peer-group bgpgr
address-family l2vpn evpn 
neighbor bgpgr activate
neighbor bgpgr route-reflector-client
exit
exit
exit