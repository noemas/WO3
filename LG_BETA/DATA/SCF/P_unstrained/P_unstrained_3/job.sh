        #!/bin/bash
        #BSUB -n 64
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o P_unstrained/P_unstrained_3.o
        #BSUB -e P_unstrained/P_unstrained_3.e
        #BSUB -J P_unstrained/P_unstrained_3

        mpirun pw.x -npool 64 -in rscf.in > rscf.out
