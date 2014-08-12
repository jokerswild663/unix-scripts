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

