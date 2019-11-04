#!/bin/bash

#check the symmetry of the 2Q structures --> space group P-42_1c
for ((i=0; i<=40; i++))
do
	echo $i
	vasp_findsym.sh --in=2Q_${i}.vasp --out=test.cif --tol=1e-5
done
