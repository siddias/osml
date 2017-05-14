#!/usr/bin/env bash

dmesg | grep "Attribs" > /etc/osml/log
./master-script.sh /etc/osml/log
