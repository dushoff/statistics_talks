# statistics_lectures
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: evaluation.draft.pdf 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md notes.txt
include stuff.mk
-include $(ms)/newtalk.def

##################################################################

## Content

Sources += local.txt.format

## Copyright not integrated into make system yet
Sources += copy.tex

Sources += $(wildcard *.txt)

## Moved here direct from Dropbox. Developing for NTU.
## To do: figure out what you want from which column
philosophy.final.pdf: philosophy.txt
philosophy.draft.pdf: philosophy.txt
philosophy.handouts.pdf: philosophy.txt

## Moved here from ICI3D/lectures -- clean up!
fitting.final.pdf: fitting.txt
fitting.draft.pdf: fitting.txt
fitting.handouts.pdf: fitting.txt

## Now moving (maybe) during DAIDD 2016 (also from lectures)
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

-include $(ms)/git.mk
-include $(ms)/visual.mk

## newtalk should be first of these three; want to make stuff in other directories by going there using newtalk, not by trying to project rules from here
-include $(ms)/newtalk.mk
-include $(ms)/newlatex.mk
-include $(ms)/wrapR.mk
