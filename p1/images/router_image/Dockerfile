FROM alpine:latest

RUN apk update && apk upgrade

RUN apk add quagga

RUN apk add vim

# Create directories for Quagga configuration files
RUN mkdir -p /etc/quagga /var/log/quagga /var/run/qugga

#Copy configuration files for services (IS-IS , BGP, OSPF)
COPY ./config/zebra.conf /etc/quagga/zebra.conf
COPY ./config/ospfd.conf /etc/quagga/ospfd.conf
COPY ./config/isisd.conf /etc/quagga/isisd.conf
COPY ./config/bgpd.conf /etc/quagga/bgpd.conf

#Copy script that launch services
COPY ./script/launch_services.sh  /launch_services.sh

#Add permission to script file
RUN chmod +x /launch_services.sh

#Set owner to quagga, ensure Quagga can write to its directories
RUN chown -R quagga:quagga /etc/quagga /var/log/quagga /var/run/quagga

#Expose ports for services (IS-IS , OSPF , BGP)
EXPOSE 2605/tcp 2604/tcp 179/tcp

CMD ["sh", "-c", "/launch_services.sh"]
