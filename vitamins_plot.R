library(ggplot2)
theme_set(theme_bw())

library(shellpipes)
loadEnvironments()
startGraphics()

set.seed(411)

vitamins <- data.frame(treat=treat, growth=growth)
summary(lm(growth~treat, data=vitamins))

samPlot <- function(scramble=FALSE){
	vitamins$treatment <- vitamins$treat
	if(scramble){
		vitamins$treatment <- sample(treat)
	} 
	with(vitamins, 
		print(diff <- mean(growth[treatment=="A"]) - 
			mean(growth[treatment=="B"]))
	)
	print(ggplot(vitamins, aes(x=treatment, y=growth, colour=treat))
		+ geom_point(size=3.8)
		+ theme(text = element_text(size=20))
		+ xlab("Treatment")
		+ ylab("Proportonal growth")
	)
}

samPlot()
samPlot(TRUE)
samPlot(TRUE)
samPlot(TRUE)
samPlot(TRUE)


