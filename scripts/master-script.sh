#!/usr/bin/env bash

#Script for nice classifier. Check if classifier is compatible before running.
if [ "$1" ] 
then
	./get_attributes_from_logs.sh $1
	./load-process-classifier.py
	./get_daily_list.sh
	./update_frequency.pl
	./get-all-readelf.sh
	./load_nice_classifier.py
	
else
	echo "Error: Path to logs not specified."
fi
