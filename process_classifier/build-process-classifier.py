#!/usr/bin/env python

import pandas
data = pandas.read_csv('data(4)-with-names.csv')
mat = pandas.DataFrame.as_matrix(data)
X = mat[:,:4]
y = mat[:,4]


#(VmSize should not be a string!)
X[:,3] = map(long,X[:,3])

from sklearn import tree
clf = tree.DecisionTreeClassifier()
clf = clf.fit(X,y)



from sklearn.externals import joblib
joblib.dump(clf,"process-classifier-final.pkl")

