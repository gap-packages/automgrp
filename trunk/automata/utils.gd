#############################################################################
##
#W  utils.gd                   automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##

Revision.utils_gd :=
  "@(#)$Id$";


DeclareOperation("CalculateWord", [IsAssocWord, IsList]);
DeclareOperation("CalculateWords", [IsList, IsList]);

DeclareGlobalFunction("ReducedSphericalIndex");
DeclareGlobalFunction("IsEqualSphericalIndex");
DeclareGlobalFunction("TopDegreeInSphericalIndex");
DeclareGlobalFunction("DegreeOfLevelInSphericalIndex");

DeclareGlobalFunction("TreeLevelTuples");


#E