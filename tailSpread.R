library(shellpipes); manageConflicts()

library(ggplot2); theme_set(theme_bw(base_size=15))
startGraphics(height=5)

library(dplyr)
library(tidyr)

tails <- rdsRead()

spreadPlot <- function(dat){
	s <- (dat
		|> summarize(
			m = mean(tailLength)
			, stdev = sd(tailLength)
			, .by=sex
		)
		|> mutate(stderr=stdev/sqrt(nrow(dat)))
		|> pivot_longer(c(stdev, stderr), names_to="Measure", values_to="spread")
		|> rename(tailLength = m)
		|> mutate(Measure=factor(Measure, levels=c("stdev", "stderr")))
	)
	return(
		ggplot(s)
		+ aes(x=sex, y=tailLength, ymin=tailLength-spread, ymax=tailLength+spread)
		+ geom_errorbar()
		+ facet_wrap(~Measure)
		+ ylab("tail length (cm)")
	)
}

ele <- tails |> filter(species=="Elephant")
spreadPlot(ele |> filter(id<= 20))
spreadPlot(ele)
