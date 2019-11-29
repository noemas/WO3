       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o P_unstrained_doped_unstrained/P_unstrained_doped_unstrained_e_0.18_7.o
       #BSUB -e P_unstrained_doped_unstrained/P_unstrained_doped_unstrained_e_0.18_7.e
       #BSUB -J P_unstrained_doped_unstrained/P_unstrained_doped_unstrained_e_0.18_7


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
