#!/bin/bash
#BSUB -n 40
#BSUB -R "rusage[mem=3072]"
#BSUB -W 01:00
#BSUB -o %.o
#BSUB -e %.e
#BSUB -J P2Q_3_unstrained_doped/e_0.2/1
#BSUB -b 02:00

mpirun pw.x -npool 40 -in scf.in > scf.out
rm -r *.save
