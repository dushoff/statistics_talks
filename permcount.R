permp <- function(l, v, test="two.tailed", Ptarget=0.05, warn=0.01, useObs=TRUE){
	bigval <- length(which(l<=v))
	smallval <- length(which(l>=v))

	vals <- length(l)
	extval <- NULL
	tails <- 1

	if (grepl("less", test, ignore.case=TRUE))
		extval<-smallval
	if (grepl("great", test, ignore.case=TRUE))
		extval<-bigval
	if (grepl("two", test, ignore.case=TRUE))
	{
		extval <- min(c(bigval, smallval))
		tails <- 2
	}
	if (is.null(extval))
		stop(paste("Unrecognized test", test, "in permp"))

	self <- ifelse(useObs, 1, 0)
	P = min(1, tails*(self+extval)/(self+vals))
	r = list(val=v, perm_mean=mean(l), perm_median=median(l), P=P)


	if(!is.null(Ptarget)){
		Ptest <- Ptarget/tails
		naprop <- mean(is.na(l))
		if (naprop>=Ptest){
			return(c(r, Ptarget=Ptarget, PP=NA))
		}

		Pq <- (Ptest-naprop)/(1-naprop)

		qlist <- c(Pq, 1/2, 1-Pq)
		# Should eliminate something from qlist for one-tailed tests

		r <- c(r, quantile(v-l, probs=qlist, na.rm=TRUE))

		PP <- prop.test(extval, vals, Ptest, alternative="less")$p.value
		r <- c(r, list(Ptarget=Ptarget, PP=PP))
		# if(!is.null)(warn)
	}
	return(r)
}

permhist <- function(l, v=NULL,
	aheight=0.4, aoffset=0, awidth=2, main="", xlab="values",
	label="left", cex=1,
	obs="Observed", test="two.tailed", dp=4, useObs=TRUE
){
	fh <- hist(c(l, v), plot=FALSE)
	vh <- hist(v, breaks=fh$breaks, plot=FALSE)
	fh$counts = fh$counts - vh$counts
	vheight <- sum(fh$counts*vh$counts)
	hheight <- max(fh$counts)
	y1 <- vheight+aoffset*hheight
	y0 <- y1+aheight*hheight
	plot(fh,
		ylim=c(0, max(y0, hheight)),
		main=main, xlab=xlab,
		cex=cex, cex.lab=cex, cex.axis=cex
	)

	P <- if (test!=""){
		permp(l, v, test, useObs=useObs)$P
	} else -1
	if(label=="none") label=0
	if(label=="left") label=2
	if(label=="right") label=4
	if(!is.null(v)){
		arrows(v, y0, v, y1, lwd=awidth)
		if(label>0){
			if(obs!="") obs<-paste(obs, "\n", sep="")
			if(P>=0) obs<-paste(obs, "P = ", round(P, dp), sep="")
			if(obs!="") text(v, (y0+y1)/2, obs, pos=label)
		}
	}
}
