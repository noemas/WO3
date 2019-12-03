#!/bin/bash
#remove element symbols as required for VASP format




for file in $(ls *.vasp)
do
	echo $file
	for ((i=0;i<32;i++))
	do
		line=$((9+i))
		sed -i "${line}s/W//g" $file
                sed -i "${line}s/O//g" $file
                sed -i "${line}s/^\ *//1" $file
	done
done
