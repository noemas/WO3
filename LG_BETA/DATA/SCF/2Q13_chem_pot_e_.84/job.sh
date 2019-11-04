       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o SCF/2Q13_chem_pot_e_.84.o
       #BSUB -e SCF/2Q13_chem_pot_e_.84.e
       #BSUB -J SCF/2Q13_chem_pot_e_.84

       mpirun pw.x -npool 40 -in scf.in > scf.out