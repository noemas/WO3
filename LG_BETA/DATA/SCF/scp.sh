#!/bin/bash

#dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/QE/LANDAU_BETA/Q_unstrained_doped_unstrained_e_0.36"
#dirdown="./Q_unstrained_doped_unstrained/Q_unstrained_doped_unstrained_e_0.36"
#fil="scf.out"
#
#for ((i=0;i<=40;i++))
#do
#	scp -r ${dirup}_${i}/${fil} ${dirdown}_${i}
#done

#chem pot
dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/QE/LANDAU_BETA/CP_Q_29_e"
dirdown="chem_pot/CP_Q_29_e"

nelect_min=0.0
nelect_max=1.0
nsteps=10

dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
for ((i=0; i<=nsteps; i++))
do
        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)
	scp -r ${dirup}_${nelect}/scf.out ${dirdown}_${nelect}
done

