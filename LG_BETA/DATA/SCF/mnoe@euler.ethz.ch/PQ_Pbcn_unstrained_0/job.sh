        #!/bin/bash
        #BSUB -n 64
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o PQ_Pbcn_unstrained/PQ_Pbcn_unstrained_0.o
        #BSUB -e PQ_Pbcn_unstrained/PQ_Pbcn_unstrained_0.e
        #BSUB -J PQ_Pbcn_unstrained/PQ_Pbcn_unstrained_0

        mpirun pw.x -npool 64 -in rscf.in > rscf.out
