#!/bin/bash


dir="P_unstrained_doped_unstrained/P_unstrained_doped_unstrained_e_0.18"
filin="scf.out"
filout="../ENERGIES/temp.txt"

if [ -f $filout ]
then
	rm $filout
fi

for ((i=0; i<=40; i++))
do
	E=$(grep "!    total energy" ${dir}_${i}/${filin} | tail -n1 | awk '{print $5}')
	echo $i $E >> $filout
done





































































