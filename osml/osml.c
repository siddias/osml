#include <linux/sched.h>
#include <linux/mm.h>
#include <linux/fs.h>
#include <linux/hashtable.h>

#include <osml/osml.h>
#include "osml_internal.h"

#define BITS 6

// Defining hash table here
DEFINE_HASHTABLE(my_hash, BITS);

// Exports the hash table so that it can be polulated by the kernel module when it is loaded
EXPORT_SYMBOL(my_hash);

// Checks if entry for a process exists in the hash table
int get_nice(struct task_struct* task)
{
	struct hashtable *tmp;

	// Iterates through the list associated with the bucket to which the process name has hashed
	hash_for_each_possible(my_hash, tmp, my_hash_list, strlen(task->comm))
	{
		// Returning nice value when match is found
		if (!strcmp(task->comm,tmp->name))
			return tmp->nice;
	}
	// Not found
	return -99;
}

// Logs neccessary attributes that are required for the nice classifier
int collect_attributes(struct task_struct* task)
{
	unsigned long text, vsize, end_code, size, data, shared, resident, lib, i;
	struct mm_struct *mm = get_task_mm(task);
	char buff[128];
	
	// Setting buffers to 0
	for(i=0;i<128;i++)
		buff[i]=0;
	
	// If memory map has been assigned
	if (mm) 
	{
		size = task_statm(mm, &shared, &text, &data, &resident);
		vsize = task_vsize(mm);
		end_code = mm->end_code;

		data = mm->total_vm - mm->shared_vm - mm->stack_vm;
     	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
		lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;

		//Logging attributes
		printk("\nAttribs,%s,%lu,%lu,%lu,%lu,%s\n",task->comm, vsize, end_code, text, lib, dentry_path_raw(mm->exe_file->f_path.dentry,buff,128));
	}
    
    return 0; 
 }

void set_nice(struct task_struct* task) 
{
	int osml_nice;
	
	// Check if hashtable has been populated
	if(!hash_empty(my_hash))
	{
		// Get nice value by reading from the hashtable
		osml_nice = get_nice(task);

		// Assign value if within range
		if(osml_nice>=-20 && osml_nice<=19)
		{
			task->static_prio = NICE_TO_PRIO(osml_nice);
			printk("Priority: %d, %d",osml_nice, task->static_prio);
		}
		else if(osml_nice == -99) // If not found, log the attributes
			collect_attributes(task);
	}
}
