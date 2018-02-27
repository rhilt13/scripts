#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

for (i in 1:length(args)){
	t=read.table(file=args[i],header=FALSE,sep="")
	# d <-as.data.frame.matrix(table)
	## Select numeric columns to work with
	# g_range<-range(0,table[4])
	# ls()
	# print(dim(table))
	print(names(t))
	# print(names(d))
	# print(table[3])
	# plot(table[3], type="o", col="blue", ylim=g_range, axes="FALSE", ann="FALSE")
	# boxplot(V3~V4,data=table, main="Conservation",xlab="Res",ylab="ConservationScore")
	t$V4 <-factor(t$V4)
	print(levels(t$V4)[1])
	# print(levels(d$V4))
	tBI <- t[t$V4 == "Buried" | t$V4 == "Interface", ]
	tBS <- t[t$V4 == "Buried" | t$V4 == "Surface", ]
	tSI <- t[t$V4 == "Surface" | t$V4 == "Interface", ]
	tBIres <- t.test(tBI$V3~tBI$V4)
	tBSres <- t.test(tBS$V3~tBS$V4)
	tSIres <- t.test(tSI$V3~tSI$V4)
	print(tBIres)
	print(tBSres)
	print(tSIres)
	# axis(1, at=1:5, lab=t"")
	# axis(2)#, las=2)
	# box()
	# title(main="Fuel",col.main="green",font.main="4")
	# title(xlab="Year")
	# title(ylab="Fuel consumption",font.ylab="2")
}

