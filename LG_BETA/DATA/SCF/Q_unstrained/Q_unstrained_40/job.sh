        #!/bin/bash
        #BSUB -n 64
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o Q_unstrained_40.o
        #BSUB -e Q_unstrained_40.e
        #BSUB -J Q_unstrained_40

        mpirun pw.x -npool 64 -in rscf.in > rscf.out
