#!/bin/bash

dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/QE/LANDAU_BETA/PQ_unstrained_doped_e_0.05"
dirdown="./PQ_unstrained_doped/PQ_unstrained_doped_e_0.05"
fil="scf.out"

for ((i=0;i<=40;i++))
do
	scp -r ${dirup}_${i}/${fil} ${dirdown}_${i}
done
