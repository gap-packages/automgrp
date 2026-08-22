#############################################################################
##
#W  scilab.gd               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##
##  Declarations of functions using SciLab
##


###############################################################################
##
#F  PlotSpectraPermsInScilab(<perms>, <perm_deg>, <round>, <stacksize>, <output_file>)
##
##  <#GAPDoc Label="PlotSpectraPermsInScilab">
##  <ManSection>
##  <Func Name="PlotSpectraPermsInScilab" Arg="perms, perm_deg, round, stacksize, output_file"/>
##  <Description>
##  Writes the <A>perms</A> as matrices into a file in Scilab format, and makes
##  Scilab compute and plot the spectra of resulting Markov operator (namely,
##  the average of the matrices).
##  <A>round</A> is a magical number, 7 by default. <A>stacksize</A> is another magical
##  number which might need to be used if Scilab can't handle the matrices:
##  the default is some 10000000; increase it if Scilab reports an error about
##  stack size or something.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("PlotSpectraPermsInScilab");


###############################################################################
##
#O  PlotSpectraInScilab(<G>, <level>[, <opts>])
#O  PlotSpectraInScilab(<elms>, <level>[, <opts>])
##
##  <#GAPDoc Label="PlotSpectraInScilab">
##  <ManSection>
##  <Oper Name="PlotSpectraInScilab" Arg="G, level[, opts]"/>
##  <Oper Name="PlotSpectraInScilab" Label="for elms, level[, opts]" Arg="elms, level[, opts]"/>
##  <Description>
##  Plots the spectra of the Markov operator in Scilab. Does not add inverses.
##  <A>elms</A> is a list of automata.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("PlotSpectraInScilab", [IsObject, IsPosInt]);
DeclareOperation("PlotSpectraInScilab", [IsObject, IsPosInt, IsRecord]);


#E
