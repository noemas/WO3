       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 02:00
       #BSUB -o SCF/2Q_unstrained_doped_e_0.20_1.o
       #BSUB -e SCF/2Q_unstrained_doped_e_0.20_1.e
       #BSUB -J SCF/2Q_unstrained_doped_e_0.20_1


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
