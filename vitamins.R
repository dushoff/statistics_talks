
means=c(0.013, 0.02, 0.0035)
Pvals=c(0.22, 0.06, 0.01)
xtags = c('Weight', 'Fat fold', 'Iron')
ylab = 'Proportional increase'

pcplot(
	means=means,
	Pvals=Pvals,
	xtags = xtags,
	ylab = ylab,
	showP=FALSE
)

pcplot(
	means=means,
	Pvals=Pvals,
	xtags = xtags,
	ylab = ylab,
	showP=TRUE
)
