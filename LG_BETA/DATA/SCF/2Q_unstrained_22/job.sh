        #!/bin/bash
        #BSUB -n 32
        #BSUB -R "rusage[mem=3096]"
        #BSUB -W 8:00
        #BSUB -o 2Q_unstrained_22.o
        #BSUB -e 2Q_unstrained_22.e
        #BSUB -J 2Q_unstrained_22

        mpirun pw.x -npool 32 -in rscf.in > rscf.out
