library(ggplot2)
library(reshape)
library(lattice)
library(plyr)
setwd('/Users/rtaujale/GT/gta_revise12/analysis/AllFamIndels')

table=read.table(file='allFamHVs.e3.e3',header=FALSE,sep="\t",nrows=611638)
t <-as.data.frame.matrix(table)
str(t)
######### GT-A Indel data #####################
# colnames(t) <- c("Tax","Phylum","Fam","TotalInsert","#OfInserts","AvgInsertSize","Insert_Size","Deletions","Sum") 
colnames(t) <- c("Fam","ID","Species","Phylum","Kingdom","DomLen","HV1","HV2","HV3","Nterm","Cterm","FullLen","Tax","Mechanism") 
num=seq(1, nrow(t), by=1)
t$Fam <- factor(t$Fam,levels = c('GT75','GT7','GT2-CHS','GT2-Rham-GlfT','GT2-B3GntL','GT2-Class1','GT27','GT60','GT2-LpsRelated','GT82','GT62','GT40','GT2-DPs','GT81','GT78','GT55','GT21','GT2-Chitin-HAS','GT2-CellWall','GT2-CeS','GT84','GT2-Bre3','GT64','GT45','GT15','GT54','GT12','GT49','GT43','GT13','GT16','GT25','GT32','GT67','GT31-Euk','GT31-Galt-Gnt','GT31-Chsy','GT31-Glt','GT31-Fringe','GT14','GT17','GT6','GT77','GT8-Fun','GT8-Glycogenin','GT34','GT8-GAUT','GT8-GATL','GT8-Lrg','GT8-XylT','GT88','GT24','GT8-LpsGlt'),ordered = TRUE)
t$Fam <- factor(t$Fam,levels = rev(levels(t$Fam)),ordered = TRUE)
t$Tax <- factor(t$Tax,levels = c('Prokaryotes','Protista','Fungi','Chlorophyta','NonChordata','Chordata','Streptophyta'),ordered = TRUE)

# Plot distribution of lengths of specific regions as family specific boxplots
plt <- ggplot(t, aes(x=Fam, y=Cterm, fill=Mechanism)) + 
  geom_boxplot(width = 0.6, outlier.size=0.02) + #
  scale_y_continuous(limits=c(0,1000)) +
#  coord_cartesian(ylim = c(0, 200)) +
  coord_flip() #+ 
  # theme_bw(base_size = 12, base_family = "Helvetica")
plt + facet_grid(cols=vars(Tax))
plt 

# Plot distribution of lengths separated by families using boxplots
plt2 <- ggplot(t, aes(x=Fam, y=Cterm, fill=Mechanism)) + 
  geom_boxplot(width = 0.6, outlier.size=0.02) +
  scale_y_continuous(limits=c(0,500)) +
  coord_flip()
plt2

# Plot distribution of length using histograms
ggplot(t, aes(x=Tax)) + 
  geom_histogram(binwidth=.5, colour="darkgray",fill="white") +
  #scale_x_continuous(limits=c(0,500)) +
  theme_minimal() +
  labs(x = "GT-A domain length", y = "No. of sequences") #+
  #geom_density(alpha=.3)

# Plot counts of tax for each family
t1<- table(t$Fam)
counts <- ddply(t, .(t$Fam, t$Tax), nrow)
names(counts) <- c("Fam", "Tax", "Freq")
counts$Tax <- factor(counts$Tax,levels = c('Prokaryotes','Protista','Fungi','Chlorophyta','NonChordata','Chordata','Streptophyta'),ordered = TRUE)

ggplot(counts, aes(fill=Tax, y=Freq, x=Fam)) + 
  geom_bar( stat="identity", position="fill") +
  coord_flip()

ggplot(t, aes(x=Tax)) + 
  geom_bar( stat="identity", position="fill")

ggplot(counts, aes(x=Tax, y=Freq))+
  geom_bar(width=0.7, fill="steelblue")

# If need to remove some values
t1<-t[!(t$HV1 >50),]
