       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 02:00
       #BSUB -o PQ_unstrained_doped/PQ_unstrained_doped_e_0.1_6.o
       #BSUB -e PQ_unstrained_doped/PQ_unstrained_doped_e_0.1_6.e
       #BSUB -J PQ_unstrained_doped/PQ_unstrained_doped_e_0.1_6


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
