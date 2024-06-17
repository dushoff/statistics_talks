library(shellpipes)

groupSize <- 20
baseMean <- 0.03
sd <- 0.012
measDiff <- 0.0048

set.seed(0601)

treat <- rep(c("A", "B"), each=groupSize)
growth <- rnorm(2*groupSize, mean=baseMean, sd=sd)
length(treat)
length(growth)

ranDiff <- mean(growth[treat=="A"]) - mean(growth[treat=="B"])
growth[treat=="A"] <- growth[treat=="A"] - ranDiff + measDiff

data.frame(treat,  growth) |> rdsSave()

saveEnvironment()
