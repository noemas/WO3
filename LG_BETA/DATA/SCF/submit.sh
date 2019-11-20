#!/bin/bash


module purge
module load quantum_espresso/6.2.1

#=================================================#
#Q unstrained doped
nelect=1

for ((i=0; i<=40; i++))
do
        dir="Q_unstrained_doped_e_${nelect}_${i}"
        cd $dir
        #bsub<job.sh
        cd ..
done
        
#_________________________________________________#




#=================================================#
#Q chem pot

#number of electron window for chem pot calculations
nelect_min=0.36
nelect_max=1
nsteps=4
#index of Q amplitude for which chem pot is determined
Q_index=26

dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
for ((i=0; i<=nsteps; i++))
do

        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)
        dir="Q${Q_index}_chem_pot_e_${nelect}"
        cd $dir
#        bsub<job.sh
        cd ..
done
#_________________________________________________#


#=================================================#
#2Q chem pot

#number of electron window for chem pot calculations
nelect_min=0.0
nelect_max=0.2
nsteps=4
#index of Q amplitude for which chem pot is determined
Q_index=13

dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
for ((i=0; i<=nsteps; i++))
do

        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)
        dir="2Q${Q_index}_chem_pot_e_${nelect}"
        cd $dir
#        bsub<job.sh
        cd ..
done
#_________________________________________________#


#=================================================#
#2Q unstrained doped
nelect=1.0

for ((i=0; i<=40; i++))
do
        dir="2Q_unstrained_doped_e_${nelect}_${i}"
        cd $dir
        bsub<job.sh
        cd ..
done

#_________________________________________________#

