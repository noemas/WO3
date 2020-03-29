#!/bin/bash
#BSUB -n 40
#BSUB -R "rusage[mem=3072]"
#BSUB -W 8:00
#BSUB -o %.o
#BSUB -e %.e
#BSUB -J PQ_6_unstrained/PQ_6_unstrained_16

mpirun pw.x -npool 40 -in rscf.in > rscf.out
rm -r *.save
