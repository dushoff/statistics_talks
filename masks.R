library(shellpipes)
loadEnvironments()

means=c(1.011, 1.018)
Pvals=c(0.342, 0.025)
xtags = c("Pilot", "Full study")
ylab = 'Odds ratio of infection'
xlab = "New mask vs. big mask"
crit=1.05

pcplot(
	means=means,
	Pvals=Pvals,
	xtags=xtags,
	xlab=xlab,
	ylab=ylab,
	crit=crit,
	showP=FALSE
)

p <- pcplot(
	means=means,
	Pvals=Pvals,
	xtags=xtags,
	xlab=xlab,
	ylab=ylab,
	crit=crit,
	showP=TRUE
)

pcplot(
	means=means,
	err=p$err,
	xtags=xtags,
	xlab=xlab,
	ylab=ylab,
	crit=1
)

