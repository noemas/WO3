#!/bin/bash
#BSUB -n 64
#BSUB -R "rusage[mem=3072]"
#BSUB -W 02:00


#mpirun ~/q-e/bin/pw.x -npool 64 -in bands.in > bands.out
mpirun ~/q-e/bin/pw.x -npool 64 -in scf.in > scf.out
#mpirun ~/q-e/bin/ph.x -npool 64 -in ph_0.in > ph_0.out

#mpirun pw.x -npool 64 -in scf.in > scf.out
#mpirun ph.x -npool 64 -in ph_0.in > ph_0.out
