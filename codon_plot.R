
args <- commandArgs(TRUE)

table=read.table(file=args[1],header=FALSE,sep="")
# print(table)
g_range<-range(0,table[4])
plot(table[3], type="o", col="blue", ylim=g_range, axes="FALSE", ann="FALSE")
axis(1, at=1:5, lab=t"")
axis(2)#, las=2)
box()
title(main="Fuel",col.main="green",font.main="4")
title(xlab="Year")
title(ylab="Fuel consumption",font.ylab="2")