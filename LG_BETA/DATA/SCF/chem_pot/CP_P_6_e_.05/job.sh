       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o chem_pot/CP_P_6_e_.05.o
       #BSUB -e chem_pot/CP_P_6_e_.05.e
       #BSUB -J chem_pot/CP_P_6_e_.05

        mpirun pw.x -npool 40 -in scf.in > scf.out