        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o PQ_2_unstrained/PQ_2_unstrained_22.o
        #BSUB -e PQ_2_unstrained/PQ_2_unstrained_22.e
        #BSUB -J PQ_2_unstrained/PQ_2_unstrained_22

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
