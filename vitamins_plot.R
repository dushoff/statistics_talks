library(ggplot2)
theme_set(theme_bw())
set.seed(411)

vitamins <- data.frame(treat=treat, height=height)
summary(lm(height~treat, data=vitamins))

samPlot <- function(scramble=FALSE){
	vitamins$faketreat <- vitamins$treat
	if(scramble){
		vitamins$faketreat <- sample(treat)
	} 
	with(vitamins, 
		print(diff <- mean(height[faketreat=="A"]) - 
			mean(height[faketreat=="B"]))
	)
	p <- ggplot(vitamins, aes(faketreat, height))
	p + geom_point()+aes(colour=treat)
}

samPlot()
samPlot(TRUE)
samPlot(TRUE)
samPlot(TRUE)
samPlot(TRUE)
