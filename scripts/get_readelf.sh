#!/usr/bin/env bash

if [ "$1" ] 
then
path=`cat attributes_from_logs.csv | grep ^$1 | head -n1 | cut -d',' -f6` 
if [ "$path" ] 
		then		
			rodata=`objdump -h $path | grep "\.rodata" | awk '{print $3}'`
			bss=`objdump -h $path | grep "\.bss" | awk '{print $3}'`
			text=`objdump -h $path | grep "\.text" | awk '{print $3}'`
			programsize=`size $path | grep $1 | awk '{print $4}'`
			#echo "size $path | grep $1 | awk '{print $4}"
		else
			rodata=0
			bss=0
			text=0
			programsize=0
				
		fi	
#echo $rodata
#echo $bss
#echo $text
#echo $programsize
 

type=`cat new-instance-types.csv | grep ^$1, | head -n1 | cut -d"," -f2`
freq=`cat frequency_database | grep ^$1$'\t' | head -n1 | cut -d$'\t' -f2`
if [ ! "$freq" ]
	then
		freq=0
fi
if [ ! "$type" ]	
	then
		type=O
fi


echo "$1,$programsize,$bss,$rodata,$text,$freq,$type" >> nice_classifier_attributes.csv
#echo $programsize
fi
