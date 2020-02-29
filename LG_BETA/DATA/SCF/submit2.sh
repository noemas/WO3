#!/bin/bash


module purge
module load quantum_espresso/6.2.1


prefix="PQ_Pbcn"

#=================================================#

for ((i=0; i<=40; i++))
do
        dir="${prefix}__${i}"
        cd $dir
        #bsub<job.sh
        cd ..
done
        
#_________________________________________________#


