#!/bin/bash

dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/P2Q_unstrained/P2Q_unstrained"
dirdown="./P2Q_unstrained/P2Q_unstrained"
fil="rscf.out"

for ((i=0;i<=40;i++))
do
	scp -r ${dirup}_${i}/${fil} ${dirdown}_${i}
done

#chem pot
#dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/QE/LANDAU_BETA/CP_PQ_29_e"
#dirdown="chem_pot/CP_PQ_29_e"
#
#nelect_min=0.0
#nelect_max=1.0
#nsteps=10
#
#dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
#for ((i=0; i<=nsteps; i++))
#do
#        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)
#	scp -r ${dirup}_${nelect}/scf.out ${dirdown}_${nelect}
#done

