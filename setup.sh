#!/usr/bin/env bash

#Install required packages
apt-get -y install acct python-pip libdatetime-perl libncurses5-dev libssl-dev
pip install numpy scipy scikit-learn pandas

mkdir -p /opt/osml
mkdir -p /etc/osml

pushd nice_classifier && ./build-nice-classifier.py && popd
pushd process_classifier && ./build-process-classifier.py && popd

cp -R scripts /opt/osml
cp nice_classifier/nice-classifier.pkl /opt/osml/scripts
cp process_classifier/process-classifier-final.pkl /opt/osml/scripts
pushd /opt/osml/scripts && ./run_osml.sh && popd

tar -xvf include/linux-4.4.59.tar.xz -C /usr/src/
cp -R osml /usr/src/linux-4.4.59/
cp include/fork.c /usr/src/linux-4.4.59/kernel/

pushd /usr/src/linux-4.4.59 && sed -i '/fs\// s/$/ osml\//' Makefile && popd

cp -R include/osml /usr/src/linux-4.4.59/include/osml
cp scripts/nice_file /etc/osml

pushd /usr/src/linux-4.4.59 && make menuconfig && make -j 4 && make modules_install install && popd
pushd hash-table-gen && make && popd
cp hash-table-gen/hash-gen.ko /lib/modules/4.4.59/kernel/drivers
echo 'hash-gen' >> /etc/modules
depmod

