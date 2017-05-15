#!/usr/bin/env bash

#Install required packages
apt-get install acct pip libdatetime-perl
pip install numpy scipy scikit-learn

mkdir /opt/osml
mkdir /etc/osml

cp -R scripts ../opt/osml
/opt/osml/run_osml.sh

tar -xf include/linux-4.4.59.tar.xz -C /usr/src/linux-4.4.59
cp -R osml /usr/src/linux-4.4.59
cp include/fork.c /usr/src/linux-4.4.59/kernel

pushd /usr/src/linux-4.4.59 && sed -i '/fs\// s/$/ osml\//' Makefile && popd
cp -R include/osml /osml

cp scripts/nice_file /etc/osml
pushd hash-table-gen && make && popd

pushd /usr/src/linux-4.4.59/ && make -j 4 && make modules_install install && popd
cp hash-table-gen/hash-gen.ko /lib/modules/4.4.59/kernel/drivers
echo 'hash-gen' >> /etc/modules
depmod
reboot
