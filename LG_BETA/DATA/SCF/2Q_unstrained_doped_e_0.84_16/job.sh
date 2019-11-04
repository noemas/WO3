       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 02:00
       #BSUB -o SCF/2Q_unstrained_doped_e_0.84_16.o
       #BSUB -e SCF/2Q_unstrained_doped_e_0.84_16.e
       #BSUB -J SCF/2Q_unstrained_doped_e_0.84_16


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
