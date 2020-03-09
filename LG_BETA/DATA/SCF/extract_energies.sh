#!/bin/bash


#Q, 2Q, P, PQ directories
dir="2Q_unstrained/2Q_unstrained"
filin="rscf.out"
filout="../ENERGIES/energies_2Q_unstrained.txt"

if [ -f $filout ]
then
	rm $filout
fi

for ((i=0; i<=40; i++))
do
	E=$(grep "!    total energy" ${dir}_${i}/${filin} | tail -n2 | head -n1 | awk '{print $5}')
	echo $i $E >> $filout
done

#chem pot directories
#dir="chem_pot/CP_PQ_29_e"
#filout="../ENERGIES/chem_pot_PQ_29.txt"
#
#nelect_min=0.0
#nelect_max=1.0
#nsteps=10
#
#if [ -f $filout ]
#then
#	rm $filout
#fi
#
#dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
#for ((i=0; i<=nsteps; i++))
#do
#
#        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)
#        E=$(grep "!    total energy" ${dir}_${nelect}/scf.out | tail -n1 | awk '{print $5}')
#	echo $nelect $E >> $filout
#done


































































