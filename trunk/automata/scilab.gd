#############################################################################
##
#W  scilab.gd               automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v0.9, started 01/22/2004
##
##  Declarations of functions using SciLab
##

Revision.globals_g :=
  "@(#)$Id$";


###############################################################################
##
#F  PlotSpectraPermsInScilab(<perms>, <round>)
##
DeclareGlobalFunction("PlotSpectraPermsInScilab");


###############################################################################
##
#O  PlotSpectraInScilabAddInverses(<obj>, <level>, <round>)
##
DeclareOperation("PlotSpectraInScilabAddInverses", [IsObject, IsPosInt, IsPosInt]);












# DeclareOperation("PlotAutomatonSpectraInScilab", [IsList, IsInt, IsInt]);
#E

