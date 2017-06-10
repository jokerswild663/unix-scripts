#!/bin/bash

## colors
ERROR="\e[31m"
WARNING="\e[33m"
SUCCESS="\e[32m"
DATA="\e[34m"
NC="\e[39m"

## methods
usage() {
	printf "${WARNING}This script is used for checking modes and positions
args:
${SUCCESS}--help:${NC} ${WARNING}displays this help screen${NC}
${SUCCESS}--search=${DATA}<desired search parameter>${NC}: ${WARNING}desired search type for file${NC} (phone, address, zipcode)
${SUCCESS}--file=${DATA}<filepath>${NC}: ${WARNING}path to file to read${NC} (absolute or relative path)
\n"
exit 1
}

file() {
	## check that file exists
	if [[ ! -e $1 ]]; then
		printf "${ERROR}file does not exist${NC}\n"
		exit 1
	fi

	## check file is readable
	if [[ ! -r $1 ]]; then
		printf "${ERROR}file is not readable${NC}\n"
		exit 1
	fi
	printf "${SUCCESS}Parsing file:${DATA} $(readlink -f $1)${NC}\n"
}

patternlist() {
	printf "${ERROR}Patterns to search:${NC}
${WARNING}*zipcode
*address
*phone
${NC}
"
}

zipcode() {
	grep --color=auto -inE "(^|\s)[0-9]{5}(\>)" $1
	if [[ $? -ne 0 ]]; then
		printf "${ERROR}no zipcodes found in file: ${WARNING}$1${NC}\n"
		exit 1
	else
		exit 0
	fi
}

phone() {
	grep --color=auto -inE "(^|\s)([0-9]{10})|([0-9]{3}\W[0-9]{3})\W[0-9]{4}" $1
	if [[ $? -ne 0 ]]; then
		printf "${ERROR}no phone numbers found in file: ${WARNING}$1${NC}\n"
		exit 1
	else
		exit 0
	fi
}

address() {
	grep --color=auto -inE "(^|\s)(([0-9]*\s[a-z]{1,2})(\s(\w*)){2})" $1
	if [[ $? -ne 0 ]]; then
		printf "${ERROR}no addresses found in file: ${WARNING}$1${NC}\n"
		exit 1
	else
		exit 0
	fi
}

search() {
	case "$1" in
		zipcode)
			printf "${WARNING}searching for zipcodes...${NC}\n"
			zipcode $2 
			;;
		address)
			printf "${WARNING}searching for addresses...${NC}\n"
			address $2
			;;
		phone)
			printf "${WARNING}searching for phone numbers...${NC}\n"
			phone $2
			;;
		*)
			printf "${ERROR}ERROR: invalid pattern selected${NC}\n"
			patternlist
			exit 1
			;;
	esac
}

if [[ $# -eq 0 ]]; then
	usage
fi

for i in "$@"; do
	case $i in
		-h|--help)
			usage
			break
			;;
		--search=*)
			SEARCH=${i#*=}
			shift
			;;
		--file=*)
			FILE=${i#*=}
			shift
			;;
	esac
done

if [[ -n $FILE ]]; then
	file $FILE
fi

if [[ -n $SEARCH ]]; then
	search $SEARCH $FILE
fi
