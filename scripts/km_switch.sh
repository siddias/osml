#!/usr/bin/env bash

/sbin/rmmod hash_gen &> /dev/null
process_array=$(cut -c1-50 /etc/osml/nice_file | sed -e 's/[ ]*$//' |  sed -e 's/\(.*\)/"\1"/g' | paste -sd "," -)
nice_array=$(cut -c51- /etc/osml/nice_file | sed -e 's/[ ]*$//' | paste -sd "," -)
/sbin/insmod /lib/modules/4.4.59/kernel/drivers/hash-gen.ko nice_array=$nice_array process_array=$process_array
