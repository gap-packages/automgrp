#############################################################################
##
#W  scilab.gd               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##
##  Declarations of functions using SciLab
##


###############################################################################
##
#F  PlotSpectraPermsInScilab(<perms>, <perm_deg>, <round>, <stacksize>)
##
DeclareGlobalFunction("PlotSpectraPermsInScilab");


###############################################################################
##
#O  PlotSpectraInScilabAddInverses(<obj>, <level>, <round>)
##
DeclareOperation("PlotSpectraInScilabAddInverses", [IsObject, IsPosInt, IsPosInt]);


# DeclareOperation("PlotAutomatonSpectraInScilab", [IsList, IsInt, IsInt]);
#E
