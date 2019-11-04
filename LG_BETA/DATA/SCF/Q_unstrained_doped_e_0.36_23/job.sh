       #!/bin/bash
       #BSUB -n 64
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o SCF/Q_unstrained_doped_e_0.36_23.o
       #BSUB -e SCF/Q_unstrained_doped_e_0.36_23.e
       #BSUB -J SCF/Q_unstrained_doped_e_0.36_23
       

        mpirun pw.x -npool 64 -in scf.in > scf.out
        rm -r *.save
