reps <- 1999
set.seed(0612)

dFun <- function(scramble=FALSE){
	if (scramble){
		treat <- sample(treat)
	}
	return(mean(height[treat=="A"]) - mean(height[treat=="B"]))
}

diff <- dFun()

diffList <- replicate(reps, dFun(TRUE))
permhist(diffList, diff)

