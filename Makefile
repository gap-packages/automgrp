top_files =			\
    init.g			\
    read.g			\
    PackageInfo.g

gap_files =			\
    gap/automatagroup.gd	\
    gap/automatagroup.gi	\
    gap/automaton.gd		\
    gap/automaton.gi		\
    gap/automatonobj.gd		\
    gap/automatonobj.gi		\
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
    gap/treeaut.gd		\
    gap/treeaut.gi		\
    gap/treeautgrp.gd		\
    gap/treeautgrp.gi		\
    gap/treeautobj.gd		\
    gap/treeautobj.gi		\
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

distdir:
	(rm -fr automata && mkdir -p automata/gap && mkdir -p automata/scilab && mkdir -p automata/tst && \
	  cp $(top_files) automata/ && \
	  cp $(gap_files) automata/gap && \
	  cp $(scilab_files) automata/scilab && \
	  cp $(tst_files) automata/tst && \
	 cd doc && make dist distdir=../automata) || rm -fr automata
dist:
	rm -f automata.tar.bz2 automata.tar.gz automata.zip && \
	make distdir && \
	tar cjf automata.tar.bz2 automata/ && \
	tar czf automata.tar.gz automata/ && \
	zip -r automata.zip automata/ && \
	rm -fr automata
