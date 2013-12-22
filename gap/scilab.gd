#############################################################################
##
#W  scilab.gd               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.2.2
##
#Y  Copyright (C) 2003 - 2013 Yevgen Muntyan, Dmytro Savchuk
##
##  Declarations of functions using SciLab
##


###############################################################################
##
#F  PlotSpectraPermsInScilab(<perms>, <perm_deg>, <round>, <stacksize>, <output_file>)
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
#O  PlotSpectraInScilab(<G>, <level>[, <opts>])
#O  PlotSpectraInScilab(<elms>, <level>[, <opts>])
##
##  Plots the spectra of the Markov operator in Scilab. Does not add inverses.
##  <elms> is a list of automata.
##
DeclareOperation("PlotSpectraInScilab", [IsObject, IsPosInt]);
DeclareOperation("PlotSpectraInScilab", [IsObject, IsPosInt, IsRecord]);


#E
