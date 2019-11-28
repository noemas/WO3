#!/bin/bash

#script to generate Quantum Espresso input files for the following calculations:
#1 -increasing but fixed Q in one direction and relaxed lattice (Q unstrained)
#2 -increasing but fixed Q in two directions and relaxed lattice (2Q unstrained) 
#3 -increasing but fixed Q in one direction and additional electrons using relaxed lattice from #1 (Q unstrained doped)
#4 -increasing but fixed Q in one direction and additional electrons using relaxed lattice from #1 
#    and interpolating charged lattice relaxation from NaWO3 (Q unstrained doped unstrained)
#5 -some fixed Q and large amount of electrons/holes to calculate chemical potential using relaxed lattice from #1 (chem pot)
#6 -some fixed Q in two directions and large amount of electrons/holes to calculate chemical potential using relaxed lattice from #2 (chem pot 2Q)
#7 -increasing but fixed Q in two directions and additional electrons using relaxed lattice from #2 (2Q unstrained doped)
#8 -increasing but fixed P in one direction and relaxed lattice (P unstrained)
#9 -increasing but fixed P in one and Q in one direction and relaxed lattice (PQ unstrained)
#10 -increasing but fixed P in one direction and additional electrons using relaxed lattice from #8 (P unstrained doped)
#11 -increasing but fixed P in one direction and additional electrons using relaxed lattice from #8 
#    and interpolating charged lattice relaxation from NaWO3 (P unstrained doped unstrained)
#12 -increasing but fixed P in one and Q in one direction and relaxed lattice and additional electrons using relaxe lattice from #9 (PQ unstrained doped)


num_of_atoms=32

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!the lattice vectors are permuted!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#lattice when using 32 atoms
hisym_lat_a_32="        7.3236460686         0.0000000000         0.0000000000"
hisym_lat_b_32="        0.0000000000         7.7495899200         0.0000000000"
hisym_lat_c_32="        0.0000000000         0.0000000000         7.3236460686"

#lattice when using 16 atoms
hisym_lat_a_16="        5.177959919             0.0             0.0"
hisym_lat_b_16="        0.0             5.177959919             0.0"
hisym_lat_c_16="        0.0             0.0            7.7496299744"

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!the lattice vectors are permuted!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


#how lattices change upon doping in NaWO3 P4nmm structure 
lat_ab_m_P4nmm=0.07407987350000012
lat_c_m_P4nmm=-0.016145953999999962

#how lattices change upon doping in NaWO3 P4ncc structre
lat_ab_m_P4ncc=0.11575900200000011
lat_c_m_P4ncc=-0.0496028785

#how lattices change upon doping in NaWO3 Pbcn structre
lat_a_m_Pbcn=0
lat_b_m_Pbcn=0
lat_c_m_Pbcm=0

#index of P at which we have bulk P4nmm structure beginning from P4ncc structure
P_P4nmm=29

#index of Q at which we have Pbcn structure beginning from P4ncc structure
Q_Pbcn=29

#number of electrons per unit cell for Q unstrained doped calculations
nelect=1.0

#number of electron window for chem pot calculations
nelect_min=0.0
nelect_max=0.2
nsteps=4
#index of Q amplitude for which chem pot is determined
Q_index=13

script_start=12
script_end=12

#_____________________________________________________#
P_ab_m_m=$(echo "($lat_ab_m_P4nmm - $lat_ab_m_P4ncc)/$P_P4nmm" | bc -l)
P_c_m_m=$(echo "($lat_c_m_P4nmm - $lat_c_m_P4ncc)/$P_P4nmm" | bc -l)

Q_a_m_m=$(echo "($lat_a_m_Pbcn - $lat_ab_m_P4ncc)/$Q_Pbcn" | bc -l)
Q_b_m_m=$(echo "($lat_b_m_Pbcn - $lat_ab_m_P4ncc)/$Q_Pbcn" | bc -l)
Q_c_m_m=$(echo "($lat_c_m_Pbcn - $lat_c_m_P4ncc)/$Q_Pbcn" | bc -l)

hisym_lat_a=0
hisym_lat_b=0
hisym_lat_c=0


if [ $num_of_atoms -eq 16 ]
then
	hisym_lat_a=$hisym_lat_a_16
	hisym_lat_b=$hisym_lat_b_16
	hisym_lat_c=$hisym_lat_c_16
elif [ $num_of_atoms -eq 32 ]
then
        hisym_lat_a=$hisym_lat_a_32
        hisym_lat_b=$hisym_lat_b_32
        hisym_lat_c=$hisym_lat_c_32
fi




#_____________________Q UNSTRAINED_____________________#
if ((script_start <= 1 && script_end >= 1))
then
for ((i=0; i<=40; i++))
do
	dir="Q_unstrained/Q_unstrained_${i}"
	echo $dir
	#make directory
	if [ ! -d $dir ]
	then
		mkdir $dir
	fi
	rm $dir/rscf.in
	#make an rscf file for every structure
	cat > $dir/rscf.in << EOF

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
	cat >> $dir/rscf.in << EOF
CELL_PARAMETERS angstrom
$hisym_lat_a
$hisym_lat_b
$hisym_lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

	#append the atomic positions to the rscf file and fix them
	echo "" >> $dir/rscf.in
	echo "ATOMIC_POSITIONS crystal" >> $dir/rscf.in
	line=$(grep -n Direct ../STRUCTURES/Q_${i}.vasp | cut -d : -f 1)

	for ((j=0; j<num_of_atoms; j++))
	do
		line=$((line+1))
		atom_pos=$(sed "${line}q;d" ../STRUCTURES/Q_${i}.vasp)
		echo "$atom_pos 0 0 0" >> $dir/rscf.in
	done


	#append the k points to the rscf file
	echo "" >> $dir/rscf.in
	echo "K_POINTS automatic" >> $dir/rscf.in 
	echo "6 6 6 0 0 0" >> $dir/rscf.in



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

        mpirun pw.x -npool 64 -in rscf.in > rscf.out
EOF

done
fi


#_____________________2Q UNSTRAINED_____________________#
if ((script_start <= 2 && script_end >= 2))
then
for ((i=0; i<=40; i++))
do
        dir="2Q_unstrained/2Q_unstrained_${i}"
	echo $dir
        #make directory
        if [ ! -d $dir ]
        then
                mkdir $dir
        fi
        rm $dir/rscf.in
        #make an rscf file for every structure
        cat > $dir/rscf.in << EOF

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
        cat >> $dir/rscf.in << EOF
CELL_PARAMETERS angstrom
$hisym_lat_a
$hisym_lat_b
$hisym_lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

        #append the atomic positions to the rscf file and fix them
        echo "" >> $dir/rscf.in
        echo "ATOMIC_POSITIONS crystal" >> $dir/rscf.in
        line=$(grep -n Direct ../STRUCTURES/2Q_${i}.vasp | cut -d : -f 1)

        for ((j=0; j<num_of_atoms; j++))
        do
                line=$((line+1))
                atom_pos=$(sed "${line}q;d" ../STRUCTURES/2Q_${i}.vasp)
                echo "$atom_pos 0 0 0" >> $dir/rscf.in
        done


        #append the k points to the rscf file
        echo "" >> $dir/rscf.in
        echo "K_POINTS automatic" >> $dir/rscf.in
        echo "6 6 6 0 0 0" >> $dir/rscf.in



        #make the job file
        rm $dir/job.sh
        cat > $dir/job.sh << EOF
        #!/bin/bash
        #BSUB -n 32
        #BSUB -R "rusage[mem=3096]"
        #BSUB -W 8:00
        #BSUB -o $dir.o
        #BSUB -e $dir.e
        #BSUB -J $dir

        mpirun pw.x -npool 32 -in rscf.in > rscf.out
EOF

done
fi


#_____________________Q UNSTRAINED DOPED_____________________#

if ((script_start <= 3 && script_end >= 3))
then

for ((i=0; i<=40; i++))
do
	dir="Q_unstrained_doped/Q_unstrained_doped_e_${nelect}_${i}"
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
       dir_ref="Q_unstrained/Q_unstrained_${i}"
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
       line=$(grep -n Direct ../STRUCTURES/Q_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/Q_${i}.vasp)
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

#_____________________Q UNSTRAINED DOPED UNSTRAINED_____________________#

if ((script_start <= 4 && script_end >= 4))
then

for ((i=0; i<=40; i++))
do
	dir="Q_unstrained_doped_unstrained/Q_unstrained_doped_unstrained_e_${nelect}_${i}"
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
       dir_ref="Q_unstrained/Q_unstrained_${i}"
       lat_a=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n1 | awk '{print $1}')
       lat_b=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n2 | tail -n1 | awk '{print $2}')
       lat_c=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | tail -n1 | awk '{print $3}')

       m_a=$(echo "$lat_a_m_P4ncc + $Q_a_m_m*$i" | bc -l)
       m_b=$(echo "$lat_b_m_P4ncc + $Q_b_m_m*$i" | bc -l)
       m_c=$(echo "$lat_c_m_P4ncc + $Q_c_m_m*$i" | bc -l)
       lat_a=$(echo "$lat_a + $m_a * $nelect" | bc -l)
       lat_b=$(echo "$lat_b + $m_a * $nelect" | bc -l)
       lat_c=$(echo "$lat_c + $m_c * $nelect" | bc -l)

       cat >> $dir/scf.in << EOF
CELL_PARAMETERS angstrom
$lat_a 0 0
0 $lat_b 0
0 0 $lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

       #append the atomic positions to the scf file and fix them
       echo "" >> $dir/scf.in
       echo "ATOMIC_POSITIONS crystal" >> $dir/scf.in
       line=$(grep -n Direct ../STRUCTURES/Q_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/Q_${i}.vasp)
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
       #BSUB -W 00:40
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
EOF

done

fi


#_____________________CHEM_POT___________________#
if ((script_start <= 5 && script_end >= 5))
then
	dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
for ((i=0; i<=nsteps; i++))
do

	nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)


        dir="chem_pot/Q${Q_index}_chem_pot_e_${nelect}"
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
       dir_ref="Q_unstrained/Q_unstrained_${Q_index}"
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
       line=$(grep -n Direct ../STRUCTURES/Q_${Q_index}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/Q_${Q_index}.vasp)
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
if ((script_start <= 6 && script_end >= 6))
then
        dnelect=$(echo "scale=2; ($nelect_max-$nelect_min)/$nsteps" | bc -l)
for ((i=0; i<=nsteps; i++))
do

        nelect=$(echo "scale=2; $nelect_min + $i*$dnelect" | bc -l)


        dir="chem_pot/2Q${Q_index}_chem_pot_e_${nelect}"
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
       dir_ref="2Q_unstrained/2Q_unstrained_${Q_index}"
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
       line=$(grep -n Direct ../STRUCTURES/2Q_${Q_index}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/2Q_${Q_index}.vasp)
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

if ((script_start <= 7 && script_end >= 7))
then

for ((i=0; i<=40; i++))
do
        dir="2Q_unstrained_doped/2Q_unstrained_doped_e_${nelect}_${i}"
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
       dir_ref="2Q_unstrained/2Q_unstrained_${i}"
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
       line=$(grep -n Direct ../STRUCTURES/2Q_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/2Q_${i}.vasp)
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


#_____________________P UNSTRAINED_____________________#
if ((script_start <= 8 && script_end >= 8))
then
for ((i=0; i<=40; i++))
do
        dir="P_unstrained/P_unstrained_${i}"
	echo $dir
        #make directory
        if [ ! -d $dir ]
        then
                mkdir $dir
        fi
        rm $dir/rscf.in
        #make an rscf file for every structure
        cat > $dir/rscf.in << EOF

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
    nat         = 16
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
        cat >> $dir/rscf.in << EOF
CELL_PARAMETERS angstrom
$hisym_lat_a
$hisym_lat_b
$hisym_lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

        #append the atomic positions to the rscf file and fix them
        echo "" >> $dir/rscf.in
        echo "ATOMIC_POSITIONS crystal" >> $dir/rscf.in
        line=$(grep -n Direct ../STRUCTURES/P_${i}.vasp | cut -d : -f 1)

        for ((j=0; j<num_of_atoms; j++))
        do
                line=$((line+1))
                atom_pos=$(sed "${line}q;d" ../STRUCTURES/P_${i}.vasp)
                echo "$atom_pos 0 0 0" >> $dir/rscf.in
        done


        #append the k points to the rscf file
        echo "" >> $dir/rscf.in
        echo "K_POINTS automatic" >> $dir/rscf.in
        echo "9 9 6 0 0 0" >> $dir/rscf.in


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

        mpirun pw.x -npool 40 -in rscf.in > rscf.out
EOF

done
fi

#_____________________PQ UNSTRAINED_____________________#
if ((script_start <= 9 && script_end >= 9))
then
for ((i=0; i<=40; i++))
do
	dir="PQ_unstrained/PQ_unstrained_${i}"
        echo $dir
        #make directory
        if [ ! -d $dir ]
        then
                mkdir $dir
        fi
        rm $dir/rscf.in
        #make an rscf file for every structure
        cat > $dir/rscf.in << EOF

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
        cat >> $dir/rscf.in << EOF
CELL_PARAMETERS angstrom
$hisym_lat_a
$hisym_lat_b
$hisym_lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

        #append the atomic positions to the rscf file and fix them
        echo "" >> $dir/rscf.in
        echo "ATOMIC_POSITIONS crystal" >> $dir/rscf.in
        line=$(grep -n Direct ../STRUCTURES/PQ_${i}.vasp | cut -d : -f 1)

        for ((j=0; j<num_of_atoms; j++))
        do
                line=$((line+1))
                atom_pos=$(sed "${line}q;d" ../STRUCTURES/PQ_${i}.vasp)
                echo "$atom_pos 0 0 0" >> $dir/rscf.in
        done


        #append the k points to the rscf file
        echo "" >> $dir/rscf.in
        echo "K_POINTS automatic" >> $dir/rscf.in
        echo "6 6 6 0 0 0" >> $dir/rscf.in



        #make the job file
        rm $dir/job.sh
        cat > $dir/job.sh << EOF
        #!/bin/bash
        #BSUB -n 64
        #BSUB -R "rusage[mem=3096]"
        #BSUB -W 8:00
        #BSUB -o $dir.o
        #BSUB -e $dir.e
        #BSUB -J $dir

        mpirun pw.x -npool 64 -in rscf.in > rscf.out
EOF

done
fi

#_____________________P UNSTRAINED DOPED_____________________#

if ((script_start <= 10 && script_end >= 10))
then

for ((i=0; i<=40; i++))
do
        dir="P_unstrained_doped/P_unstrained_doped_e_${nelect}_${i}"
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
    nat         = 16
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
       dir_ref="P_unstrained/P_unstrained_${i}"
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
       line=$(grep -n Direct ../STRUCTURES/P_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/P_${i}.vasp)
               echo "$atom_pos" >> $dir/scf.in
       done


       #append the k points to the rscf file
       echo "" >> $dir/scf.in
       echo "K_POINTS automatic" >> $dir/scf.in
       echo "9 9 6 0 0 0" >> $dir/scf.in



       #make the job file
       rm $dir/job.sh
       cat > $dir/job.sh << EOF
       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir
       

        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
EOF

done

fi


#_____________________P UNSTRAINED DOPED UNSTRAINED_____________________#

if ((script_start <= 11 && script_end >= 11))
then

for ((i=0; i<=40; i++))
do
	dir="P_unstrained_doped_unstrained/P_unstrained_doped_unstrained_e_${nelect}_${i}"
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
    nat         = 16
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
       dir_ref="P_unstrained/P_unstrained_${i}"
       lat_a=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n1 | awk '{print $1}')
       lat_b=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | head -n2 | tail -n1 | awk '{print $2}')
       lat_c=$(grep CELL -A3 $dir_ref/rscf.out | tail -n3 | tail -n1 | awk '{print $3}')
 
       m_ab=$(echo "$lat_ab_m_P4ncc + $P_ab_m_m*$i" | bc -l)
       m_c=$(echo "$lat_c_m_P4ncc + $P_c_m_m*$i" | bc -l)
       lat_a=$(echo "$lat_a + $m_ab * $nelect" | bc -l)
       lat_b=$(echo "$lat_b + $m_ab * $nelect" | bc -l)
       lat_c=$(echo "$lat_c + $m_c * $nelect" | bc -l)

       cat >> $dir/scf.in << EOF
CELL_PARAMETERS angstrom
$lat_a 0 0
0 $lat_b 0
0 0 $lat_c

ATOMIC_SPECIES
W 183.84 W_ONCV_LDA-4.0.upf
O 15.9994 O_ONCV_LDA-3.0.upf
EOF

       #append the atomic positions to the scf file and fix them
       echo "" >> $dir/scf.in
       echo "ATOMIC_POSITIONS crystal" >> $dir/scf.in
       line=$(grep -n Direct ../STRUCTURES/P_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/P_${i}.vasp)
               echo "$atom_pos" >> $dir/scf.in
       done


       #append the k points to the rscf file
       echo "" >> $dir/scf.in
       echo "K_POINTS automatic" >> $dir/scf.in
       echo "9 9 6 0 0 0" >> $dir/scf.in



       #make the job file
       rm $dir/job.sh
       cat > $dir/job.sh << EOF
       #!/bin/bash
       #BSUB -n 40
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir


        mpirun pw.x -npool 40 -in scf.in > scf.out
        rm -r *.save
EOF

done

fi

#_____________________PQ UNSTRAINED DOPED_____________________#

if ((script_start <= 12 && script_end >= 12))
then

for ((i=0; i<=40; i++))
do
        dir="PQ_unstrained_doped/PQ_unstrained_doped_e_${nelect}_${i}"
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
       dir_ref="PQ_unstrained/PQ_unstrained_${i}"
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
       line=$(grep -n Direct ../STRUCTURES/PQ_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/PQ_${i}.vasp)
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
