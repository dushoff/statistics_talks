## This is statistics_talks

current: target

target = Makefile
-include target.mk
target: $(target)
-include makestuff/perl.def
-include makestuff/newtalk.def

##################################################################

latexEngine = xelatex

vim_session:
	bash -cl "vmt"

Sources += Makefile README.md 
Sources += $(wildcard *.md)

imageDrop = ~/Dropbox/Workshops/statistics_talks
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

## effects.lecture:
%.lecture: %.handouts.pdf.op %.draft.pdf.op %.handouts.pdf.tod %.draft.pdf.tod ;

## Content

pardirs += LatexTemplates
pardirs += Disease_data fitting_code SIR_simulations WA_Ebola_Outbreak Endemic_curves Malaria hybrid_fitting effectPlots notebook sandbox

Ignore += $(pardirs)

## Hot or cold??
colddirs += $(pardirs)

## This is a repo subdir; not clear why
subdirs += visualization
Ignore += visualization/*

######################################################################

## Local files (.tmp will be ephemeral unless you put it here)
## This is stupid: go upstream and make these into precious links
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
## mmed questions are called .mm as a legacy from Faikah's mentimeter
## philosophy.mm

philosophy.final.pdf: philosophy.txt philosophy.md
philosophy.slides.pdf: philosophy.txt philosophy.md
philosophy.draft.pdf: philosophy.txt philosophy.md
## philosophy.now.pdf: philosophy.txt
philosophy.handouts.pdf: philosophy.txt
W1D3_Dushoff_StatPhil.pdf: | philosophy.draft.pdf
	$(lnp)

philosophy.push:

philosophy.html: philosophy.step

## Share qmee stuff
qmee_phil.%.pdf: philosophy.%.pdf
	$(copy)

qmee_phil: qmee_phil.handouts.pdf.op  qmee_phil.draft.pdf.op 

## qmee_phil.final.pdf: philosophy.txt

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
## evaluation.mm.tsv: evaluation.mm
W2D3_Dushoff_Assessment.pdf: evaluation.draft.pdf
	$(copy)

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

## A summary presentation for DAIDD 2022: What is science ⇒ stats

fitSummary.draft.pdf: fitSummary.txt
fitSummary.final.pdf: fitSummary.txt

######################################################################

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

## rarity_docs/RoswellHakai.pdf

biodiversity.draft.pdf: biodiversity.txt
biodiversity.final.pdf: biodiversity.txt

biodiversity.html: biodiversity.step

######################################################################

Ignore += road_map25.pdf
road_map25.pdf: $(wildcard my_images/road_map25.pdf)
	pdfjam $< 1 --landscape --outfile $@

## Unused (using tablet to annotate!)
my_images/with.small.png: my_images/with.png 
	convert -scale 10% $< $@

%.image.pdf: my_images/%.png
	$(convert)

######################################################################

# Simple R scripts moved from CI_diagrams and Philosophy Lecture

autopipeR = defined
Sources += $(wildcard *.R)

flu.Rout: ciplots.rda 
masks.Rout: ciplots.rda 
vitamins.Rout: ciplots.rda

vitamins_data.Rout: vitamins_data.R

vitamins_plot.Rout: vitamins_plot.R vitamins_data.rda

vitamins_scramble.Rout: permcount.rda vitamins_data.rda

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

## Reproducibility

######################################################################

## Horrible (MMED24)

Sources += $(wildcard *.mm)
Ignore += *.mm.tsv
%.mm.tsv: %.mm $(wildcard)../*/mentimeter.pl
	$(PUSH)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile | LatexTemplates
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk

-include makestuff/pipeR.mk
-include makestuff/pdfpages.mk
-include makestuff/newtalk.mk
-include makestuff/texj.mk
-include makestuff/pandoc.mk
-include makestuff/webpix.mk
-include makestuff/hotcold.mk

-include makestuff/git.mk
-include makestuff/visual.mk
