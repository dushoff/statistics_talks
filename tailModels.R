library(shellpipes); manageConflicts()

tails <- rdsRead()

lin <- lm(tailLength ~ species*sex
	, data=tails
)
summary(lin)

prop <- lm(log(tailLength) ~ species*sex
	, data=tails
)
summary(prop)

scale <- lm(tLz ~ species*sex
	, data=tails
)
summary(scale)

