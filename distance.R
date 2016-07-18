par(cex=1.5)

dcurve <- function(f){
	curve(f, from=-1, to=1, 
		xlab="Difference", ylab="Penalty", axes=FALSE, col="blue"
	)
	abline(h=0)
	abline(v=0)
}

dcurve(function(x){return(x)})
dcurve(function(x){return(abs(x))})
dcurve(function(x){return(x^2)})
