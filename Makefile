top_files =			\
    init.g			\
    read.g			\
    PackageInfo.g

gap_files =			\
    gap/automaton.gd		\
    gap/automaton.gi		\
    gap/automfam.gd		\
    gap/automfam.gi		\
    gap/autom.gd		\
    gap/autom.gi		\
    gap/automgroup.gd		\
    gap/automgroup.gi		\
    gap/globals.g		\
    gap/listops.gd		\
    gap/listops.gi		\
    gap/rws.gd			\
    gap/rws.gi			\
    gap/scilab.gd		\
    gap/scilab.gi		\
    gap/selfs.gd		\
    gap/selfs.gi		\
    gap/tree.gd			\
    gap/tree.gi			\
    gap/treeaut.gd		\
    gap/treeaut.gi		\
    gap/treeautgrp.gd		\
    gap/treeautgrp.gi		\
    gap/treehomsg.gd		\
    gap/treehom.gd		\
    gap/treehom.gi		\
    gap/utilsfrgrp.gd		\
    gap/utilsfrgrp.gi		\
    gap/utils.gd		\
    gap/utils.gi

scilab_files =				\
    scilab/calcnplot.sci		\
    scilab/get_inverses.sci		\
    scilab/iter_autmats.sci		\
    scilab/plot.sci			\
    scilab/plot_spec_round.sci		\
    scilab/plot_spec.sci		\
    scilab/PlotSpectraPermsInScilab.sci	\
    scilab/plot_spectra.sci

tst_files =			\
    tst/testall.g		\
    tst/testorder.g		\
    tst/teststructures.g	\
    tst/testutil.g

all:

docs:
	cd doc && make

distdir = automata
distdir:
	(rm -fr $(distdir) && mkdir -p $(distdir)/gap && mkdir -p $(distdir)/scilab && mkdir -p $(distdir)/tst && \
	  cp $(top_files) $(distdir) && \
	  cp $(gap_files) $(distdir)/gap && \
	  cp $(scilab_files) $(distdir)/scilab && \
	  cp $(tst_files) $(distdir)/tst && \
	 cd doc && make dist distdir=../$(distdir)) || rm -fr $(distdir)
dist:
	rm -f automata.tar.bz2 automata.tar.gz automata.zip && \
	make distdir && \
	tar cjf automata.tar.bz2 $(distdir) && \
	tar czf automata.tar.gz $(distdir) && \
	zip -r automata.zip $(distdir) && \
	rm -fr $(distdir)

clean:
	rm -rf automata.tar.bz2 automata.tar.gz automata.zip $(distdir)
	cd doc && make clean