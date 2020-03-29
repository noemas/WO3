#!/bin/bash
#BSUB -n 40
#BSUB -R "rusage[mem=3072]"
#BSUB -W 2:00
#BSUB -o %J.o
#BSUB -e %J.e
#BSUB -J chem_pot/CP_Q_0_e_.0375

 mpirun pw.x -npool 40 -in scf.in > scf.out
