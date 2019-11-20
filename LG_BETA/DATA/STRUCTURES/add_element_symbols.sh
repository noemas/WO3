#!/bin/bash
#add element symbols as required for Q-E

nat=16

if [ $nat -eq 32 ]
then
for file in $(ls *.vasp)
do
	echo $file
	for ((i=0;i<8;i++))
	do
		line=$((9+i))
		sed -i "${line}s/.*/W\ &/" $file
	done
	
	for ((i=0; i<24; i++))
	do
		line=$((17+i))
                sed -i "${line}s/.*/O\ &/" $file
	done
done

elif [ $nat -eq 16 ]
then
for file in $(ls *.vasp)
do
        echo $file
        for ((i=0;i<4;i++))
        do
                line=$((9+i))
                sed -i "${line}s/.*/W\ &/" $file
        done

        for ((i=0; i<12; i++))
        do
                line=$((13+i))
                sed -i "${line}s/.*/O\ &/" $file
        done
done
fi
