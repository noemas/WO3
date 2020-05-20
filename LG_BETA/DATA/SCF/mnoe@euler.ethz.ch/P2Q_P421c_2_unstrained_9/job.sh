#!/bin/bash
#BSUB -n 40
#BSUB -R "rusage[mem=3072]"
#BSUB -W 8:00
#BSUB -o %J.o
#BSUB -e %J.e
#BSUB -J P2Q_P421c_2_unstrained/P2Q_P421c_2_unstrained_9
#BSUB -b 00:00

mpirun pw.x -npool 40 -in rscf.in > rscf.out
rm -r *.save