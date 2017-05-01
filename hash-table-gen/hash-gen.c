#include <linux/module.h>  
#include <linux/kernel.h>  
#include <linux/hashtable.h>
#include <linux/fs.h>
#include <linux/slab.h>

#include <asm/uaccess.h>
#include <osml/osml.h>

// Declaring Hash Table (number of buckets: 2^6 = 64)
extern DECLARE_HASHTABLE(my_hash, 6);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Siddharth Dias");


struct file* file_open(const char* path, int flags, int rights) {
    struct file* filp = NULL;
    mm_segment_t oldfs;
    int err = 0;

    // Change FS
    oldfs = get_fs();
    set_fs(get_ds());

    filp = filp_open(path, flags, rights);

    // Restore FS
    set_fs(oldfs);

    if(IS_ERR(filp)) {
        err = PTR_ERR(filp);
        return NULL;
    }
    return filp;
}


int file_read(struct file* file, unsigned long long offset, unsigned char* data, unsigned int size)
{
    mm_segment_t oldfs;
    int ret;

    // Change FS
    oldfs = get_fs();
    set_fs(get_ds());

    ret = vfs_read(file, data, size, &offset);

    // Restore FS
    set_fs(oldfs);

    return ret;
}  


void file_close(struct file* file) {
    filp_close(file, NULL);
}


/* Entry Point for Kernel Module */
int init_module(void)
{
	struct file *f;
	struct hashtable *h;
    char buf[128], name[50], pname[128];
    int i, offset, nice;
    
    // Initializing buffers to 0
    for(i=0;i<128;i++){
        buf[i] = 0;
		pname[i] = 0;
	}

    printk(KERN_INFO "OSML module is loaded\n");

    // Read file
    f = file_open("/home/osboxes/km/nice_file", O_RDONLY, 0);
	
	if(f == NULL)
        printk(KERN_ALERT "Error opening file!\n");
    else
    {
		i=offset=0;
		while(1)
		{
			// Read 54 bytes from the file
			i = file_read(f, offset, buf, 54);
			
			if(i<=0)
				break;
			
			// Read name and nice from buffer
			sscanf(buf, "%s %d", name, &nice);
			
			// Allocate memory for the hash table entry
			h = kmalloc(sizeof *h, GFP_KERNEL);

			if (!h)
			{
				printk("Can't Allocate Memory");
				return -ENOMEM;
			}

			// Assign values to entry
			sprintf(h->name,name);
			h->nice = nice ; 
			
			// Add entry to hash table
			hash_add(my_hash, &h->my_hash_list, strlen(h->name));
			
			offset +=i;

			// Checking values inserted in the hash table
			printk(KERN_INFO "name: %s nice: %d",name,nice);
		}
    }
    file_close(f);
    return 0;
}


/* Executed when Kernel Module is removed */
void cleanup_module(void)
{
	struct hashtable *tmp;
	int i;
	
	hash_for_each(my_hash, i, tmp, my_hash_list) {
		hash_del(&tmp->my_hash_list);
	}

	printk("Exiting");
}
