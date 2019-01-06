library(ggplot2)
data <- read.csv("~/DP_1-1")
ggplot(data,aes(x=data$DP_1.1))+
  geom_histogram(aes(y=stat(count/sum(count))),
                 binwidth=10,
                 fill = "lightgray",
                 color = "black")+
  labs(x="Depth",y="Proportion",title="Depth of Coverage distribution- red set")
