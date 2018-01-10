# statistics_lectures

current: target
target = Makefile
-include target.mk
target: $(target)

##################################################################

# make files

Sources = Makefile .ignore README.md sub.mk LICENSE.md notes.txt

Drop = ~/Dropbox
include sub.mk

-include $(ms)/newtalk.def

##################################################################

## Content

mdirs += LatexTemplates Disease_data Endemic_curves fitting_code hybrid_fitting Lecture_images SIR_simulations WA_Ebola_Outbreak

Sources += $(mdirs)

## Local files (.tmp will be ephemeral unless you put it here)
Sources += local.txt.format beamer.tmp notes.tmp

Sources += local.txt.format
Sources += ici3d.tmp ICI3D_logo.png

## Copyright not integrated into make system yet
Sources += copy.tex

######################################################################

## Lectures

Sources += $(wildcard *.txt)

## Moved here direct from Dropbox (NTU 2016).
## To do: figure out what you want from which column
## Using OTHER to mark things that are currently suppressed
philosophy.final.pdf: philosophy.txt
philosophy.draft.pdf: philosophy.txt
philosophy.handouts.pdf: philosophy.txt

philosophy.draft.tex: philosophy.txt

## Still needs more cleaning; and I need to have an alternative to recloning
fitting.final.pdf: fitting.txt
fitting.draft.pdf: fitting.txt
fitting.handouts.pdf: fitting.txt

## This talk originated at DAIDD 2015, and contains elements from the philosophy talk, as well as DAIDD-specific stuff.
## Called assessment now?
evaluation.final.pdf: evaluation.txt
evaluation.draft.pdf: evaluation.txt
evaluation.handouts.pdf: evaluation.txt

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

## Drop stuff (see disease_model_talks notes)

## Point to Drop parent in local.mk
Sources += jd.local
jd:
	$(CP) jd.local local.mk

web_drop/%: 
	$(MAKE) web_drop
	cd Lecture_images && $(MAKE) files/$*

web_drop:
	$(MAKE) Lecture_images
	$(LNF) $(Drop)/Lecture_images $@

# my_images/%: my_images ;
my_images:
	$(LN) $(Drop)/$@ .

######################################################################

Sources += mmed.txt.format daidd.txt.format 
mmedset:
	$(CP) mmed.txt.format local.txt.format

daiddset:
	$(CP) daidd.txt.format local.txt.format

######################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/modules.mk

-include $(ms)/newtalk.mk
-include $(ms)/texdeps.mk
-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk
