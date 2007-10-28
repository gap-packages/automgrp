#############################################################################
##
#W  scilab.gd               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.0
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##
##  Declarations of functions using SciLab
##


###############################################################################
##
#F  PlotSpectraPermsInScilab(<perms>, <perm_deg>[, <round>[, <stacksize>]])
##
##  Writes the <perms> as matrices into a file in Scilab format, and makes
##  Scilab compute and plot the spectra of resulting Markov operator (namely,
##  the average of the matrices).
##  <round> is a magical number, 7 by default. <stacksize> is another magical
##  number which might need to be used if Scilab can't handle the matrices:
##  the default is some 10000000; increase it if Scilab reports an error about
##  stack size or something.
##
DeclareGlobalFunction("PlotSpectraPermsInScilab");


###############################################################################
##
#O  PlotSpectraInScilabAddInverses(<G>, <level>[, <round>])
#O  PlotSpectraInScilabAddInverses(<gens>, <level>[, <round>])
##
##  Plots the spectra of the Markov operator in Scilab. Adds inverses of
##  generators.
##
DeclareOperation("PlotSpectraInScilabAddInverses", [IsObject, IsPosInt, IsPosInt]);


###############################################################################
##
#O  PlotSpectraInScilab(<G>, <level>[, <round>])
#O  PlotSpectraInScilab(<elms>, <level>[, <round>])
##
##  Plots the spectra of the Markov operator in Scilab. Does not add inverses.
##  <elms> is a list of automata.
##
DeclareOperation("PlotSpectraInScilab", [IsObject, IsPosInt, IsPosInt]);


#E
