groupSize <- 20
baseMean <- 95
logcv <- 0.04
measDiff <- 1.52

set.seed(0601)

treat <- rep(c("A", "B"), each=groupSize)
height <- rlnorm(2*groupSize, meanlog=log(baseMean), sdlog=logcv)
length(treat)
length(height)

ranDiff <- mean(height[treat=="A"]) - mean(height[treat=="B"])
height[treat=="A"] <- height[treat=="A"] - ranDiff + measDiff
