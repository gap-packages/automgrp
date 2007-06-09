#############################################################################
##
#W  utils.gd                   automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


DeclareOperation("CalculateWord", [IsAssocWord, IsList]);
DeclareOperation("CalculateWords", [IsList, IsList]);

DeclareGlobalFunction("ReducedSphericalIndex");
DeclareGlobalFunction("IsEqualSphericalIndex");
DeclareGlobalFunction("TopDegreeInSphericalIndex");
DeclareGlobalFunction("DegreeOfLevelInSphericalIndex");

DeclareGlobalFunction("TreeLevelTuples");

DeclareGlobalFunction("ParseAutomatonString");


BindGlobal("$AutomataAbelImageIndeterminate", Indeterminate(GF(2), "x"));
BindGlobal("AutomataAbelImageSpherTrans",
  One($AutomataAbelImageIndeterminate)/
    (One($AutomataAbelImageIndeterminate)+$AutomataAbelImageIndeterminate));

#############################################################################
##
#F  AbelImageAutomatonInList(<list>)
##
##  Returns list of images of the automaton states under the canonical
##  projection onto \mathbb{Z}^\mathbb{N}.
##
DeclareGlobalFunction("AbelImageAutomatonInList");


DeclareGlobalFunction("AG_IsInvertibleTransformation");
DeclareGlobalFunction("AG_PermFromTransformation");
DeclareGlobalFunction("AG_PrintTransformation");


#E
