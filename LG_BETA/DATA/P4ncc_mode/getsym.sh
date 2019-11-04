#bin/bash

nmod=48

for ((i=0;i<nmod;i++))
do
        echo $i
	vasp_findsym.sh --in=mode.vasp${i} --tol=1e-2
        echo "_____________________________________"
done
