#!/bin/bash
#BSUB -n 40
#BSUB -R "rusage[mem=3072]"
#BSUB -W 8:00
#BSUB -o %J.o
#BSUB -e %J.e
#BSUB -J PQ_8_unstrained/PQ_8_unstrained_38
#BSUB -b 03:00

mpirun pw.x -npool 40 -in rscf.in > rscf.out
rm -r *.save
