#!/bin/bash

#script to generate Quantum Espresso input files for the following calculations:
#1 -increasing but fixed Q in one direction and relaxed lattice (Q unstrained)
#2 -increasing but fixed Q in two directions and relaxed lattice (2Q unstrained) 
#3 -increasing but fixed Q in one direction and additional electrons using relaxed lattice from #1 (Q unstrained doped)
#4 -some fixed Q and large amount of electrons/holes to calculate chemical potential using relaxed lattice from #1 (chem pot)
#5 -some fixed Q in two directions and large amount of electrons/holes to calculate chemical potential using relaxed lattice from #2 (chem pot 2Q)
#6 -increasing but fixed Q in two directions and additional electrons using relaxed lattice from #2 (2Q unstrained doped)


num_of_atoms=32

hisym_lat_a="        7.3236460686         0.0000000000         0.0000000000"
hisym_lat_b="        0.0000000000         7.7495899200         0.0000000000"
hisym_lat_c="        0.0000000000         0.0000000000         7.3236460686"

#number of electrons per unit cell for Q unstrained doped calculations
nelect=1.0

#number of electron window for chem pot calculations
nelect_min=0.0
nelect_max=0.2
nsteps=4
#index of Q amplitude for which chem pot is determined
Q_index=13

script_start=6
script_end=6
#_____________________Q UNSTRAINED_____________________#
if ((script_start <= 1 && script_end >= 1))
then
for ((i=0; i<=40; i++))
do
	echo Q_unstrained_${i}
	#make directory
	if [ ! -d Q_unstrained_${i} ]
	then
		mkdir Q_unstrained_${i}
	fi
	rm Q_unstrained_${i}/rscf.in
	#make an rscf file for every structure
	cat > Q_unstrained_${i}/rscf.in << EOF

&CONTROL
    calculation   = 'vc-relax'
    restart_mode  = 'from_scratch'
    prefix        = 'Landau_${i}'
    pseudo_dir    = '/cluster/scratch/mnoe/QE/pps'
    outdir        = './'
    forc_conv_thr = 1.0d-7
    etot_conv_thr = 1.0d-7

/
&SYSTEM
    ibrav       = 0
    nat         = 32
    ntyp        = 2
    ecutwfc     = 120
    occupations = 'smearing'
    degauss     = 7.35d-4
    tot_charge  = -0.0
/
&ELECTRONS
    conv_thr    = 1.0d-8
    diagonalization = 'david'
/


&IONS
ion_dynamics = 'bfgs'
/

&CELL
cell_dynamics = 'bfgs'
cell_dofree = 'all'
/
EOF
	
	#append the lattice constants and atomic species to the rscf file
	cat >> Q_unstrained_${i}/rscf.in << EOF
CELL_PARAMETERS angstrom
$hisym_lat_a
$hisym_lat_b
$hisym_lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

	#append the atomic positions to the rscf file and fix them
	echo "" >> Q_unstrained_${i}/rscf.in
	echo "ATOMIC_POSITIONS crystal" >> Q_unstrained_${i}/rscf.in
	line=$(grep -n Direct STRUCTURES/Q_${i}.vasp | cut -d : -f 1)

	for ((j=0; j<num_of_atoms; j++))
	do
		line=$((line+1))
		atom_pos=$(sed "${line}q;d" STRUCTURES/Q_${i}.vasp)
		echo "$atom_pos 0 0 0" >> Q_unstrained_${i}/rscf.in
	done


	#append the k points to the rscf file
	echo "" >> Q_unstrained_${i}/rscf.in
	echo "K_POINTS automatic" >> Q_unstrained_${i}/rscf.in 
	echo "6 6 6 0 0 0" >> Q_unstrained_${i}/rscf.in



        #make the job file
	rm Q_unstrained_${i}/job.sh
        cat > Q_unstrained_${i}/job.sh << EOF
        #!/bin/bash
        #BSUB -n 64
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o Q_unstrained_${i}.o
        #BSUB -e Q_unstrained_${i}.e
        #BSUB -J Q_unstrained_${i}

        mpirun pw.x -npool 64 -in rscf.in > rscf.out
EOF

done
fi


#_____________________2Q UNSTRAINED_____________________#
if ((script_start <= 2 && script_end >= 2))
then
for ((i=0; i<=40; i++))
do
        echo 2Q_unstrained_${i}
        #make directory
        if [ ! -d 2Q_unstrained_${i} ]
        then
                mkdir 2Q_unstrained_${i}
        fi
        rm 2Q_unstrained_${i}/rscf.in
        #make an rscf file for every structure
        cat > 2Q_unstrained_${i}/rscf.in << EOF

&CONTROL
    calculation   = 'vc-relax'
    restart_mode  = 'from_scratch'
    prefix        = 'Landau_${i}'
    pseudo_dir    = '/cluster/scratch/mnoe/QE/pps'
    outdir        = './'
    forc_conv_thr = 1.0d-7
    etot_conv_thr = 1.0d-7

/
&SYSTEM
    ibrav       = 0
    nat         = 32
    ntyp        = 2
    ecutwfc     = 120
    occupations = 'smearing'
    degauss     = 7.35d-4
    tot_charge  = -0.0
/
&ELECTRONS
    conv_thr    = 1.0d-8
    diagonalization = 'david'
/


&IONS
ion_dynamics = 'bfgs'
/

&CELL
cell_dynamics = 'bfgs'
cell_dofree = 'all'
/
EOF

        #append the lattice constants and atomic species to the rscf file
        cat >> 2Q_unstrained_${i}/rscf.in << EOF
CELL_PARAMETERS angstrom
$hisym_lat_a
$hisym_lat_b
$hisym_lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

        #append the atomic positions to the rscf file and fix them
        echo "" >> 2Q_unstrained_${i}/rscf.in
        echo "ATOMIC_POSITIONS crystal" >> 2Q_unstrained_${i}/rscf.in
        line=$(grep -n Direct STRUCTURES/2Q_${i}.vasp | cut -d : -f 1)

        for ((j=0; j<num_of_atoms; j++))
        do
                line=$((line+1))
                atom_pos=$(sed "${line}q;d" STRUCTURES/2Q_${i}.vasp)
                echo "$atom_pos 0 0 0" >> 2Q_unstrained_${i}/rscf.in
        done


        #append the k points to the rscf file
        echo "" >> 2Q_unstrained_${i}/rscf.in
        echo "K_POINTS automatic" >> 2Q_unstrained_${i}/rscf.in
        echo "6 6 6 0 0 0" >> 2Q_unstrained_${i}/rscf.in



        #make the job file
        rm 2Q_unstrained_${i}/job.sh
        cat > 2Q_unstrained_${i}/job.sh << EOF
        #!/bin/bash
        #BSUB -n 32
        #BSUB -R "rusage[mem=3096]"
        #BSUB -W 8:00
        #BSUB -o 2Q_unstrained_${i}.o
        #BSUB -e 2Q_unstrained_${i}.e
        #BSUB -J 2Q_unstrained_${i}

        mpirun pw.x -npool 32 -in rscf.in > rscf.out
EOF

done


fi


#_____________________Q UNSTRAINED DOPED_____________________#

if ((script_start <= 3 && script_end >= 3))
then

for ((i=0; i<=40; i++))
do
	dir="SCF/Q_unstrained_doped_e_${nelect}_${i}"
        echo $dir
        #make directory
        if [ ! -d $dir ]
        then
                mkdir $dir
        fi
        rm $dir/scf.in
        #make an rscf file for every structure
        cat > $dir/scf.in << EOF
&CONTROL
    calculation   = 'scf'
    restart_mode  = 'from_scratch'
    prefix        = 'Landau_${i}'
    pseudo_dir    = '/cluster/scratch/mnoe/QE/pps'
    outdir        = './'
/
&SYSTEM
    ibrav       = 0
    nat         = 32
    ntyp        = 2
    ecutwfc     = 120
    occupations = 'smearing'
    degauss     = 7.35d-4
    tot_charge  = -${nelect}
/
&ELECTRONS
    conv_thr    = 1.0d-8
    diagonalization = 'david'
/

EOF

       #retrieve the lattice constants and append atomic species to the scf file
       dir_ref="SCF/Q_unstrained_${i}"
       lat_a=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n1)
       lat_b=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n2 | tail -n1)
       lat_c=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | tail -n1) 
       cat >> $dir/scf.in << EOF
CELL_PARAMETERS angstrom
$lat_a
$lat_b
$lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

       #append the atomic positions to the scf file and fix them
       echo "" >> $dir/scf.in
       echo "ATOMIC_POSITIONS crystal" >> $dir/scf.in
       line=$(grep -n Direct STRUCTURES/Q_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" STRUCTURES/Q_${i}.vasp)
               echo "$atom_pos" >> $dir/scf.in
       done


       #append the k points to the rscf file
       echo "" >> $dir/scf.in
       echo "K_POINTS automatic" >> $dir/scf.in
       echo "6 6 6 0 0 0" >> $dir/scf.in



       #make the job file
       rm $dir/job.sh
       cat > $dir/job.sh << EOF
       #!/bin/bash
       #BSUB -n 64
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir
       

        mpirun pw.x -npool 64 -in scf.in > scf.out
        rm -r *.save
EOF

done

fi
#_____________________CHEM_POT___________________#
if ((script_start <= 4 && script_end >= 4))
then
	dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
for ((i=0; i<=nsteps; i++))
do

	nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)


        dir="SCF/Q${Q_index}_chem_pot_e_${nelect}"
        echo $dir
        #make directory
        if [ ! -d $dir ]
        then
                mkdir $dir
        fi
        rm $dir/scf.in
        #make an scf file for every structure
        cat > $dir/scf.in << EOF
&CONTROL
    calculation   = 'scf'
    restart_mode  = 'from_scratch'
    prefix        = 'chempot_${i}'
    pseudo_dir    = '/cluster/scratch/mnoe/QE/pps'
    outdir        = './'
/
&SYSTEM
    ibrav       = 0
    nat         = 32
    ntyp        = 2
    ecutwfc     = 120
    occupations = 'smearing'
    degauss     = 7.35d-4
    tot_charge  = -${nelect}
/
&ELECTRONS
    conv_thr    = 1.0d-8
    diagonalization = 'david'
/
EOF


       #retrieve the lattice constants and append atomic species to the scf file
       dir_ref="SCF/Q_unstrained_${Q_index}"
       lat_a=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n1)
       lat_b=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n2 | tail -n1)
       lat_c=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | tail -n1)

       cat >> $dir/scf.in << EOF
CELL_PARAMETERS angstrom
$lat_a
$lat_b
$lat_c


ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

       #append the atomic positions to the scf file
       echo "" >> $dir/scf.in
       echo "ATOMIC_POSITIONS crystal" >> $dir/scf.in
       line=$(grep -n Direct STRUCTURES/Q_${Q_index}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" STRUCTURES/Q_${Q_index}.vasp)
               echo "$atom_pos" >> $dir/scf.in
       done


       #append the k points to the rscf file
       echo "" >> $dir/scf.in
       echo "K_POINTS automatic" >> $dir/scf.in
       echo "6 6 6 0 0 0" >> $dir/scf.in

       #make the job file
       rm $dir/job.sh
       cat > $dir/job.sh << EOF
       #!/bin/bash
       #BSUB -n 64
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir

        mpirun pw.x -npool 64 -in scf.in > scf.out
EOF

done
fi

#_____________________CHEM_POT_2Q___________________#
if ((script_start <= 5 && script_end >= 5))
then
        dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
for ((i=0; i<=nsteps; i++))
do

        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)


        dir="SCF/2Q${Q_index}_chem_pot_e_${nelect}"
        echo $dir
        #make directory
        if [ ! -d $dir ]
        then
                mkdir $dir
        fi
        rm $dir/scf.in
        #make an scf file for every structure
        cat > $dir/scf.in << EOF
&CONTROL
    calculation   = 'scf'
    restart_mode  = 'from_scratch'
    prefix        = 'chempot_${i}'
    pseudo_dir    = '/cluster/scratch/mnoe/QE/pps'
    outdir        = './'
/
&SYSTEM
    ibrav       = 0
    nat         = 32
    ntyp        = 2
    ecutwfc     = 120
    occupations = 'smearing'
    degauss     = 7.35d-4
    tot_charge  = -${nelect}
/
&ELECTRONS
    conv_thr    = 1.0d-8
    diagonalization = 'david'
/
EOF


       #retrieve the lattice constants and append atomic species to the scf file
       dir_ref="SCF/2Q_unstrained_${Q_index}"
       lat_a=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n1)
       lat_b=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n2 | tail -n1)
       lat_c=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | tail -n1)

       cat >> $dir/scf.in << EOF
CELL_PARAMETERS angstrom
$lat_a
$lat_b
$lat_c


ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

       #append the atomic positions to the scf file
       echo "" >> $dir/scf.in
       echo "ATOMIC_POSITIONS crystal" >> $dir/scf.in
       line=$(grep -n Direct STRUCTURES/2Q_${Q_index}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" STRUCTURES/2Q_${Q_index}.vasp)
               echo "$atom_pos" >> $dir/scf.in
       done


       #append the k points to the rscf file
       echo "" >> $dir/scf.in
       echo "K_POINTS automatic" >> $dir/scf.in
       echo "6 6 6 0 0 0" >> $dir/scf.in

       #make the job file
       rm $dir/job.sh
       cat > $dir/job.sh << EOF
       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 8:00
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir

       mpirun pw.x -npool 40 -in scf.in > scf.out
EOF

done
fi



#_____________________2Q UNSTRAINED DOPED_____________________#

if ((script_start <= 6 && script_end >= 6))
then

for ((i=0; i<=40; i++))
do
        dir="SCF/2Q_unstrained_doped_e_${nelect}_${i}"
        echo $dir
        #make directory
        if [ ! -d $dir ]
        then
                mkdir $dir
        fi
        rm $dir/scf.in
        #make an rscf file for every structure
        cat > $dir/scf.in << EOF
&CONTROL
    calculation   = 'scf'
    restart_mode  = 'from_scratch'
    prefix        = 'Landau_${i}'
    pseudo_dir    = '/cluster/scratch/mnoe/QE/pps'
    outdir        = './'
/
&SYSTEM
    ibrav       = 0
    nat         = 32
    ntyp        = 2
    ecutwfc     = 120
    occupations = 'smearing'
    degauss     = 7.35d-4
    tot_charge  = -${nelect}
/
&ELECTRONS
    conv_thr    = 1.0d-8
    diagonalization = 'david'
/

EOF

       #retrieve the lattice constants and append atomic species to the scf file
       dir_ref="SCF/2Q_unstrained_${i}"
       lat_a=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n1)
       lat_b=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n2 | tail -n1)
       lat_c=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | tail -n1)
       cat >> $dir/scf.in << EOF
CELL_PARAMETERS angstrom
$lat_a
$lat_b
$lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

       #append the atomic positions to the scf file and fix them
       echo "" >> $dir/scf.in
       echo "ATOMIC_POSITIONS crystal" >> $dir/scf.in
       line=$(grep -n Direct STRUCTURES/2Q_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" STRUCTURES/2Q_${i}.vasp)
               echo "$atom_pos" >> $dir/scf.in
       done


       #append the k points to the rscf file
       echo "" >> $dir/scf.in
       echo "K_POINTS automatic" >> $dir/scf.in
       echo "6 6 6 0 0 0" >> $dir/scf.in



       #make the job file
       rm $dir/job.sh
       cat > $dir/job.sh << EOF
       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 02:00
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
EOF

done
fi
