#############################################################################
##
#W  scilab.gd               automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
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

