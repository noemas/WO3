        #!/bin/bash
        #BSUB -n 64
        #BSUB -R "rusage[mem=3096]"
        #BSUB -W 8:00
        #BSUB -o PQ_unstrained/PQ_unstrained_19.o
        #BSUB -e PQ_unstrained/PQ_unstrained_19.e
        #BSUB -J PQ_unstrained/PQ_unstrained_19

        mpirun pw.x -npool 64 -in rscf.in > rscf.out
