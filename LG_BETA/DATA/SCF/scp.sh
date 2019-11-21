#!/bin/bash

dirup="mnoe@euler.ethz.ch:/cluster/scratch/mnoe/QE/LANDAU_BETA/PQ_unstrained"
dirdown="./PQ_unstrained/PQ_unstrained"
fil="rscf.out"

for ((i=0;i<=40;i++))
do
	scp -r ${dirup}_${i}/${fil} ${dirdown}_${i}
done
