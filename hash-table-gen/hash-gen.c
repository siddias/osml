#include <linux/hashtable.h>
#include <linux/kernel.h>  
#include <linux/module.h>  
#include <linux/moduleparam.h>
#include <linux/slab.h>
#include <linux/string.h>

#include <asm/uaccess.h>
#include <osml/osml.h>

// Declaring Hash Table (number of buckets: 2^6 = 64)
extern DECLARE_HASHTABLE(my_hash, 6);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Siddharth Dias");

static char *nice_array[500];
static char *process_array[500];
static int size;

module_param_array(nice_array, charp, &size, 0000);
module_param_array(process_array, charp, &size, 0000);

/* Entry Point for Kernel Module */
int init_module(void)
{
    struct hashtable *h;
    int i, j,pos=0, nice;
    
    printk(KERN_INFO "OSML module is loaded\n");

    for(i=0; i< size; i++)
    {
	kstrtoint(nice_array[i],10,&nice);
	for(j=0,pos=0;j<strlen(process_array[i]);j++,pos++)
	{
		if(process_array[i][pos]=='\"')
			pos++;
		process_array[i][j]=process_array[i][pos];
	}
	process_array[i][j]='\0';

	// Allocate memory for the hash table entry
	h = kmalloc(sizeof *h, GFP_KERNEL);
	if (!h)
	{
		printk("Can't Allocate Memory");
		return -ENOMEM;
	}

	// Assign values to entry
	sprintf(h->name,process_array[i]);
	h->nice = nice ; 

	// Add entry to hash table
	hash_add(my_hash, &h->my_hash_list, strlen(h->name));

	// Checking values inserted in the hash table
	printk(KERN_INFO "name: %s nice: %d",h->name,h->nice);

    }
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
