#!/bin/bash

#check the symmetry of the P2Q structures --> space group P-421c
for ((i=0; i<=40; i++))
do
        echo $i
        vasp_findsym.sh --in=P2Q_${i}.vasp --out=test.cif --tol=1e-5
done


#check the symmetry of the 2Q structures --> space group P-421c
for ((i=0; i<=40; i++))
do
	echo $i
	vasp_findsym.sh --in=2Q_${i}.vasp --out=test.cif --tol=1e-5
done

#check the symmetry of the P structures --> space group P4ncc
for ((i=0; i<=40; i++))
do
        echo $i
        vasp_findsym.sh --in=P_${i}.vasp --out=test.cif --tol=1e-5
done

#check the symmetry of the PQ structures --> space group Pbcn
for ((i=0; i<=40; i++))
do
        echo $i
        vasp_findsym.sh --in=PQ_${i}.vasp --out=test.cif --tol=1e-5
done

