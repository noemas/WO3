#bin/bash

nmod=48

for ((i=0;i<nmod;i++))
do
        echo $i
	vasp_findsym.sh --in=mode.vasp${i} --tol=1e-4
        echo "_____________________________________"
done
