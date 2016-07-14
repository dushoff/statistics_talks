
ci <- function(means, Pvals, alpha=0.05){
	return(means*qnorm(alpha/2)/qnorm(Pvals/2))
}

pcplot <- function(means, Pvals,crit=0,  
	xlab="", ylab="", main="", xtags=NULL,
	showP=TRUE, showConf=TRUE,
	cx=1.4, stretch=1.1, lift=sqrt(stretch), err=NULL
){
	n <- length(means)

	par(cex.lab = cx, cex.axis = cx, cex = cx, cex.main = cx)
	cols <- rainbow(n)

	if(is.null(err)){
		err <- ci(means-crit, Pvals)
	} else {
		showP <- FALSE ## Would need to recalculate
	}

	up <- means+err
	down <- means-err

	xs <- (1:n)-0.5
	ylim=stretch*(range(c(up, down, crit))-crit)+crit
	plot(NULL,
		type = 'n', xlim = c(0,n), ylim=ylim,
		xlab=xlab, ylab=ylab, xaxt = 'n', bty = 'n',
		main = main
	)
	abline(h = crit, lwd = 2)
	points(xs, means, pch = 19, col = cols)
	axis(1, at = xs, xtags)
	if(showConf)
	{
		arrows(xs, down, xs, up,
			lwd = 2, col = cols,
			angle = 90, length = 0.1, code=3
		)
	}

	if(showP){
		text(xs, lift*max(up), Pvals)
	}

	return(data.frame(means, err, up, down))
}
