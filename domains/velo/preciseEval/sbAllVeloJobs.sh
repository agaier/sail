#!/bin/bash

for i in {0001..1000};
do
		scriptName="VeloCFD$i.sh"
        cp sbVeloJob_hpc2.sh $scriptName
        qsub -v path="/scratch/agaier2m/sampleSet/case$i" $scriptName
        rm $scriptName
done 
