# statistics_talks

current: target

target = Makefile
-include target.mk
target: $(target)

##################################################################

# make files

Sources = Makefile .ignore README.md sub.mk LICENSE.md notes.txt

## Change this in local.mk if you want
Drop = ~/Dropbox/Workshops/statistics_talks
include sub.mk

-include $(ms)/newtalk.def
-include $(ms)/perl.def
-include $(ms)/repos.def

##################################################################

## Transition
## webpix not tested for gaps after transition

##################################################################

## Exporting

%.push: %.handouts.pdf.gp %.draft.pdf.gp ;

## Content

mdirs += LatexTemplates Disease_data Endemic_curves fitting_code hybrid_fitting SIR_simulations WA_Ebola_Outbreak

Sources += $(mdirs)

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

## Talk
philosophy.final.pdf: philosophy.txt
philosophy.draft.pdf: philosophy.txt
philosophy.draft.tex: philosophy.txt
philosophy.handouts.pdf: philosophy.txt
philosophy.push:

philosophy.html: philosophy.step

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

## Clarity
## First spun for the Mac Stats group January 2018

clarity.final.pdf: clarity.txt
clarity.draft.pdf: clarity.txt
clarity.handouts.pdf: clarity.txt

repodirs:
	@echo $(repodirs)

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

######################################################################

## Directories

Sources += distarrow.tex
distarrow.pdf: distarrow.tex

##################################################################

## Venues
## Rules under development; need to look at beamer.tmp (manually, for now)

Sources += mmed.txt.format daidd.txt.format 
mmedset:
	$(CP) mmed.txt.format local.txt.format

daiddset:
	$(CP) daidd.txt.format local.txt.format

######################################################################

-include $(ms)/visual.mk

-include $(ms)/modules.mk
-include $(ms)/webpix.mk

-include $(ms)/newtalk.mk
-include $(ms)/texdeps.mk
-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk

-include $(ms)/git.mk
