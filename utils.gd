#############################################################################
##
#W  utils.gd                   automata package                Yevgen Muntyan
##                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
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