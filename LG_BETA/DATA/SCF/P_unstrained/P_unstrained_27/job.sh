        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o P_unstrained_27.o
        #BSUB -e P_unstrained_27.e
        #BSUB -J P_unstrained_27

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
