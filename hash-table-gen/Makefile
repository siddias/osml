obj-m += hash-gen.o
KBUILD_EXTRA_SYMBOLS :=/lib/modules/4.4.59/build/Module.symvers

all:
	make -C /lib/modules/4.4.59/build M=$(PWD) modules

clean:
	make -C /lib/modules/4.4.59/build M=$(PWD) clean
