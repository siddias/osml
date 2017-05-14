#!/usr/bin/env python

from sklearn import tree
from sklearn.externals import joblib
clf = joblib.load('process-classifier-final.pkl')

import pandas
data = pandas.read_csv('attributes_from_logs.csv', header=None)
mat = pandas.DataFrame.as_matrix(data)
X = mat[:,1:5]
#X[:,0] = map(int,X[:,0])
y = mat[:,0]
y = map(str, y)

labels = clf.predict(X)
labels = map(str, labels)

import numpy
arr = numpy.column_stack((y,labels))

#check for deletion!
#f = open('nice_file','a')

names = []
values = []
for ins in arr:
	if ins[1] == 'K' or ins[1] == 'O' or ins[1] == 'D':
		names.append(ins[0])
		values.append(99)

process_dict = dict(zip(names,values))
import json
with open('nice_file.json','r') as f:
	data = json.load(f)
data.update(process_dict)

with open('/etc/osml/nice_file','w') as f:
	for name,nice in data.items():
		f.write("%-50s %02d\n" %(name,nice))

with open('nice_file.json','w') as f:
	json.dump(data,f)

import numpy.ma as ma
temp = arr
temp = ma.masked_where(temp == 'K', temp)
temp = ma.masked_where(temp == 'O', temp)
temp = ma.masked_where(temp == 'D', temp)
temp = ma.mask_rows(temp)
temp = ma.compress_rows(temp)

		
numpy.savetxt("new-instance-types.csv", temp, delimiter=',',fmt='%s')

#import os
#os.remove('attributes_from_logs.csv')


