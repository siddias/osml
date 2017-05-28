#!/usr/bin/env bash

#Script for nice classifier. Check if classifier is compatible before running.
if [ "$1" ] 
then
	./get_attributes_from_logs.sh $1
	./load-process-classifier.py
	echo "Process classified."
	./get_daily_list.sh
	./update_frequency.pl
	echo "Frequency updated."
	./get-all-readelf.sh
	./load_nice_classifier.py
	echo "Nice value updated."
	./km_switch.sh
else
	echo "Error: Path to logs not specified."
fi
