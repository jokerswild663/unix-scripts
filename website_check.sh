#!/bin/bash
Email=""
Website=""


while getopts :s:e: opt; do
case $opt in
	s) Website="${OPTARG}" ;;
    e) Email="${OPTARG}" ;;
esac
done
