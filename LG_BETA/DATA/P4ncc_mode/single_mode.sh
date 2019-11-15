#!/bin/bash


parent_scf="scf.in"
child_scf="scf_mode.in"
disp_file="P4ncc_M.dyn"

disp_num=7


#__________________________________#
if [ -f $child_scf ]
then
	rm $child_scf
fi

line=$(grep -n nat $parent_scf | cut -d : -f 1)
nat=$(sed "${line}q;d" $parent_scf | awk '{print $3}')

line=""
i=1
while ! [ "$line" = "ATOMIC_POSITIONS crystal" ]
do	
	line=$(sed "${i}q;d" $parent_scf)
        echo $line >> $child_scf
	((i++))
done

rm mode.vasp
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
line2=$(grep -n "freq (\ *${disp_num})" $disp_file | cut -d : -f 1)
((line2++))

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
        x_disp=$(echo $disp | awk '{print $2}')
        y_disp=$(echo $disp | awk '{print $4}')
        z_disp=$(echo $disp | awk '{print $6}')
        ((line2++))

	x_new=$(echo "$x_old+$x_disp" | bc -l)
        y_new=$(echo "$y_old+$y_disp" | bc -l)
        z_new=$(echo "$z_old+$z_disp" | bc -l)
 
        echo $at $x_new $y_new $z_new >> $child_scf
	echo $x_new $y_new $z_new >> mode.vasp
done

kpoints=$(tail -n2 $parent_scf)
echo "" >> $child_scf
echo "$kpoints" >> $child_scf
vasp_findsym.sh --in=mode.vasp --tol=1e-4
