# Use seaborn to plot figures

from __future__ import division
# import numpy as np
# from pandas.tools.plotting import andrews_curves
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import matplotlib as mpl
mpl.rc('image', cmap='jet')

# 1) ####
# Read csv file into pandas dataframe
# df = pd.read_csv('../dist_centerOfMass/findistance_output.csv.e5')
# df = pd.read_csv('dist_min_allgta.csv.e3')
# df = pd.read_csv('dist_min_allgta.csv.e3.selPdb.e1')
# df = pd.read_csv('findistance_output.csv.e6.sel_pdb')
# df = pd.read_csv('dist_min_selPdb.csv.e2')
# df = pd.read_csv('2dist_min_selPdb.csv.e1')
df = pd.read_csv('3dist_min_selPdb.csv.e2')

# 2) ####
# Reshape the data to merge all the plotting columns into a single column
# Reshape for violinplot, catplot
# No reshape for pairplot
df=df.melt(id_vars=['Family','Mechanism','Pdb'],var_name='positions',value_name='distance')

# print df.size
# print type(df)

# 3) ####
# Get rid of NAs individually 9 no worries about removing entire row because of single NA.
# df=df.dropna()
# print df.
# print df.size

# 4) ####
# Initialize a figure of appropriate size
plt.figure(figsize=(8,12))

#### Plot the required figures ####

# # Violin plot with separated groups
# sns_plot=sns.violinplot(x="distance",y="positions",hue="Mechanism",data=df,dtype = 'float')

# # Boxplot
sns_plot=sns.boxplot(x="distance",y="positions",hue="Mechanism",data=df)

# # Boxenplot
# sns_plot=sns.catplot(x="distance",y="positions",hue="Mechanism",data=df)

# # Same parameters for violin and boxplots
sns_plot.tick_params(labelsize=20)
sns_plot.set_xlabel("Distance",fontsize=20)
sns_plot.set_ylabel("Position pairs",fontsize=20)
plt.setp(sns_plot.get_legend().get_texts(), fontsize='20')
plt.setp(sns_plot.get_legend().get_title(), fontsize='30')

# # Scatterplot matrix
# sns.plot=sns.pairplot(df, hue="Mechanism", kind="scatter") # , kind="reg")

# # Cat plot - Line with categorical x axis
#sns.catplot(x="positions", y="distance", hue="Mechanism",palette={"Inverting": "g", "Retaining": "m"},markers=["^", "o"], linestyles=["-", "--"],kind="point", data=df);

# # Andrew's plot
# Select only numeric columns to plot in x-axis and the column you want to group by.
# df1=df.iloc[:,[1,3,4,5,6,7,8,9,10,11,12]] 
# andrews_curves(df1,'Mechanism')

plt.show()
# sns_plot.show()
fig=sns_plot.get_figure()
fig.savefig("plot.png")