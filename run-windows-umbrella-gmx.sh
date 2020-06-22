#!/bin/bash
set -e

for ((i=0;i<27;i++)); do

  x=$(echo "0.05*$(($i+1))" | bc);

  sed 's/WINDOW/'$x'/g' mdp-pull/min.mdp > grompp.mdp
  gmx grompp -o min.$i -pp min.$i -po min.$i -n index.ndx
  gmx mdrun -deffnm min.$i -pf pullf-min.$i -px pullx-min.$i

  sed 's/WINDOW/'$x'/g' mdp-pull/min2.mdp > grompp.mdp
  gmx grompp -o min2.$i -c min.$i -t min.$i -pp min2.$i -po min2.$i -maxwarn 1 -n index.ndx
  gmx mdrun -deffnm min2.$i -pf pullf-min2.$i -px pullx-min2.$i

  sed 's/WINDOW/'$x'/g' mdp-pull/eql.mdp > grompp.mdp
  gmx grompp -o eql.$i -c min2.$i -t min2.$i -pp eql.$i -po eql.$i  -maxwarn 1 -n index.ndx
  gmx mdrun -deffnm eql.$i -pf pullf-eql.$i -px pullx-eql.$i

  sed 's/WINDOW/'$x'/g' mdp-pull/eql2.mdp > grompp.mdp
  gmx grompp -o eql2.$i -c eql.$i -t eql.$i -pp eql2.$i -po eql2.$i  -maxwarn 1  -n index.ndx
  gmx mdrun -deffnm eql2.$i -pf pullf-eql2.$i -px pullx-eql2.$i

  sed 's/WINDOW/'$x'/g' mdp-pull/prd.mdp > grompp.mdp
  gmx grompp -o prd.$i -c eql2.$i -t eql2.$i -pp prd.$i -po prd.$i  -maxwarn 1  -n index.ndx
  gmx mdrun -deffnm prd.$i -pf pullf-prd.$i -px pullx-prd.$i

done
