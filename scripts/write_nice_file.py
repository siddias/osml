#! /usr/bin/env python

# Sample script to create the nice_file
process_dict = { 'gedit': 5, 'firefox': -5, 'chrome': 7}

with open('nice_file','w') as f:
	for process_name, nice in process_dict.items():
		f.write('%-50s %02d\n' %(process_name,nice))

	
	
