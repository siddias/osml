#!/usr/bin/env bash

cat new-instance-types.csv | cut -d',' -f1 | sort | uniq | while read -r line ; do
	./get_readelf.sh $line
done

