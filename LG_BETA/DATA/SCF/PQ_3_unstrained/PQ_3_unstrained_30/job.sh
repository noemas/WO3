        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o PQ_3_unstrained/PQ_3_unstrained_30.o
        #BSUB -e PQ_3_unstrained/PQ_3_unstrained_30.e
        #BSUB -J PQ_3_unstrained/PQ_3_unstrained_30

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
        rm -r *.save

