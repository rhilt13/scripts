#! /usr/bin/python

from bs4 import BeautifulSoup
import sys
#import csv
#import urllib2
#import pandas as pd
#import numpy as np

with open(sys.argv[1],'r') as my_file:
	soup=BeautifulSoup(my_file,'xml')

# page parser
#soup = BeautifulSoup(markup, "lxml-xml", from_encoding="utf-8")

#titles = soup.find_all('variation')
#for title in titles:
#    print(title.get_text())

print(soup("name"))