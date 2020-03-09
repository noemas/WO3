#!/bin/bash

num_of_atoms=32

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!the lattice vectors are permuted!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#lattice when using 32 atoms (P4ncc in permuted Pbcn setting)
#used for Q, 2Q and PQ calculations
hisym_lat_a_32="        7.3236460686         0.0000000000         0.0000000000"
hisym_lat_b_32="        0.0000000000         7.7495899200         0.0000000000"
hisym_lat_c_32="        0.0000000000         0.0000000000         7.3236460686"

#lattice when using 16 atoms (P4ncc)
#used for P calculations
hisym_lat_a_16="        5.177959919             0.0             0.0"
hisym_lat_b_16="        0.0             5.177959919             0.0"
hisym_lat_c_16="        0.0             0.0            7.7496299744"

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!the lattice vectors are permuted!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#prefix of the vasp files
prefix="P2Q_P421c"

#number of electrons per unit cell for unstrained doped calculations
nelect=0.36

ncores=40

#_____________________________________________________#
hisym_lat_a=0
hisym_lat_b=0
hisym_lat_c=0

kpoints=""

if [ $num_of_atoms -eq 16 ]
then
	hisym_lat_a=$hisym_lat_a_16
	hisym_lat_b=$hisym_lat_b_16
	hisym_lat_c=$hisym_lat_c_16
   
        kpoints="9 9 6 0 0 0"

elif [ $num_of_atoms -eq 32 ]
then
        hisym_lat_a=$hisym_lat_a_32
        hisym_lat_b=$hisym_lat_b_32
        hisym_lat_c=$hisym_lat_c_32

        kpoints="6 6 6 0 0 0"
fi
#_____________________________________________________#




#_______________________UNSTRAINED____________________#
for ((i=0; i<=40; i++))
do
	dir="${prefix}_unstrained/${prefix}_unstrained_${i}"
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
    nat         = ${num_of_atoms}
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
	line=$(grep -n Direct ../STRUCTURES/${prefix}_${i}.vasp | cut -d : -f 1)

	for ((j=0; j<num_of_atoms; j++))
	do
		line=$((line+1))
		atom_pos=$(sed "${line}q;d" ../STRUCTURES/${prefix}_${i}.vasp)
		echo "$atom_pos 0 0 0" >> $dir/rscf.in
	done

	#append the k points to the rscf file
	echo "" >> $dir/rscf.in
	echo "K_POINTS automatic" >> $dir/rscf.in 
	echo $kpoints >> $dir/rscf.in

        #make the job file
	rm $dir/job.sh
        cat > $dir/job.sh << EOF
        #!/bin/bash
        #BSUB -n $ncores
        #BSUB -R "rusage[mem=3072]"
        #BSUB -W 8:00
        #BSUB -o $dir.o
        #BSUB -e $dir.e
        #BSUB -J $dir

        mpirun pw.x -npool $ncores -in rscf.in > rscf.out
EOF
done


exit

#_____________________UNSTRAINED DOPED_____________________#
for ((i=0; i<=40; i++))
do
	dir="${prefix}_unstrained_doped/${prefix}_unstrained_doped_e_${nelect}_${i}"
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
    nat         = ${num_of_atoms}
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
       dir_ref="${prefix}_unstrained/${prefix}_unstrained_${i}"
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
       line=$(grep -n Direct ../STRUCTURES/${prefix}_${i}.vasp | cut -d : -f 1)

       for ((j=0; j<num_of_atoms; j++))
       do
               line=$((line+1))
               atom_pos=$(sed "${line}q;d" ../STRUCTURES/${prefix}_${i}.vasp)
               echo "$atom_pos" >> $dir/scf.in
       done


       #append the k points to the rscf file
       echo "" >> $dir/scf.in
       echo "K_POINTS automatic" >> $dir/scf.in
       echo $kpoints >> $dir/scf.in



       #make the job file
       rm $dir/job.sh
       cat > $dir/job.sh << EOF
       #!/bin/bash
       #BSUB -n $ncores
       #BSUB -R "rusage[mem=3072]"
       #BSUB -W 00:40
       #BSUB -o $dir.o
       #BSUB -e $dir.e
       #BSUB -J $dir
       

        mpirun pw.x -npool $ncores -in scf.in > scf.out
        rm -r *.save
EOF

done

