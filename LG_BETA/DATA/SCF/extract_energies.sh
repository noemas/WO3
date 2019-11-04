#!/bin/bash

nelect=1.0
filout="energies_2Q_unstrained_e1.txt"

rm $filout
for ((i=0; i<=40; i++))
do
        dir="2Q_unstrained_doped_e_${nelect}_${i}"
        E=$(grep "!    total energy" ${dir}/scf.out | awk '{print $5}')
        echo $i $E >> $filout
done
        

#=================================================#
#Q chem pot

##number of electron window for chem pot calculations
#nelect_min=0.36
#nelect_max=1.0
#nsteps=4
##index of Q amplitude for which chem pot is determined
#Q_index=26
#
#filout="energies_chem_pot_Q${Q_index}.txt"
#
#
#dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
#for ((i=0; i<=nsteps; i++))
#do
#
#        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)
#        dir="Q${Q_index}_chem_pot_e_${nelect}"
#        E=$(grep "!    total energy" ${dir}/scf.out | awk '{print $5}')
#        echo $nelect $E >> $filout
#done
##_________________________________________________#
#
#
##=================================================#
##2Q chem pot
#
##number of electron window for chem pot calculations
#nelect_min=0.36
#nelect_max=1.0
#nsteps=4
##index of Q amplitude for which chem pot is determined
#Q_index=13
#
#filout="energies_chem_pot_2Q${Q_index}.txt"
#
#dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
#for ((i=0; i<=nsteps; i++))
#do
#
#        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)
#        dir="2Q${Q_index}_chem_pot_e_${nelect}"
#        E=$(grep "!    total energy" ${dir}/scf.out | awk '{print $5}')
#        echo $nelect $E >> $filout
#done
##_________________________________________________#
#
#







