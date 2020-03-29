        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o P_2_unstrained/P_2_unstrained_7.o
        #BSUB -e P_2_unstrained/P_2_unstrained_7.e
        #BSUB -J P_2_unstrained/P_2_unstrained_7

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
