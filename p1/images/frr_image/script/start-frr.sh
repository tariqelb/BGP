#!/bin/sh

# Start FRR daemons in the background
/sbin/tini -- /usr/lib/frr/docker-start &

# Keep the container running
tail -f /dev/null &


#/usr/lib/frr/zebra -d -F traditional -A 127.0.0.1 -s 90000000 &
#/usr/lib/frr/bgpd -d -F traditional -A 127.0.0.1 &
#/usr/lib/frr/ospfd -d -F traditional -A 127.0.0.1 &
#/usr/lib/frr/isisd -d -F traditional -A 127.0.0.1 &
#/usr/lib/frr/staticd -d -F traditional -A 127.0.0.1 &
#tail -f /dev/null &

/bin/sh
