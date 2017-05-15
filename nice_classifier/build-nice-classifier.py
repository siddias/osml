#!/usr/bin/python

import pandas
import numpy
data = pandas.read_csv('attributes-less.csv')
mat = pandas.DataFrame.as_matrix(data)
X = mat[:,1:7]
y = mat[:,8]
y = numpy.asarray(y,dtype = 'int')

from sklearn import tree
clf = tree.DecisionTreeClassifier()
clf = clf.fit(X,y)

from sklearn.externals import joblib
joblib.dump(clf,"nice-classifier.pkl")
