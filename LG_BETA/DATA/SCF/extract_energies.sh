#!/bin/bash


dir="PQ_unstrained_doped/PQ_unstrained_doped_e_1.0"
filin="scf.out"
filout="../ENERGIES/energies_PQ_unstrained_e100.txt"

if [ -f $filout ]
then
	rm $filout
fi

for ((i=0; i<=40; i++))
do
	E=$(grep "!    total energy" ${dir}_${i}/${filin} | tail -n1 | awk '{print $5}')
	echo $i $E >> $filout
done





































































