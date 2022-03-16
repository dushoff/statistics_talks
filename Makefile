## This is statistics_talks
## https://github.com/dushoff/statistics_talks/commit/f4a0884c0fe075ed998577310088b8f91779c507

current: target

target = Makefile
-include target.mk
target: $(target)
-include makestuff/perl.def
-include makestuff/newtalk.def

##################################################################

vim_session:
	bash -cl "vmt"

Sources += Makefile README.md 

Drop = ~/Dropbox/Workshops/statistics_talks
Ignore += local.mk
-include local.mk

##################################################################

## Can this be temporary?
## 2019 Jan 23 (Wed): don't even remember when I made the above note ☺.

~/Dropbox/Permutation_tests/%:
	$(makethere)

######################################################################

## Why don't I use makethere more? Are there supposed to be aliases for it? I shouldn't be so deep

Disease_data/% fitting_code/%:
	$(makethere)

######################################################################

## Link to ICI3D materials (should this be a .mk?)

Ignore += materials
materials: dir = ~/Dropbox/ICI3D_Materials
materials:
	$(linkdirname)

######################################################################

## Exporting

%.lecture: %.handouts.pdf.op %.draft.pdf.op %.handouts.pdf.tod %.draft.pdf.tod ;

## Content

Makefile: | LatexTemplates
pardirs += LatexTemplates
pardirs += Disease_data fitting_code SIR_simulations WA_Ebola_Outbreak Endemic_curves Malaria hybrid_fitting
subdirs += visualization

Ignore += visualization/*

Ignore += $(pardirs)

######################################################################

## Local files (.tmp will be ephemeral unless you put it here)
Sources += beamer.tmp notes.tmp
Sources += ici3d.tmp ICI3D_logo.png

## Copyright not integrated into make system yet
Sources += copy.tex

######################################################################

## Lectures

Sources += $(wildcard *.txt) $(wildcard *.step)

#### Philosophy
## Moved here direct from Dropbox (NTU 2016).
## To do: figure out what you want from which column
## Using OTHER to mark things that are currently suppressed
## Currently versions for DAIDD, MMED, QMEE …

## Talk
## Merge stuff from clarity?
philosophy.final.pdf: philosophy.txt
philosophy.draft.pdf: philosophy.txt
philosophy.handouts.pdf: philosophy.txt
philosophy.push:

philosophy.html: philosophy.step

## Share qmee stuff
qmee_phil.%.pdf: philosophy.%.pdf
	$(copy)

qmee_phil: qmee_phil.handouts.pdf.op  qmee_phil.draft.pdf.op 

######################################################################

## Talk
birs_rant.outline.pdf: birs_rant.txt
birs_rant.final.pdf: birs_rant.txt
birs_rant.draft.pdf: birs_rant.txt
birs_rant.draft.tex: birs_rant.txt
birs_rant.handouts.pdf: birs_rant.txt
birs_rant.push:

#### Fitting
## Still needs more cleaning; and I need to have an alternative to recloning
## Likelihood fitting and dynamic models II; a long history at MMED, I guess
## Taught by Pearson (verbatim slides) 2018
## Not rescued yet. Check NOFIG problems *******************
fitting.final.pdf: fitting.txt
fitting.draft.pdf: fitting.txt
fitting.handouts.pdf: fitting.txt

## This talk originated at DAIDD 2015, and contains elements from the philosophy talk, as well as DAIDD-specific stuff.
## Called assessment at MMED.
## evaluation.final.pdf: evaluation.txt
## evaluation.slides.pdf: evaluation.txt
## evaluation.draft.pdf: evaluation.txt
## evaluation.handouts.pdf: evaluation.txt
## evaluation.lecture:

garki.draft.pdf: garki.txt

## Clarity
## First spun for the Mac Stats group January 2018
## Now trying for Chicago! October 2018
## Overlaps with philosophy, evaluation

clarity.final.pdf: clarity.txt
clarity.draft.pdf: clarity.txt
clarity.handouts.pdf: clarity.txt

## Overview
## Cobbled together viz thoughts (based on material from stat744)
## Actually, still living there

viz.final.pdf: viz.txt
viz.draft.pdf: viz.txt
viz.handouts.pdf: viz.txt

## Inference lecture Bellan ⇒ Pearson ⇒ Dushoff (given 2020)
## materials/current/Bellan_inference.pdf

Ignore += inference????.pdf
## Vaguely updated Bellan DAIDD slides
## ncw materials/current/Bellan_inference.pdf 
inference2021.pdf: materials/current/Bellan_inference.pdf my_images/inference2021.title.pdf 
	pdfjam --landscape -o $@  \
	$(word 2, $^) 1 \
	$(word 1, $^) 2-52 \
	$(word 1, $^) 56 \
	$(word 1, $^) 58-63 \

######################################################################

Ignore += effectPlots
colddirs += effectPlots
effectPlots/%: | effectPlots
effectPlots:
	$(LNF) ../../research/effects/manuscript/ $@

effects.draft.pdf: effects.txt
effects.final.pdf: effects.txt

######################################################################

## Biodiversity

hotdirs += diversity
alldirs += diversity
Ignore += diversity

## https://mikeroswell.github.io/MeanRarity/articles/Using_MeanRarity.html
Ignore += rarity_docs
rarity_docs:
	$(LN) ~/Dropbox/rarity $@

biodiversity.draft.pdf: biodiversity.txt

######################################################################

## Unused (using tablet to annotate!)
my_images/with.small.png: my_images/with.png 
	convert -scale 10% $< $@

%.image.pdf: my_images/%.png
	$(convert)

######################################################################

# Simple R scripts moved from CI_diagrams and Philosophy Lecture

Sources += $(wildcard *.R)

flu.Rout: ciplots.Rout 
masks.Rout: ciplots.Rout 
vitamins.Rout: ciplots.Rout

vitamins_data.Rout: vitamins_data.R
vitamins_plot.Rout: vitamins_data.Rout vitamins_plot.R

vitamins_scramble.Rout: permcount.Rout vitamins_data.Rout

##################################################################

## Diagrams

Ignore += distarrow*.pdf
Sources += distarrow.tex
distarrow.pdf: distarrow.tex

##################################################################

## rmd lectures
## Try to make it so other people can build
## Still need to work on rules for this (see QMEE?)
## WHy are there two copies???

## cleaning is now in QMEE

## Ignore += cleaning.html

## Sources += cleaning.rmd $(wildcard cleaning_data/*)

######################################################################

## Venues
## THEMES themes Themes
## Automatically change the format rules (but NOT the template (beamer.tmp))
## for different venues.
## mmed.set:
## daidd.set:
## qmee.set:
Ignore += local.txt.format
%.set: LatexTemplates/%.txt.format
	touch $<
	$(LNF) $< local.txt.format

## Also look at beamer.tmp for ICI3D fancy stuff

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk

-include makestuff/wrapR.mk
-include makestuff/newtalk.mk
-include makestuff/texi.mk
-include makestuff/pandoc.mk
-include makestuff/webpix.mk
-include makestuff/hotcold.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
