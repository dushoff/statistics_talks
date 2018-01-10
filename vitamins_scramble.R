reps <- 1999
set.seed(0612)

dFun <- function(scramble=FALSE){
	if (scramble){
		treat <- sample(treat)
	}
	return(mean(growth[treat=="A"]) - mean(growth[treat=="B"]))
}

diff <- dFun()

diffList <- replicate(reps, dFun(TRUE))
permhist(diffList, diff)

