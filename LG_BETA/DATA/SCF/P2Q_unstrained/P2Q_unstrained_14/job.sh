        #!/bin/bash
        #BSUB -n 40
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o P2Q_unstrained/P2Q_unstrained_14.o
        #BSUB -e P2Q_unstrained/P2Q_unstrained_14.e
        #BSUB -J P2Q_unstrained/P2Q_unstrained_14

        mpirun pw.x -npool 40 -in rscf.in > rscf.out