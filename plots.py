#! /usr/bin/env python

# def violin():
	# import seaborn as sns


def main(args):
	import csv
	import numpy as np 
	import seaborn as sns

	with open(args.infile,'r') as f:
		reader=csv.reader(f, delimiter=',')
		# get header from first row
		header = next(reader)
    	# get all the rows as a list
		df = list(reader)

    	# transform data into numpy array
		df = np.array(df)
		#.astype(float)
		print(df[1,3:])
		d1=df[:,3:] #.astype(float)
		print d1
		# print d1.shape
		# print df.shape
		# # print header.size
		# print len(header)
	sns_plot=sns.violinplot(data=d1,size=2400)
	fig=sns_plot.get_figure()
	fig.savefig("plot.png")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
           description="Generate plots using seaborn mainly.",
           epilog="Contact Rahil for help.")
    parser.add_argument('-i', '--infile', help='Input dca_pml file from darc', required=True)

    args = parser.parse_args()
    main(args)