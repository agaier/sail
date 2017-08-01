#!/bin/bash

startFile="start.signal"
doneFile="done.signal"
stopFile="stop.signal"

./Allclean

while true
sleep 1s
do

if [ -f "$stopFile" ]
then
	echo "$stopFile found, ending caseRunner."
	break;
fi

if [ -f "$startFile" ]
	then
	echo "$startFile found: starting OpenFOAM case."
	./Allclean
	./Allrun
	else
	echo -n "Waiting for $startFile..."
fi

done