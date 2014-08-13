#!/bin/bash
IpAddress=$(ifconfig wlan0 | grep 'inet addr' | awk {'split($2,address,":"); print address[2]'})  
echo "$IpAddress"

if [ `find /mnt/configFiles -iname *.conf` != '' ]; then
	sed -i "s/zillow.com/$IpAddress/g" /mnt/configFiles/*.conf
    echo "config file modified with local ip address"
    exit 0
else
	echo "file not found"
	exit 1
fi