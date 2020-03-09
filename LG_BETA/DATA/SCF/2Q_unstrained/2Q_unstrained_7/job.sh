        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o 2Q_unstrained/2Q_unstrained_7.o
        #BSUB -e 2Q_unstrained/2Q_unstrained_7.e
        #BSUB -J 2Q_unstrained/2Q_unstrained_7

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
