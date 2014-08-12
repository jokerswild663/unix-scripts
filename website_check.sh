#!/bin/bash
Email=""
Website=""
Timeout=200


while getopts :s:e:t: opt; do
case $opt in
	s) Website="${OPTARG}" ;;
    e) Email="${OPTARG}" ;;
    t) Timeout="${OPTARG}" ;;
esac
done

Result=`fping -t $Timeout $Website | awk {'print $3'}`

if [ $Result == 'unreachable' ]; then
	echo "$Website is not reachable" | mail -s "Error: site unreachable" $Email
else
	echo "Website reachable"
fi
