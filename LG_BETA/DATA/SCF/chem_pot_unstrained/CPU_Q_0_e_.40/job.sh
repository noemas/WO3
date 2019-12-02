       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o chem_pot_unstrained/CPU_Q_0_e_.40.o
       #BSUB -e chem_pot_unstrained/CPU_Q_0_e_.40.e
       #BSUB -J chem_pot_unstrained/CPU_Q_0_e_.40

        mpirun pw.x -npool 40 -in scf.in > scf.out
