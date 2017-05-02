#!/usr/bin/env bash

if [ "$1" ] 
then
	grep Attribs $1 | cut -d',' -f2-7 > attributes_from_logs.csv
else
	echo "Error: Path to logs not specified."
fi
