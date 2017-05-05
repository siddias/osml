# osml

Steps to run the project:
1) Download the kernel source code (version 4.4.59) from 
https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.59.tar.xz

2) Extract the contents to /usr/src/linux-4.4.59 (hereafter referred to as BASE_DIR)

3) Clone this repository in $HOME and copy the inner osml folder to the BASE_DIR

4) Edit the Makefile in BASE_DIR. Add osml/ to core-y line

5) Copy the contents of the include directory to BASE_DIR/include

5) Compile hash-gen kernel module:
  ## cd ~/osml/hash-table-gen
  ## mkdir /tmp/osml
  ## cp nice_file /tmp/osml
  ## make
  
6) Issue follow commands to compile the kernel (will take some time)
  ## cd /usr/src/linux-4.4.59/
  ## sudo make -j 4
  ## sudo make modules_install install
  ## sudo reboot
  
7) Then to make the kernel module load at boot, issue following commands:
  ## sudo cp ~/osml/hash-table-gen /lib/modules/4.4.59/kernel/drivers
  ## sudo nano /etc/modules
     Note: append hash-gen to the end of this file
  ## sudo depmod
  ## sudo reboot

8) The OSML system now works.
