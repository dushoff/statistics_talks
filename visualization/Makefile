
## Code moved from clunky stat744 repo
## Haven't moved talk here yet
## Trying to step!

current: target
-include target.mk

##################################################################

## Defs

Sources += Makefile

ms = makestuff
Ignore += makestuff

Makefile: makestuff
	touch $@
makestuff:
	ls ../makestuff/Makefile && /bin/ln -s ../makestuff 

-include makestuff/os.mk

######################################################################

Sources += $(wildcard *.R)

Ignore += cache
cache/fev.csv: 
	wget -O $@ "http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/FEV.csv"

######################################################################

## Stuff is being brought from stat744
## More to be done, and link to viz lecture in ../

## Bikes

## Crib
.PRECIOUS: %.R
%.R: /home/dushoff/gitroot/stat744/lectures/%.R
	$(copy)

cache/bikes.zip:
	wget -O $@ https://archive.ics.uci.edu/ml/machine-learning-databases/00275/Bike-Sharing-Dataset.zip

Ignore += day.csv hour.csv bikes.zip
hour.csv: bikes.zip
	unzip $< $@
	touch $@

Sources += bike_weather.csv
## bikes.Rout: bikes.R
## bike_plots.Rout: bike_plots.R

######################################################################

## Smoking example

## Read in data
## smoke.Rout: smoke.R

## Conflation plots (no unconflation, just capacity and then age)
## smoke_ques.Rout: smoke_ques.R

## fits (with area example)
## smoke_plots.Rout: smoke_plots.R

## Level plots (example of color choices)
## smoke_levels.Rout: smoke_levels.R

### Makestuff
-include makestuff/stepR.mk
-include makestuff/cache.mk

-include makestuff/git.mk
-include makestuff/visual.mk

