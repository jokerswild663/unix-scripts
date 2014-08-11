#!/bin/bash

ifconfig wlan0 | \
grep 'inet addr' | \
awk {'split($2,address,":"); print address[2]'}