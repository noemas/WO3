       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o SCF/2Q13_chem_pot_e_0.o
       #BSUB -e SCF/2Q13_chem_pot_e_0.e
       #BSUB -J SCF/2Q13_chem_pot_e_0

       mpirun pw.x -npool 40 -in scf.in > scf.out
