
## Code moved from clunky stat744_0 repo
## Haven't moved talk here yet
## Trying to step!

current: target
-include target.mk

##################################################################

## Defs

Sources += Makefile

ms = makestuff
Ignore += $(ms)
Makefile: $(ms)/Makefile
	touch $@
$(ms)/Makefile:
	ls ../makestuff/Makefile && /bin/ln -s ../makestuff 

-include $(ms)/os.mk
-include local.mk

######################################################################

Sources += $(wildcard *.R)

Ignore += cache
cache/fev.csv: 
	wget -O $@ "http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/FEV.csv"

## smoke.Rout: smoke.R
## smoke_levels.Rout.pdf: smoke_levels.R

### Makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include makestuff/stepR.mk
-include makestuff/cache.mk

