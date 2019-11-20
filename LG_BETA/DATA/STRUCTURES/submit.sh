#!/bin/bash

for ((i=0;i<=40;i++))
do
	cd P_unstrained_${i}
	bsub<job.sh
	cd ..
done
