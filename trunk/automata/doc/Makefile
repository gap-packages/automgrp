msk_files =		\
    automgroup.msk	\
    automlist.msk	\
    autom.msk		\
    data.msk		\
    intro.msk		\
    treeautgrp.msk

tex_files =		\
    automgroup.tex	\
    automlist.tex	\
    autom.tex		\
    data.tex		\
    intro.tex		\
    treeautgrp.tex

dist_files =		\
    manual.pdf

all: pdf htm dvi

dvi: manual
manual: manual-stamp
manual-stamp: $(msk_files) manual.tex
	./buildman.pe -f buildman.config && \
	tex manual &&  \
	bibtex manual && \
	tex manual && tex manual && \
	./manualindex manual && \
	tex manual && \
	date > manual-stamp

pdf: pdf-stamp
pdf-stamp: manual.pdf
	date > pdf-stamp
manual.pdf: manual-stamp
	pdftex manual

htm: htm-stamp
htm-stamp: manual-stamp
	mkdir -p ../htm && \
	./convert.pl -c -t -n automgrp . ../htm && \
	date > htm-stamp

dist: pdf htm
	mkdir -p $(distdir)/doc $(distdir)/htm && \
	cp $(dist_files) $(distdir)/doc/ && \
	cp ../htm/* $(distdir)/htm/

clean:
	rm -f *.six *.blg *.ind *.ilg *.log *.dvi *.toc *.idx *.aux *.lab *.bbl *.pdf \
		$(tex_files) notfound *-stamp tthout tthmacros.tex
	rm -fr ../htm
