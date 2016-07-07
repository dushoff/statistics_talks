# statistics_lectures
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: fitting.draft.pdf 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
include $(ms)/newtalk.def

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
Archive += philosophy.draft.pdf

## Moved here from ICI3D/lectures -- clean up!
fitting.final.pdf: fitting.txt
fitting.draft.pdf: fitting.txt
fitting.handouts.pdf: fitting.txt

##################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

## newtalk should be first of these three; want to make stuff in other directories by going there.
-include $(ms)/newtalk.mk
-include $(ms)/newlatex.mk
# -include $(ms)/wrapR.mk
