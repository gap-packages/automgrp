#############################################################################
##
#W  utils.gd                   automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


DeclareOperation("AG_CalculateWord", [IsAssocWord, IsList]);
DeclareOperation("AG_CalculateWords", [IsList, IsList]);

DeclareGlobalFunction("AG_ReducedSphericalIndex");
DeclareGlobalFunction("AG_IsEqualSphericalIndex");
DeclareGlobalFunction("AG_TopDegreeInSphericalIndex");
DeclareGlobalFunction("AG_DegreeOfLevelInSphericalIndex");

DeclareGlobalFunction("AG_TreeLevelTuples");
DeclareGlobalFunction("AG_ParseAutomatonString");

DeclareGlobalVariable("AG_AbelImageX");
DeclareGlobalVariable("AG_AbelImageSpherTrans");


#############################################################################
##
##  AG_AbelImageAutomatonInList(<list>)
##
##  Returns list of images of the automaton states under the canonical
##  projection onto \mathbb{Z}^\mathbb{N}.
##
DeclareGlobalFunction("AG_AbelImageAutomatonInList");


DeclareGlobalFunction("AG_IsInvertibleTransformation");
DeclareGlobalFunction("AG_PermFromTransformation");
DeclareGlobalFunction("AG_PrintTransformation");


#E
