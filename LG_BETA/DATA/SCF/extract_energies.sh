#!/bin/bash


#prefix="P2Q_P421c_2_unstrained"
#
#dir="$prefix/$prefix"
#filin="rscf.out"
#filout="../ENERGIES/energies_$prefix.txt"
#
#if [ -f $filout ]
#then
#	rm $filout
#fi
#
#for ((i=0; i<=20; i++))
#do
#	E=$(grep "!    total energy" ${dir}_${i}/${filin} | tail -n2 | head -n1 | awk '{print $5}')
#	echo $i $E
#	echo $i $E >> $filout
#done


prefix="P2Q_P421c_unstrained_doped"
nelect=0.6

dir="$prefix/e_$nelect"
filin="scf.out"
filout="../ENERGIES/energies_${prefix}_e_$nelect.txt"

if [ -f $filout ]
then
        rm $filout
fi

for ((i=0; i<=20; i++))
do
        E=$(grep "!    total energy" ${dir}/${i}/${filin} | tail -n2 | head -n1 | awk '{print $5}')
        echo $i $E	
        echo $i $E >> $filout
done

#dirdown="chem_pot/CP_Q_0_e_"
#filout="../ENERGIES/energies_chem_pot_P4ncc.txt"
#
#nelect_min=0.0
#nelect_max=1.0
#nsteps=80
#
#if [ -f $filout ]
#then
#        rm $filout
#fi
#
#dnelect=$(echo "scale=4; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
#
#for ((i=0; i<=nsteps; i++))
#do
#        nelect=$(echo "scale=4; $nelect_min + $i*$dnelect" | bc -l)
#        fil="${dirdown}${nelect}/scf.out"
#	E=$(grep "!    total energy" ${fil} | tail -n2 | head -n1 | awk '{print $5}')
#	echo $i $E >> $filout
#done

