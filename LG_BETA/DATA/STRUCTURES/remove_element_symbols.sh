#!/bin/bash
#remove element symbols as required for VASP format
for file in $(ls *.vasp)
do
	echo $file
	for ((i=0;i<8;i++))
	do
		line=$((9+i))
		sed -i "${line}s/W//1" $file
	done
	
	for ((i=0; i<24; i++))
	do
		line=$((17+i))
                sed -i "${line}s/O//1" $file
	done
done
