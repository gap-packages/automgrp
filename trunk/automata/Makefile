pkgname = automgrp
pkgver  = 1.0
distdir = $(pkgname)
# archive = $(pkgname)-`date +%Y%m%d%H%M`
archive = $(pkgname)-$(pkgver)

top_files =			\
    init.g			\
    read.g			\
    PackageInfo.g		\
    README

gap_files =			\
    gap/automaton.gd		\
    gap/automaton.gi		\
    gap/automfam.gd		\
    gap/automfam.gi		\
    gap/autom.gd		\
    gap/autom.gi		\
    gap/automgroup.gd		\
    gap/automgroup.gi		\
    gap/automsg.gd		\
    gap/automsg.gi		\
    gap/globals.g		\
    gap/listops.gd		\
    gap/listops.gi		\
    gap/parser.g		\
    gap/rws.gd			\
    gap/rws.gi			\
    gap/selfs.gd		\
    gap/selfs.gi		\
    gap/selfsim.gd		\
    gap/selfsim.gi		\
    gap/selfsimfam.gd		\
    gap/selfsimfam.gi		\
    gap/selfsimgroup.gd		\
    gap/selfsimgroup.gi		\
    gap/selfsimsg.gd		\
    gap/selfsimsg.gi		\
    gap/tree.gd			\
    gap/tree.gi			\
    gap/treeaut.gd		\
    gap/treeaut.gi		\
    gap/treeautgrp.gd		\
    gap/treeautgrp.gi		\
    gap/treehomsg.gd		\
    gap/treehomsg.gi		\
    gap/treehom.gd		\
    gap/treehom.gi		\
    gap/utilsfrgrp.gd		\
    gap/utilsfrgrp.gi		\
    gap/utils.gd		\
    gap/utils.gi

tst_files =			\
    tst/testall.g		\
    tst/testcontr.g		\
    tst/testexternal.g		\
    tst/testiter.g		\
    tst/testmanual.g		\
    tst/testorder.g		\
    tst/testselfsim.g		\
    tst/teststructures.g	\
    tst/testiter.g		\
    tst/testmisc.g		\
    tst/testutil.g

all:

docs:
	cd doc && make

distdir:
	(rm -fr $(distdir) && mkdir -p $(distdir)/gap && mkdir -p $(distdir)/tst && \
	  cp $(top_files) $(distdir) && \
	  cp $(gap_files) $(distdir)/gap && \
	  cp $(tst_files) $(distdir)/tst && \
	 cd doc && make dist distdir=../$(distdir)) || rm -fr $(distdir)
dist:
	rm -f $(pkgname)-*.tar.bz2 $(pkgname)-*.tar.gz $(pkgname)-*.zip && \
	make distdir && \
	tar cjf $(archive).tar.bz2 $(distdir) && \
	tar czf $(archive).tar.gz $(distdir) && \
	mv $(distdir)/doc/manual.pdf manual.pdf && zip -lr $(archive)-win.zip $(distdir) && \
	  mv manual.pdf $(distdir)/doc/manual.pdf && zip $(archive)-win.zip $(distdir)/doc/manual.pdf && \
	rm -fr $(distdir)

clean:
	rm -rf $(pkgname)-*.tar.bz2 $(pkgname)-*.tar.gz $(pkgname)-*.zip $(distdir)
	cd doc && make clean
