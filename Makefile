# statistics_lectures

current: target

target pngtarget pdftarget vtarget acrtarget: philosophy.draft.pdf 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md notes.txt
include stuff.mk
-include $(ms)/newtalk.def

##################################################################

pushdir = $(gitroot)/notebook/materials

## Content

Sources += local.txt.format
Sources += ici3d.tmp ICI3D_logo.png

ici3d:
	/bin/ln -fs ici3d.tmp beamer.tmp

## Copyright not integrated into make system yet
Sources += copy.tex

Sources += $(wildcard *.txt)

## Moved here direct from Dropbox. Developing for NTU.
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

vitamins_plot.Rout: vitamins_data.Rout 

vitamins_scramble.Rout: permcount.Rout vitamins_data.Rout

##################################################################

## Directories

## Temp rules here if needed`

Lecture_images:
	ln -s ~/Dropbox/courses/$@/ .

my_images:
	ln -s ~/Dropbox/$@/ .

##################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

## newtalk should be first of these three; want to make stuff in other directories by going there using newtalk, not by trying to project rules from here
-include $(ms)/newtalk.mk
-include $(ms)/newlatex.mk
-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk
