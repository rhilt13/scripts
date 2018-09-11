#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

for (i in 1:length(args)){
	t=read.table(file=args[i],header=FALSE,sep="")
	# d <-as.data.frame.matrix(table)
	## Select numeric columns to work with
	# g_range<-range(0,table[4])
	# ls()
	# print(dim(table))
	colnames(t) <- c("res","aln_pos","3let","pos","cons","asa","bsa","bsa_score","type1","type") 
	# colnames(t) <- c("aln_pos","res","cons","type") 
	print(names(t))
	# print(names(d))
	# print(table[3])
	# plot(table[3], type="o", col="blue", ylim=g_range, axes="FALSE", ann="FALSE")
	boxplot(cons~type1,data=t, main="Conservation",xlab="Res",ylab="ConservationScore")
	boxplot(cons~type,data=t, main="Conservation",xlab="Res",ylab="ConservationScore")
	t$type <-factor(t$type)
	print(levels(t$V4)[1])
	# print(levels(d$V4))
	tBI <- t[t$type == "Buried" | t$type == "Interface", ]
	tBS <- t[t$type == "Buried" | t$type == "Surface", ]
	tSI <- t[t$type == "Surface" | t$type == "Interface", ]
	tBIres <- t.test(tBI$cons~tBI$type)
	tBSres <- t.test(tBS$cons~tBS$type)
	tSIres <- t.test(tSI$cons~tSI$type)
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

