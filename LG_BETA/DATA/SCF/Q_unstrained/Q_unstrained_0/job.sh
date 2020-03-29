        #!/bin/bash
        #BSUB -n 12
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o Q_unstrained/Q_unstrained_0.o
        #BSUB -e Q_unstrained/Q_unstrained_0.e
        #BSUB -J Q_unstrained/Q_unstrained_0

        mpirun pw.x -npool 12 -in rscf.in > rscf.out
        rm -r *.save

