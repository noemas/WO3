       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o P_unstrained_doped/P_unstrained_doped_e_0.05_5.o
       #BSUB -e P_unstrained_doped/P_unstrained_doped_e_0.05_5.e
       #BSUB -J P_unstrained_doped/P_unstrained_doped_e_0.05_5
       

        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save