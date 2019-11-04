       #!/bin/bash
       #BSUB -n 64
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o SCF/Q26_chem_pot_e_.05.o
       #BSUB -e SCF/Q26_chem_pot_e_.05.e
       #BSUB -J SCF/Q26_chem_pot_e_.05

        mpirun pw.x -npool 64 -in scf.in > scf.out
