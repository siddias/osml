#!/usr/bin/env bash

lastcomm | grep "`date +"%a %b %e"`" | awk '{print $1}' > log3
cat log3 | tr ' ' '\n' | sort | uniq -c | awk '{print $2"\t"$1}' > daily_database
