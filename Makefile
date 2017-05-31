# statistics_lectures

current: target
target = Makefile
-include target.mk
target: $(target)

##################################################################

# make files

Sources = Makefile .gitignore README.md sub.mk LICENSE.md notes.txt
include sub.mk
Drop = ~/Dropbox

-include $(ms)/newtalk.def

##################################################################

## Submodules

##################################################################

# pushdir = $(gitroot)/notebook/materials

## Content

Sources += LatexTemplates

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

## Moved here from ICI3D/lectures -- clean up!
## Not all directories are installed everywhere. Serious work is needed on machinery for this repo. A good candidate for sub-modules.
fitting.final.pdf: fitting.txt
fitting.draft.pdf: fitting.txt
fitting.handouts.pdf: fitting.txt

## This talk originated at DAIDD 2015, and contains elements from the philosophy talk, as well as DAIDD-specific stuff.
## It should maybe
evaluation.final.pdf: evaluation.txt
evaluation.draft.pdf: evaluation.txt
evaluation.handouts.pdf: evaluation.txt

######################################################################

# Simple R scripts moved from CI_diagrams and Philosophy Lecture; should be documented, and may need make rules

Sources += $(wildcard *.R)

flu.Rout: ciplots.Rout 
masks.Rout: ciplots.Rout 
vitamins.Rout: ciplots.Rout

vitamins_data.Rout: vitamins_data.R
vitamins_plot.Rout: vitamins_data.Rout vitamins_plot.R

vitamins_scramble.Rout: permcount.Rout vitamins_data.Rout

##################################################################

## Directories

##################################################################

## Drop stuff (see disease_model_talks notea)s

web_drop/%: web_drop ;
web_drop:
	$(LNF) $(Drop)/courses/Lecture_images $@

my_images/%: my_images ;
my_images:
	$(LN) $(Drop)/$@ .

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/modules.mk

-include $(ms)/newtalk.mk
-include $(ms)/newlatex.mk
-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk
