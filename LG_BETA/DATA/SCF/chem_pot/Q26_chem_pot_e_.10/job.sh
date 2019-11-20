       #!/bin/bash
       #BSUB -n 64
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o SCF/Q26_chem_pot_e_.10.o
       #BSUB -e SCF/Q26_chem_pot_e_.10.e
       #BSUB -J SCF/Q26_chem_pot_e_.10

        mpirun pw.x -npool 64 -in scf.in > scf.out
