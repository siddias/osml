#!/usr/bin/python
import math
from sklearn import tree
from sklearn.externals import joblib
clf = joblib.load('nice-classifier.pkl')

import pandas
data = pandas.read_csv('nice_classifier_attributes.csv', header=None)
mat = pandas.DataFrame.as_matrix(data)
X = mat[:,1:7]
X[:,1] = map(str,X[:,1])
X[:,2] = map(str,X[:,2])
X[:,3] = map(str,X[:,3])

def to_dec(n):
	try:
		return int(n,16)
	except ValueError:
		return 0

def type_to_int(t):
	if t == 'A':
		return 1
	elif t == 'C':
		return 2
	elif t == 'D':
		return 3
	elif t == 'F':
		return 4
	elif t == 'K':
		return 5
	elif t == 'N':
		return 6
	elif t == 'O':
		return 7

def check_for_nulls(x):
	try:
		return long(x)
	except ValueError:
		return 0
		
	
X[:,1] = map(to_dec,X[:,1])
X[:,2] = map(to_dec,X[:,2])
X[:,3] = map(to_dec,X[:,3])
X[:,5] = map(type_to_int,X[:,5])
X[:,0] = map(check_for_nulls, X[:,0])

y = mat[:,0]
y = map(str, y)

labels = clf.predict(X)
#labels = map(str, labels)

process_dict = dict(zip(y,labels))
with open('nice_values','a') as f:
	for name,nice in process_dict.items():
		f.write("%-50s %02d\n" %(name,nice))
#import numpy
#arr = numpy.column_stack((y,labels))
#f = open("nice_file","ab")
#numpy.savetxt(f, arr, delimiter=' ',fmt='%s')



