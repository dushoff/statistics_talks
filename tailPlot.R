library(shellpipes); manageConflicts()

library(ggplot2); theme_set(theme_bw(base_size=15))
startGraphics(height=5)

library(dplyr)
library(tidyr)

tails <- rdsRead()

box <- (ggplot(tails)
	+ aes(x=sex, y=tailLength)
	+ geom_boxplot()
	+ facet_wrap(~species)
	+ ylab("tail length (cm)")
)

print(box)

print(box + scale_y_log10())
