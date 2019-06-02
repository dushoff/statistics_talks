# statistics_talks

current: target

target = Makefile
-include target.mk
target: $(target)

##################################################################

# make files

Sources += Makefile README.md 

Drop = ~/Dropbox/Workshops/statistics_talks
Ignore += local.mk
-include local.mk

ms = makestuff
-include $(ms)/os.mk
-include $(ms)/newtalk.def
-include $(ms)/perl.def
Sources += $(ms)

$(ms)/%.mk: $(ms)/Makefile ;
$(ms)/Makefile: 
	git submodule update -i

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

## Exporting

%.push: %.handouts.pdf.gp %.draft.pdf.gp ;

## Content

## New paradigm 2018 Dec 19 (Wed):
## Lots of pardirs: mdirs only for serious production (like what, even?)

mdirs += LatexTemplates
pardirs += Disease_data fitting_code SIR_simulations WA_Ebola_Outbreak Endemic_curves Malaria hybrid_fitting
subdirs += visualization

Ignore += visualization/*

Ignore += $(pardirs)

######################################################################

## Local files (.tmp will be ephemeral unless you put it here)
Sources += local.txt.format beamer.tmp notes.tmp

Sources += local.txt.format
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
philosophy.final.pdf: philosophy.txt
philosophy.draft.pdf: philosophy.txt
philosophy.handouts.pdf: philosophy.txt
philosophy.push:

philosophy.html: philosophy.step

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
## Called assessment now?
evaluation.final.pdf: evaluation.txt
evaluation.draft.pdf: evaluation.txt
evaluation.handouts.pdf: evaluation.txt
evaluation.push: evaluation.txt

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

Ignore += cleaning.html

Sources += cleaning.rmd $(wildcard cleaning_data/*)

######################################################################


## Venues

## Rules under development; need to look at beamer.tmp (manually, for now)

## Oops, forgot about this. Redo.
## 2019 May 29 (Wed) That's an alarming note probably from long ago.

## Automatically change the format rules (but not the template)
## for different venues.
## mmed.set:
Sources += mmed.txt.format daidd.txt.format qmee.txt.format
%.set: %.txt.format
	$(LNF) $< local.txt.format

######################################################################

-include $(ms)/visual.mk

# -include $(ms)/modules.mk
-include $(ms)/webpix.mk

-include $(ms)/newtalk.mk
-include $(ms)/texdeps.mk
-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk

-include $(ms)/git.mk

######################################################################
