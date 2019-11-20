#!/bin/bash


dir="P_unstrained"

for ((i=0;i<40;i++))
do
	scp -r mnoe@euler.ethz.ch:/cluster/scratch/mnoe/QE/LANDAU_BETA/${dir}_${i}/rscf.out ./${dir}/${dir}_${i}
done
