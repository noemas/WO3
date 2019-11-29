#!/bin/bash

dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/QE/LANDAU_BETA/P_unstrained_doped_unstrained_e_0.18"
dirdown="./P_unstrained_doped_unstrained/P_unstrained_doped_unstrained_e_0.18"
fil="scf.out"

for ((i=0;i<=40;i++))
do
	scp -r ${dirup}_${i}/${fil} ${dirdown}_${i}
done
