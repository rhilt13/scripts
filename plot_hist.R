#!/usr/bin/env Rscript

library(ggplot2)
data <- read.csv(args[1])
print(data)
# data <- as.double(data)

d<- density(data)
plot(d)

# ggplot(data,aes(x=data$1))+
#   geom_histogram(aes(y=stat(count/sum(count))),
#                  binwidth=10,
#                  fill = "lightgray",
#                  color = "black")+
#   labs(x="Depth",y="Proportion",title="Depth of Coverage distribution- red set")
