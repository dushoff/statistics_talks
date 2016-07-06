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

Sources += $(wildcard *.txt)

philosophy.draft.pdf: philosophy.txt

fitting.draft.pdf: fitting.txt

##################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

## newtalk should be first of these three; want to make stuff in other directories by going there.
-include $(ms)/newtalk.mk
-include $(ms)/newlatex.mk
# -include $(ms)/wrapR.mk
