# Overview
The **BGP Project** from the 42 cursus focuses on autonomous systems, where I explore and grasp new concepts in packet forwarding and routing protocols such as **RIP, IS-IS, OSPF, and BGP**.  

The project is divided into three parts:  

### Part 1: Environment Setup  
- Install **Docker** and **GNS3**.  
- Create two Docker images to simulate a **host machine** and a **router device**.  

### Part 2: VXLAN Topology  
- Set up a **VXLAN topology** by creating a **VXLAN tunnel** between two **VTEP routers**.  

### Part 3: BGP with EVPN  
- Discover **BGP (Border Gateway Protocol)** and integrate it with **EVPN (Ethernet VPN)**.  

---

# Part 1: Environment Setup  
In the `p1` folder, you will find installation and uninstallation scripts for both **Docker** and **GNS3**.  
I recommend running the **GNS3 installation commands one by one** in the terminal so you can interact with the GNS3 GUI and configure it as needed.  

**Note**: The installation script I provide is for Linux/Ubuntu OS. You can refer to the official website for instructions on other operating systems.
   -   https://docs.gns3.com/docs/
   -   https://docs.docker.com/engine/install/
   
### Docker Images  
The project includes two **Docker images**:  
1. **Host Image**: Based on `linux/alpine` with pre-installed `busybox`.  
2. **Router Image**: Based on `linux/alpine` with `Quagga` installed and configured.  

### Importing Images into GNS3  
To use these images as **host** and **router**, follow these steps:  

1. **Build both Docker images** using their respective `Dockerfile`.  
2. Open **GNS3 GUI** and navigate to:  
   - **Edit → Preferences → Docker Containers**.  
3. Click **New** :  
   - Select the **host image** you built.  
   - Assign a name to your host.  
   - Set the number of ethernet interface
   - Set "sh" as start command
   - For the **router image** set start command "sh /launch_services.sh"
   - click finish and apply.

# Part 2

   Here you will use docker container to setup you VXLAN topology, i will share with you my topology and the process
of configuation of each device.
  
The Topology:
![VXLAN Topology](./image/vxlan_topology.png)


 If this is your first time using GNS3, you can try those tutorials from GNS3 to get familiar with the workflow.
 
-   https://docs.gns3.com/docs/using-gns3/beginners/the-gns3-gui
-   https://docs.gns3.com/docs/getting-started/your-first-gns3-topology
-   https://docs.gns3.com/docs/getting-started/your-first-cisco-topology

## setup of host and router
   First, we will configure our host and router devices **without** setting up the VXLAN tunnel between routers. Then, we will check connectivity between hosts by pinging their IP addresses. After that, we will set up a VXLAN tunnel between **router-tel-bouh-1 (VTEP1)** and **router-tel-bouh-2 (VTEP2)**.

### Host configuration
   For each host, we will assign an IP address to the Ethernet interface eth0. This can be done in two ways:
   -   Editing the config file – Right-click on the host, select Edit config, and assign the IPs.
    (This method preserves the configuration on Ethernet interfaces even if you close the project and return later.)
   -   Using the command-line interface (CLI) – Right-click on the host and select Console.

   We will use the second approach. However, if you choose the first approach, here is an example of the configuration in the config file. Don't forget to restart the router/host after saving the configuration.
   
   ##### Static config for eth0
	auto eth0
	iface eth0 inet static
	address 192.168.2.2
	netmask 255.255.255.0
	gateway 192.168.2.1
	up echo nameserver 192.168.2.1 > /etc/resolv.conf
   
##### On host-tel-bouh-1 host:
   - ip addr show eth0 : Display eth0 interface
   - ip addr add 192.168.2.2/24 dev eth0 : Set IP address 192.168.2.2 mask 255.255.255.0 to inetface eth0
   - ip route add default via 192.168.2.1 dev eth0 : Set default route (gateway)
   - ip route : Display routes
   
  The same process will be repeated on all host machines. You can use the IPs from the topology or set your own IP subnetting.
  
#### On router device router-tel-bouh-1
   - ip addr add 192.168.2.1/24 dev eth0
   - ip adde add 192.168.1.2/24 dev eth1
   - ip route add default via 192.168.1.1 dev eth1
   
   Again, repeat the same process on the second router.
   
   To check connectivity between hosts, you will need to remove the link between the routers and Switch 1 and instead add a direct link between their eth1 interfaces.
   
   As you know, a switch cannot perform IP routing; it operates at Layer 2 and only works with MAC addresses. We will restore the link after successfully pinging all hosts and validating connectivity.
   
   To check connectivity between hosts, use the ping utility:   **ping IP-Address**
   
   Once you have verified the connection between all hosts, you can reconnect the routers to the switch and proceed with setting up the VXLAN tunnel between Router 1 and Router 2.

If you try to ping host-tel-bouh-4 from host-tel-bouh-1, the request will not reach its destination. Why?
To answer this question, you need to understand how a switch operates. A switch forwards packets based on **MAC addresses** of directly connected devices; it does not perform **IP forwarding**.

When a packet from host-tel-bouh-1 reaches Switch 1, the switch does not know how to forward it to host-tel-bouh-4 because the hosts are in different Layer 2 networks. To allow communication, we create a **VXLAN tunnel** between the two routers.
How VXLAN Works in This Context

VXLAN encapsulates the original packet inside another VXLAN header, which includes a destination IP address (the remote VTEP, or VXLAN Tunnel Endpoint). 
VXLAN encapsulates the original packet inside another VXLAN header, which includes a source IP address (the local VTEP) and a destination IP address (the remote VTEP, or VXLAN Tunnel Endpoint).

To simplify:

-	On router-tel-bouh-1, the VXLAN interface encapsulates the packet by adding its own IP address as the source and the IP address of the VXLAN interface on router-tel-bouh-2 as the destination.
-	When the packet reaches Switch 1, the switch does not understand VXLAN; it simply sees an outer IP packet.
-	The switch will perform an ARP request to find the MAC address corresponding to the destination IP address (the remote VTEP's IP).
-	Once the switch receives an ARP reply, it forwards the encapsulated VXLAN packet based on the outer MAC address.
-	When the packet reaches router-tel-bouh-2, the VXLAN interface decapsulates it, removing the VXLAN header, and the original packet continues its normal route to the destination.

Packet Flow with VXLAN:

-	The packet from host-tel-bouh-1 reaches Router 1.
-	Router 1’s bridge forwards the packet to the VXLAN interface.
-	The VXLAN interface encapsulates the packet, adding an outer MAC header and an IP header (with the remote VTEP’s IP address).
-	The encapsulated packet is then sent via eth1 to Switch 1, which forwards it based on the MAC address.
-	When the packet reaches Router 2, its VXLAN interface decapsulates it, removing the outer headers.
-	The original packet is then forwarded as a normal Layer 2 frame to host-tel-bouh-4.


### Setting up vxlan10 interface and bridge on both routers

**On router-tel-bouh-1**
-	ip link add vxlan10 type vxlan id 10 dev eth1 local 192.168.1.2 remote 192.168.1.1 dstport 4789
-	ip addr add 192.168.10.2/24 dev vxlan10
-	ip link add br10 type bridge
-	ip link set vxlan10 up
-	ip link set br10 up

The same process on **router-tel-bouh-2** with its own IP addresses.

Now you can ping host-tel-bouh-4 from host-tel-bouh-1 to check connectivity

#### Static routing 

Before we dive into vxlan dynamic multicast we will first do a simple lab on static routing and dynamic routing to understand it then we will complete the rest of this part, below is the topology that we will use:

![VXLAN Topology](./image/static_routing_01.png)

In our router no default gateway is set , so if we try to ping host H1 (host-tel-bouh-1) from host H5 , **ping 192.168.2.2**  the packet will be forwared to the gateway on router R3 (router-tel-bouh-3) , when the packet reach that router a routing table match will occur but no mutch will found, packet network address is 192.168.2.0/24 and network IP address on interface eth1 is 192.168.5.0/24 so packet will droped by the router, if a gateway set in the router 192.168.5.1 the router will forward this packet to router R2, on router R2 will also do a packet network IP addrees match with routing table, and no match will found and the packet will forwarded to default gateway , let assum the eth1 on router R1 , then when packet reach R1 and match to routing table will happen and packet will be sent to host H1, but what if gateway is eth1 interface on R3 router then packet will not reach its destination, in our topology gateway can work fine on R1 and R3 but not on R2, alse we can not define more than one gatewat on a router, so in this lab we will not use default gateway rather we will use static, default gateway till the router where to forward packet when no match found static, static route help to match packet network IP address, so we will add static routes on the three routers R1, R2, and R3. 


Now will configure static routes on each router in our topology without setting default gateway

For router **router-tel-bouh-1**


	ip route # dispay routes
	
 	ip route add 192.168.3.0/24 dev eth1 # add now route
	
 	ip route add 192.168.5.0/24 dev eth1
	
 	ip route add 192.168.4.0/24 dev eth1
	
 	ip route # show now configuration


What we do is simply tell the router if you get an IP address belong to one of those networks just forward them over eth1 interface.

For router **router-tel-bouh-2**

	
 	ip route add 192.168.2.0/24 dev eth1
	
 	ip route add 192.168.4.0/24 dev eth2
