library(ggplot2)
library(plyr)

args <- commandArgs(TRUE)
file <- read.delim(args[1], header=F)

#print(file[,2])
bins <- c(0,1,10,100,1000,10000,35000)
w<- c(10,10,10,10,10,10)
#ggplot(data=file, aes(file[,2])) + geom_histogram(colour="green", breaks = bins, position = "identity") + xlab("Concentration (umol/mol creatinine)") + ylab("No. of metabolites")
#ggplot(data=file, aes(file[,2])) + geom_histogram(colour="green", breaks = bins, position = "identity") + xlab("Concentration (uM)") + ylab("No. of metabolites")

#file[,2] = log(file[,2], 10)
#print(file[,2])
#ggplot(data=file, aes(file[,2])) + geom_histogram(colour="green") + xlab("log (Concentration (umol/mol creatinine))") + ylab("No. of metabolites")
ggplot(data=file, aes(file[,1])) + geom_histogram(colour="green") + xlab("length of GT domain") + ylab("Seq. Count (Total 2694)")
# scale_x_log10(breaks=b, labels=b)
#b <- seq(min(file[,2]), max(file[,2]))

