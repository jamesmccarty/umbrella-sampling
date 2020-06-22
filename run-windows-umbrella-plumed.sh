#!/bin/bash
set -e

for ((i=0;i<27;i++)); do

  x=$(echo "0.05*$(($i+1))" | bc);

  sed 's/WINDOW/'$x'/g' plumed.dat > plumed.$i.dat
  gmx grompp -f mdp/min.mdp -o min.$i -pp min.$i -po min.$i 
  gmx mdrun -deffnm min.$i -plumed plumed.$i.dat 
  mv COLVAR COLVAR-min.$i

  gmx grompp -f mdp/min2.mdp -o min2.$i -c min.$i -t min.$i -pp min2.$i -po min2.$i -maxwarn 1 
  gmx mdrun -deffnm min2.$i -plumed plumed.$i.dat 
  mv COLVAR COLVAR-min2.$i

  gmx grompp -f mdp/eql.mdp -o eql.$i -c min2.$i -t min2.$i -pp eql.$i -po eql.$i -maxwarn 1 
  gmx mdrun -deffnm eql.$i -plumed plumed.$i.dat 
  mv COLVAR COLVAR-eql.$i
 

  gmx grompp -f mdp/eql2.mdp -o eql2.$i -c eql.$i -t eql.$i -pp eql2.$i -po eql2.$i -maxwarn 1 
  gmx mdrun -deffnm eql2.$i -plumed plumed.$i.dat 
  mv COLVAR COLVAR-eql2.$i

  gmx grompp -f mdp/prd.mdp -o prd.$i -c eql2.$i -t eql2.$i -pp prd.$i -po prd.$i -maxwarn 1
  gmx mdrun -deffnm prd.$i -plumed plumed.$i.dat 
  mv COLVAR COLVAR-prd.$i

done
