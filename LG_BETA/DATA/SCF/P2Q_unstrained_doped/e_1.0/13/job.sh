#!/bin/bash
#BSUB -n 40
#BSUB -R "rusage[mem=3072]"
#BSUB -W 01:00
#BSUB -o %.o
#BSUB -e %.e
#BSUB -J P2Q_unstrained_doped/e_1.0/13
#BSUB -b 00:00

mpirun pw.x -npool 40 -in scf.in > scf.out
rm -r *.save
