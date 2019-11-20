       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o SCF/P_unstrained_doped_e_0.05_11.o
       #BSUB -e SCF/P_unstrained_doped_e_0.05_11.e
       #BSUB -J SCF/P_unstrained_doped_e_0.05_11


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
