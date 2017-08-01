#!/bin/sh
#PBS -q hpc2
#PBS -l nodes=1:ppn=12
#PBS -l walltime=1:00:00
#PBS -l vmem=60gb
#PBS -j oe

# Necessary to pseudo-revert to old memory allocation behaviour
export MALLOC_ARENA_MAX=4

# Load Java, needed for parallel computing toolbox
# java/7, java/8 no noticable difference in terms of stability
module load java/default
module load cuda/default

# Run experiment
cd  $path
./Allclean
./Allrun