
library(shellpipes)
loadEnvironments()

means=c(50, 19, 12)
Pvals=c(0.018, 0.038, 0.882)
xtags = c('Flu A', 'Flu B', 'Weather')
ylab = 'Attributable Deaths (per 10,000)'

pcplot(
	means=means,
	Pvals=Pvals,
	xtags = xtags,
	ylab = ylab,
	showConf=FALSE
)

pcplot(
	means=means,
	Pvals=Pvals,
	xtags = xtags,
	ylab = ylab,
	showConf=TRUE
)
