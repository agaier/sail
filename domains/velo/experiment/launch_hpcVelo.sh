#!/bin/bash

# Create base OpenFOAM cases and launch case runners
 nHpc1Cases=0
 nHpc2Cases=20
 destFolderName="/scratch/agaier2m/sailCFD/"

# HPC1 with 12 Cores (1 job per node)
baseFolderName="/home/agaier2m/Code/ffdSail/domains/velo/pe/ofTemplates/hpc1_12/"
for (( i=1; i<=$nHpc1Cases; i++ ))
do
	caseName=$destFolderName"case$i"
	echo $caseName
	cp -TR $baseFolderName $caseName
	qsub -j oe -v path="$caseName" $caseName/submit.sh
done 

# HPC2 with 12 Cores (2 jobs per node)
baseFolderName="/home/agaier2m/Code/ffdSail/domains/velo/pe/ofTemplates/hpc2_12/"
for (( i=nHpc1Cases+1; i<=$nHpc1Cases+$nHpc2Cases; i++ ))
do
	caseName=$destFolderName"case$i"
	echo $caseName
	cp -TR $baseFolderName $caseName
	qsub -j oe -v path="$caseName" $caseName/submit.sh
done 

# Launch SAIL
cases=$(($nHpc1Cases + $nHpc2Cases))
echo 'SAIL Main Script'
qsub -N SAIL_FFD -v encoding=\'ffd\',nCases=10,startCase=1 sb_hpcVelo.sh
qsub -N SAIL_PARAM -v encoding=\'param\',nCases=10,startCase=11 sb_hpcVelo.sh
