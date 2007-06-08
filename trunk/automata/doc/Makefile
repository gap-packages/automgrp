msk_files =     \
    groups.msk  \
    automlist.msk   \
    autom.msk       \
    data.msk        \
    intro.msk       \
    elements.msk  \
    manual.msk

tex_files =     \
    automgroup.tex  \
    automlist.tex   \
    autom.tex       \
    data.tex        \
    intro.tex       \
    treeautgrp.tex  \
    manual.tex

g_files =                       \
    ../gap/automaton.gd       ../gap/automaton.gi   \
    ../gap/automfam.gd        ../gap/automfam.gi    \
    ../gap/autom.gd       ../gap/autom.gi       \
    ../gap/automgroup.gd      ../gap/automgroup.gi  \
    ../gap/listops.gd         ../gap/listops.gi     \
    ../gap/rws.gd         ../gap/rws.gi     \
    ../gap/scilab.gd          ../gap/scilab.gi      \
    ../gap/selfs.gd       ../gap/selfs.gi       \
    ../gap/treeaut.gd         ../gap/treeaut.gi     \
    ../gap/treeautgrp.gd      ../gap/treeautgrp.gi  \
    ../gap/tree.gd        ../gap/tree.gi        \
    ../gap/treehom.gd         ../gap/treehom.gi     \
    ../gap/treehomsg.gd                 \
    ../gap/treehom.gd         ../gap/treehom.gi     \
    ../gap/utilsfrgrp.gd      ../gap/utilsfrgrp.gi  \
    ../gap/utils.gd       ../gap/utils.gi       \
    ../gap/globals.g

dist_files =        \
    manual.pdf      \
    $(tex_files)    \
    manual.six

all: pdf htm dvi

dvi: manual
manual: .manual-stamp
.manual-stamp: $(msk_files) $(g_files) buildman.config
    ./buildman.pe -f buildman.config && \
    tex manual &&  \
    bibtex manual && \
    tex manual && \
    ./manualindex manual && \
    tex manual && \
    date > .manual-stamp

pdf: .pdf-stamp
.pdf-stamp: .manual-stamp
    pdftex manual && pdftex manual && \
    date > .pdf-stamp

htm: .htm-stamp
.htm-stamp: .manual-stamp
    mkdir -p ../htm && \
    ./convert.pl -c -t -n automgrp . ../htm && \
    date > .htm-stamp

dist: pdf htm
    mkdir -p $(distdir)/doc $(distdir)/htm && \
    cp $(dist_files) $(distdir)/doc/ && \
    cp ../htm/* $(distdir)/htm/

clean:
    rm -f *.blg *.ind *.ilg *.log *.dvi *.toc *.idx *.aux *.lab *.bbl *.pdf \
        $(tex_files) notfound .*-stamp tthout tthmacros.tex
    rm -fr ../htm
