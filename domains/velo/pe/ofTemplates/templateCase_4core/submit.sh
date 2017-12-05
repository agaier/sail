#!/bin/sh
#PBS -N SAIL_caseRunner
#PBS -q hpc2
#PBS -l nodes=1:ppn=4
#PBS -l walltime=24:00:00
#PBS -l vmem=24gb

# Necessary to pseudo-revert to old memory allocation behaviour
export MALLOC_ARENA_MAX=4

# Load Java, needed for parallel computing toolbox
# java/7, java/8 no noticable difference in terms of stability
module load java/default
module load cuda/default

# Run experiment
cd $path
./Allclean && ./caseRunner.sh

