#!/bin/bash


parent_scf="scf.in"
disp_file="eigenvector.temp"


#__________________________________#

line=$(grep -n nat $parent_scf | cut -d : -f 1)
nat=$(sed "${line}q;d" $parent_scf | awk '{print $3}')

line=""
i=1
while ! [ "$line" = "ATOMIC_POSITIONS crystal" ]
do
    line=$(sed "${i}q;d" $parent_scf)
    ((i++))
done


cat > mode.vasp << EOF

1.0
        5.1779599190         0.0000000000         0.0000000000
        0.0000000000         5.1779599190         0.0000000000
        0.0000000000         0.0000000000         7.7496299744
  O W
  12 4
Direct
EOF

line1=$i
line2=1

for ((i=0; i<nat; i++))
do
    #get the original positions
    pos_old=$(sed "${line1}q;d" $parent_scf)
    at=$(echo $pos_old | awk '{print $1}')
    x_old=$(echo $pos_old | awk '{print $2}')
    y_old=$(echo $pos_old | awk '{print $3}')       
    z_old=$(echo $pos_old | awk '{print $4}')
    ((line1++))
    disp=$(sed "${line2}q;d" $disp_file)
    x_disp=$(echo $disp | awk '{print $1}')
    y_disp=$(echo $disp | awk '{print $3}')
    z_disp=$(echo $disp | awk '{print $5}')
    ((line2++))
    
    x_disp=$(printf "%10.10f" $x_disp)
    y_disp=$(printf "%10.10f" $y_disp)
    z_disp=$(printf "%10.10f" $z_disp)
     
    x_new=$(echo "$x_old+$x_disp" | bc -l)
    y_new=$(echo "$y_old+$y_disp" | bc -l)
    z_new=$(echo "$z_old+$z_disp" | bc -l)
    echo $x_new $y_new $z_new >> mode.vasp
done
vasp_findsym.sh --in=mode.vasp --tol=1e-4
