#!/bin/bash


dir="PQ_unstrained/PQ_unstrained"
filin="rscf.out"
filout="../ENERGIES/energies_PQ_unstrained.txt"

if [ -f $filout ]
then
	rm $filout
fi

for ((i=0; i<=40; i++))
do
	E=$(grep "!    total energy" ${dir}_${i}/${filin} | tail -n1 | awk '{print $5}')
	echo $i $E >> $filout
done





































































