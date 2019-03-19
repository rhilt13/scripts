#! /usr/bin/env python

from sklearn.cluster import KMeans
import numpy as np
import sys

# with open (sys.argv[1], "r") as myfile:
fullstr=np.genfromtxt(sys.argv[1], dtype=None)
	# for line in myfile.readlines():
    	# fullstr = myfile.read()
# print type(fullstr)
# fullstr=np.array(fullstr)
# print fullstr
# print fullstr.shape
names= [str(i[0]) for i in fullstr]
# print names
pts= np.array([[float(i[1]),float(i[2])] for i in fullstr])
# print pts.shape

# print loc
  #   	with open(file, 'r') as listfile:
		# for line in listfile.readlines():
		# 	pdb,domain,patterns=line.strip().split('\t',2)


# X = np.array([[1, 2], [1, 4], [1, 0], [4, 2], [4, 4], [4, 0]])
kmeans = KMeans(n_clusters=12, random_state=0).fit(pts)
# print kmeans.labels_
# kmeans.cluster_centers_
# kmeans.predict([[0, 0], [4, 4]])
c=0
for i in names:
	print i,"\t",pts[c][0],"\t",pts[c][1],"\t",kmeans.labels_[c]
	c+=1