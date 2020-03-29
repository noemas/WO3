#!/bin/bash

prefix="P2Q_P421c_2_unstrained_doped"
nelect=0.6

#dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/$prefix/$prefix"
#dirdown="./$prefix/$prefix"
#fil="rscf.out"
#
#for ((i=0;i<=20;i++))
#do
#	scp -r ${dirup}_${i}/${fil} ${dirdown}_${i}
#done

#doped
dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/$prefix/e_$nelect"
dirdown="./$prefix/e_$nelect"
fil="scf.out"

for ((i=0;i<=20;i++))
do
        scp -r ${dirup}/${i}/${fil} ${dirdown}/${i}
done


#dirup="/cluster/scratch/mnoe/chem_pot/CP_Q_0_e_"
#dirdown="chem_pot/CP_Q_0_e_"
#
#nelect_min=0.0
#nelect_max=1.0
#nsteps=80
#
#dnelect=$(echo "scale=4; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
#
#for ((i=0; i<=nsteps; i++))
#do
#        nelect=$(echo "scale=4; $nelect_min + $i*$dnelect" | bc -l)
#	fil="${dirup}${nelect}/scf.out"
#	scp mnoe@euler.ethz.ch:$fil ${dirdown}${nelect}
#done
