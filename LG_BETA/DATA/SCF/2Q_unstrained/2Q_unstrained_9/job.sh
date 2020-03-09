        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o 2Q_unstrained/2Q_unstrained_9.o
        #BSUB -e 2Q_unstrained/2Q_unstrained_9.e
        #BSUB -J 2Q_unstrained/2Q_unstrained_9

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
