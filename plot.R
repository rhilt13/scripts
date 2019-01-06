#!/usr/bin/env Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

savePlot <- function(myPlot) {
        svg("myPlot.svg")
        print(myPlot)
        dev.off()
}

for (i in 1:length(args)){
	table=read.table(file=args[i],header=FALSE,sep="\t")
	t <-as.data.frame.matrix(table)
	str(t)
	## Select numeric columns to work with
	# g_range<-range(0,table[4])
	# ls()
	# print(dim(table))
	# colnames(t) <- c("res","aln_pos","3let","pos","cons","asa","bsa","bsa_score","type1","type") 
	# colnames(t) <- c("species","group","proteome_size","kinase_ct","perkinome") 
	colnames(t) <- c("domain","seq","NoMut","NoRes","NoTotMut","MutPerRes","PerResPerMut") 
	print(names(t))
	# cols <- c("8" = "red", "4" = "blue", "6" = "darkgreen", "10" = "orange")
	# "GTA","Nup","Cdown","Nterm","Mterm","Cterm","motifs","H1","H2","H3"
	cols <- c("full"="yellow","GTA"="pink","Nup"="darkgreen","Cdown"="green","Nterm"="darkblue","Mterm"="blue","Cterm"="cyan","motifs"="magenta","H1"="brown","H2"="red","H3"="orange")
	num=seq(1, nrow(t), by=1)

######### GT-A Cancer mutation data #####################
	# ScatterPlot
	# plt <- ggplot(data=t,aes(x=num,y=MutPerRes)) + geom_point(aes(color=domain)) +
	#    		labs(x="Domains", y="# of Mutation Per Residue")+
	#    		# ggtitle("Per Residue Mutaions in GT-A sub domains")+
	#    		ggtitle("# of Per Residue Mutaions in GT-A sub domains")+
	#    		theme(plot.title = element_text(hjust = 0.5))+
	#    		theme(legend.text=element_text(size=14))+
	#    		scale_colour_manual(values=cols)

	# Boxplots
	plt <- boxplot(MutPerRes~domain,data=t, main="Per Residue Mutaions in GT-A sub-domains",xlab="Domains",ylab="# of Mutation Per Residue")
	# boxplot(cons~type,data=t, main="Conservation",xlab="Res",ylab="ConservationScore")
	t$domain <-factor(t$domain)
	# print(levels(t$V4)[1])
	# # print(levels(d$V4))
	tBI <- t[t$domain == "Buried" | t$domain == "Interface", ]
	# tBS <- t[t$type == "Buried" | t$type == "Surface", ]
	# tSI <- t[t$type == "Surface" | t$type == "Interface", ]
	tBIres <- t.test(tBI$MutPerRes~tBI$domain)
	# tBSres <- t.test(tBS$cons~tBS$type)
	# tSIres <- t.test(tSI$cons~tSI$type)
	print(tBIres)
	# print(tBSres)
	# print(tSIres)
	savePlot(plt)
################## End GT-A Figure #####################

####### Pseudokinase Fungal proteomes ##################


####### End ##

####### Template #####################
	# print(names(d))
	# print(t[2])
	# colors <- c("Ascomycota"="red",Basidiomycota"blue"."green","orange","brown","magenta")

	############# Line plot
	# plot(t[3], type="o", col="blue", ylim=g_range, axes="FALSE", ann="FALSE")


	############# Scatter plots
	# x<-data.frame(t[3],t[4])
	# plot(x, main="Fungi Proteome Vs Kinase",xlab="Proteome size", ylab="Kinome size", pch=19) 
	## Add fit line
	# abline(lm(t[4]~t[3]), col="red") # regression line (y~x)
	# lines(lowess(wt,mpg), col="blue") # lowess line (x,y) 
	# plt <- ggplot(data=t,aes(x=proteome_size,y=kinase_ct)) + geom_point(aes(color=group, size=perkinome)) +
 #   		labs(x="Proteome size", y="Kinome size")+
 #   		ggtitle("Fungi kinome distribution")+
 #   		theme(plot.title = element_text(hjust = 0.5))+
 #   		theme(legend.text=element_text(size=14))+
 #   		scale_size(range=c(0.2,2.5))+
 #   		scale_colour_manual(values=c("red","blue","green","orange","brown","magenta"))
		# scale_x_continuous(breaks = round(seq(min(dat$x), max(dat$x), by = 0.5),1)) +
  		# scale_y_continuous(breaks = round(seq(min(dat$y), max(dat$y), by = 0.5),1))
	# savePlot(plt)

	# Boxplots
	# boxplot(cons~type1,data=t, main="Conservation",xlab="Res",ylab="ConservationScore")
	# boxplot(cons~type,data=t, main="Conservation",xlab="Res",ylab="ConservationScore")
	# t$type <-factor(t$type)
	# print(levels(t$V4)[1])
	# # print(levels(d$V4))
	# tBI <- t[t$type == "Buried" | t$type == "Interface", ]
	# tBS <- t[t$type == "Buried" | t$type == "Surface", ]
	# tSI <- t[t$type == "Surface" | t$type == "Interface", ]
	# tBIres <- t.test(tBI$cons~tBI$type)
	# tBSres <- t.test(tBS$cons~tBS$type)
	# tSIres <- t.test(tSI$cons~tSI$type)
	# print(tBIres)
	# print(tBSres)
	# print(tSIres)
	# axis(1, at=1:5, lab=t"")
	# axis(2)#, las=2)
	# box()
	# title(main="Fuel",col.main="green",font.main="4")
	# title(xlab="Year")
	# title(ylab="Fuel consumption",font.ylab="2")
}

