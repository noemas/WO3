       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o Q_unstrained_doped_unstrained/Q_unstrained_doped_unstrained_e_0.36_31.o
       #BSUB -e Q_unstrained_doped_unstrained/Q_unstrained_doped_unstrained_e_0.36_31.e
       #BSUB -J Q_unstrained_doped_unstrained/Q_unstrained_doped_unstrained_e_0.36_31


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
