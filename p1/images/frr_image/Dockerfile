FROM frrouting/frr

#add vim and openrc utilities 
RUN apk add vim

RUN apk add openrc

#Remove default frr daemons file
RUN rm -rf /etc/frr/daemons

#Add new frr daemons file with ospf, isis, and bgp enabled
COPY ./config/daemons /etc/frr/daemons

#Add vtysh config file
COPY ./config/vtysh.conf /etc/frr/vtysh.conf
#Copy configuration files for services (IS-IS , BGP, OSPF)
COPY ./config/zebra.conf /etc/frr/zebra.conf
COPY ./config/ospfd.conf /etc/frr/ospfd.conf
COPY ./config/isisd.conf /etc/frr/isisd.conf
COPY ./config/bgpd.conf /etc/frr/bgpd.conf

#Add foulder for frr services logs
RUN mkdir -p /var/log/frr

#Set owner to frr
RUN chown -R frr:frr /var/log/frr

RUN chown -R frr:frr /etc/frr

RUN chown frr:frrvty /etc/frr/vtysh.conf

#Add permissions to files
RUN chmod 640 /etc/frr/*.conf

RUN chmod 660 /etc/frr/vtysh.conf

COPY ./script/start-frr.sh /usr/lib/frr/start-frr.sh

RUN chmod +x /usr/lib/frr/start-frr.sh

ENTRYPOINT ["/usr/lib/frr/start-frr.sh"]
