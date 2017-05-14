# osml

Steps to run the project:
1) Install the required packages using the following commands:
  ``` shell
  sudo apt-get install acct pip libdatetime-perl
  sudo pip install numpy scipy scikit-learn
  ```
2) Place the contents of the scripts folder to /opt/osml. 

3) Run the OSML system using the following commands:
``` shell
  sudo /opt/osml/run_osml.sh
  ```
  
4) Download the kernel source code (version 4.4.59) from 
https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.59.tar.xz

5) Extract the contents to /usr/src/linux-4.4.59 (hereafter referred to as BASE_DIR)

6) Clone this repository in $HOME and copy the inner osml folder to the BASE_DIR

7) Edit the Makefile in BASE_DIR. Add osml/ to core-y line

8) Copy the contents of the include directory to BASE_DIR/include

9) Compile hash-gen kernel module:
  ``` shell
  cd ~/osml/hash-table-gen
  mkdir /etc/osml
  cp nice_file /etc/osml
  make
  ```
10) Issue follow commands to compile the kernel (will take some time)
  ``` shell
  cd /usr/src/linux-4.4.59/
  sudo make -j 4
  sudo make modules_install install
  sudo reboot
  ```
11) Then to make the kernel module load at boot, issue following commands:
  ``` shell
  sudo cp ~/osml/hash-table-gen/hash-gen.ko /lib/modules/4.4.59/kernel/drivers
  sudo nano /etc/modules
     Note: append hash-gen to the end of this file
  sudo depmod
  sudo reboot
  ```
12) The OSML system now works.
