# statistics_lectures

current: target
target = Makefile
-include target.mk
target: $(target)

##################################################################

## MS 2 (Gamma approximations)
dirs += Lecture_images fitting_code Disease_data hybrid_fitting SIR_simulations Endemic_curves

dfiles: $(dirs:%=%/Makefile)
Sources += $(ms) $(dirs)

######################################################################

# make files

Sources += Makefile .gitignore README.md sub.mk LICENSE.md notes.txt
## Change this in local.mk
Drop = ~/Dropbox
include sub.mk
my_images = $(Drop)/my_images

-include $(ms)/newtalk.def

##################################################################

## Content

Sources += LatexTemplates makestuff

Sources += local.txt.format
Sources += ici3d.tmp ICI3D_logo.png

## Copyright not integrated into make system yet
Sources += copy.tex

Sources += $(wildcard *.txt)

## Moved here direct from Dropbox (NTU 2016).
## To do: figure out what you want from which column
## Using OTHER to mark things that are currently suppressed
philosophy.final.pdf: philosophy.txt
philosophy.draft.pdf: philosophy.txt
philosophy.handouts.pdf: philosophy.txt

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

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/modules.mk
-include $(ms)/images.mk

-include $(ms)/newtalk.mk
-include $(ms)/newlatex.mk
-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk
