## This is the diversity subdirectory of stats talks; if it gets interesting, it should become its own repo

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Sources += $(wildcard *.R)

autopipeR = defined

functions.Rout: functions.R
	$(wrapR)

examples.Rout: examples.R functions.rda

######################################################################

## Pillaging

estimating.Rout: estimating.R
god.Rout: god.R
using.Rout: using.R

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

-include makestuff/pipeR.mk
-include makestuff/pdfpages.mk

-include makestuff/git.mk
-include makestuff/visual.mk
