       #!/bin/bash
       #BSUB -n 64
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o P_unstrained_doped/P_unstrained_doped_e_0.18_10.o
       #BSUB -e P_unstrained_doped/P_unstrained_doped_e_0.18_10.e
       #BSUB -J P_unstrained_doped/P_unstrained_doped_e_0.18_10
       

        mpirun pw.x -npool 64 -in scf.in > scf.out
        rm -r *.save
