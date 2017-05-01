// Represents Process Control Block (PCB)
struct task_struct;

// Represents Hashtable
struct hashtable;

// Function to set nice value of a process
void set_nice(struct task_struct*);

struct hashtable {
	char name[50];
	int nice; 
	struct hlist_node my_hash_list;
};
