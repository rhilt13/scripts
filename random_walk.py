#! /usr/bin/env python

import random
import numpy as np
import scipy.stats as st
from scipy.interpolate import spline
import matplotlib.pyplot as plt

# Function to generate weighted choice:
def weighted_choice(weights):
    totals = []
    running_total = 0

    for w in weights:
        running_total += w
        totals.append(running_total)

    rnd = random.random() * running_total
    for i, total in enumerate(totals):
        if rnd < total:
            return i

## Problem 1

# Input:
N=100
p3=[7,3]
p5=[5,5]
p7=[3,7]
selP=[p3,p5,p7]
selPlabel=["p=0.3","p=0.5","p=0.7"]
iterate=5
colors=['r','g','b']

# Using the function for random walk:
fig=plt.figure(figsize=(10, 10))
ax = fig.add_subplot(111)
for idx,prob in enumerate(selP):	# For p=0.3,0.5,0.7
	for j in range(0,iterate,1):	# For 5 independent runs
		Xs=list()
		time=list()
		start=0
		for i in range(0,N,1):		# For N=100 in each run
			choice=weighted_choice(prob)
			if choice==0:
				start=start-1
			else:
				start=start+1
			Xs.append(start)
			time.append(i)
		# Plotting the results for question 1
		ax.plot(time,Xs,color=colors[idx],label='_nolegend_' if j>0 else selPlabel[idx])
		ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),ncol=3, fancybox=True, shadow=True)
ax.set_ylabel('x', fontsize=30)
ax.set_xlabel('Time', fontsize=30)
fig.savefig("fig1.png",format='png')

### End Problem 1

## Problem 2

# Input:
N=10
p5=[5,5]
p7=[3,7]
selP=[p5,p7]
selPf=[0.5,0.7]
selPlabel=["p=0.5","p=0.7"]
iterate=100000
b=np.arange(0,10)
# Inititalize a figure
fig,axs=plt.subplots(nrows=1,ncols=len(selP),figsize=(30,10))

# Random walk and figure generation
for idx,prob in enumerate(selP):	# For p=0.5,0.7
	ax = axs[idx]
	NRcount=list()
	for j in range(0,iterate,1):	# For 100000 independent runs
		start=0
		NR=0
		for i in range(0,N,1):		# For N=10 in each run
			choice=weighted_choice(prob)
			if choice==1:
				NR+=1
		NRcount.append(NR)
	# Plot the histogram for 
	ax.hist(x=NRcount,normed=1,align='left',color='c', label=selPlabel[idx])	# Plot histogram for density
	binomial=st.binom.pmf(b,N,selPf[idx])
	xnew = np.linspace(np.array(b).min(),np.array(b).max(),300)
	power_smooth = spline(b,binomial,xnew)
	ax.plot(xnew,power_smooth,color='r',linewidth=5,label='binomial')
	ax.set_xlim((0,10))
	ax.set_xlabel('NR',fontsize=20)
	ax.set_ylabel('Probability',fontsize=20)
	ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),ncol=3, fancybox=True, shadow=True)
fig.savefig("fig2.png",format='png')

### End Problem 2

## Problem 3

# Input:
N=100
p05=[0.95,0.05]
p15=[0.85,0.15]
selP=[p05,p15]
selPf=[0.05,0.15]
selPp=[5,15]
selPlabel=["p=0.05","p=0.15"]
iterate=100000
colors=['c','c']
colors2=['b','m']
colors3=['r','g']
b=np.arange(0,100)

# Inititalize a figure
fig,axs=plt.subplots(nrows=1,ncols=len(selP),figsize=(30,10))

# Random walk and figure generation
for idx,prob in enumerate(selP):	# For p=0.05,0.15
	ax = axs[idx]
	NRcount=list()
	for j in range(0,iterate,1):	# For each independent runs
		NR=0
		for i in range(0,N,1):		# For N=100 in each run
			choice=weighted_choice(prob)
			if choice==1:
				NR+=1
		NRcount.append(NR)
	# Plot the histogram for 
	ax.hist(x=NRcount,normed=1,histtype='bar',color=colors[idx],label=selPlabel[idx])	# Plot histogram for density
	binomial=st.binom.pmf(b,N,selPf[idx])
	ax.plot(b,binomial,color='r',linewidth=5,label='binomial')
	poisson=st.poisson.pmf(b,selPp[idx])
	ax.plot(b,poisson,color='g',linewidth=5,label='Poisson')
	ax.set_xlim((0,100))
	ax.set_xlabel('NR',fontsize=20)
	ax.set_ylabel('Probability',fontsize=20)
	ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),ncol=3, fancybox=True, shadow=True)
fig.savefig("fig3.png",format='png')

### End Problem 3

## Problem 4

# Input:
N=100
p3=[7,3]
p5=[5,5]
p7=[3,7]
p9=[1,9]
selP=[p3,p5,p7,p9]
selPf=[]
selPlabel=["p=0.3","p=0.5","p=0.7","p=0.9"]
iterate=10000
colors=['r','g','b','m']
b=np.arange(0,100)

# Inititalize a figure
fig,axs=plt.subplots(nrows=1,ncols=len(selP),figsize=(50,10))

# Random walk and figure generation
for idx,prob in enumerate(selP):	# For p=0.05,0.15
	ax = axs[idx]
	XEnd=list()
	for j in range(0,iterate,1):	# For each independent runs
		start=0
		NR=0
		for i in range(0,N,1):		# For N=10 in each run
			choice=weighted_choice(prob)
			if choice==0:
				start=start-1
			else:
				start=start+1
		XEnd.append(start)
	# Plot the histogram for 
	ax.hist(x=XEnd,normed=1,color='c',label=selPlabel[idx])	# Plot histogram for Counts
	mu, std = st.norm.fit(XEnd)
	normal=st.norm.pdf(XEnd)
	xmin, xmax = plt.xlim()
	x = np.linspace(-100, 100, 200)
	p = st.norm.pdf(x, mu, std)
	ax.plot(x, p, 'r', linewidth=5, label='Gaussian')
	ax.set_xlim((-100,100))
	ax.set_xlabel('XEnd',fontsize=20)
	ax.set_ylabel('Probability',fontsize=20)
	ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),ncol=3, fancybox=True, shadow=True)
fig.savefig("fig4.png",format='png')

### End Problem 4






















