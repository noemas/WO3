#!/bin/bash

line=$(grep -m1 -n disp_num single_mode.sh | cut -d : -f 1)

for ((i=1;i<=48;i++))
do
	echo $i
	sed -i "${line}s/[0-9][0-9]*/$i/1" single_mode.sh
        ./single_mode.sh
	echo "_____________________________________"
done
