#!/bin/bash


#Q, 2Q, P, PQ directories
dir="Q_unstrained_doped_unstrained/Q_unstrained_doped_unstrained_e_0.36"
filin="scf.out"
filout="../ENERGIES/temp1.txt"

if [ -f $filout ]
then
	rm $filout
fi

for ((i=0; i<=40; i++))
do
	E=$(grep "!    total energy" ${dir}_${i}/${filin} | tail -n1 | awk '{print $5}')
	echo $i $E >> $filout
done

#chem pot directories
#dir="chem_pot_unstrained/CPU_P_0_e"
#filout="../ENERGIES/chem_pot_unstrained_P4ncc.txt"
#
#nelect_min=0.0
#nelect_max=0.1
#nsteps=4
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


































































