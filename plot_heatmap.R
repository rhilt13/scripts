#!/usr/bin/env Rscript

library(gplots)
library(RColorBrewer)

args <- commandArgs(trailingOnly=TRUE)
data <- read.csv(args[1])
rnames <- data[,1]
# cnames <- data[1,2]
mat_data <- data.matrix(data[,2:ncol(data)])
# print(mat_data)
# print(rnames)
rownames(mat_data) <- rnames 
# colnames(mat_data) <- cnames 
# print (cnames)
distance = dist(mat_data, method = "euclidian")
# print(distance)
cluster = hclust(distance, method = "ward")

# heatmap(mat_data)
print(args[2])
# my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 299)
col_breaks=0:10
# creates a 10 x 10 inch image
# png(args[2],    # create PNG for the heat map        
#   width = 5*1000,        # 5 x 300 pixels
#   height = 5*1000,
#   res = 500,            # 300 pixels per inch
#   pointsize = 11)        # smaller font size
# Create an svg file
svg(args[2],    # create PNG for the heat map        
  width = 5,        # 5 x 300 pixels
  height = 5,
  # res = 500,            # 300 pixels per inch
  pointsize = 3)        # smaller font size
heatmap.2(mat_data,
  # cellnote = mat_data,  # same data set for cell labels
  main = "RMS distance", # heat map title
  notecol="black",      # change font color of cell labels to black
  density.info="none",  # turns off density plot inside color legend
  trace="none",         # turns off trace lines inside the heat map
  margins =c(12,9),     # widens margins around plot
  # col=my_palette,       # use on color palette defined earlier
 breaks=col_breaks,    # enable color transition at specified limits
  # dendrogram="row",     # only draw a row dendrogram
  # Rowv="TRUE",#"NA",
  # Rowv = as.dendrogram(cluster),
  Colv = as.dendrogram(cluster))
  # Colv="TRUE")#NA")            # turn off column clustering
# )
dev.off()               # close the PNG device