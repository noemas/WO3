        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o PQ_4_unstrained/PQ_4_unstrained_36.o
        #BSUB -e PQ_4_unstrained/PQ_4_unstrained_36.e
        #BSUB -J PQ_4_unstrained/PQ_4_unstrained_36

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
        rm -r *.save

