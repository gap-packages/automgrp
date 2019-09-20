#############################################################################
##
#W  utils.gd                   automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


DeclareOperation("AG_CalculateWord", [IsAssocWord, IsList]);
DeclareOperation("AG_CalculateWords", [IsList, IsList]);

DeclareGlobalFunction("AG_ReducedSphericalIndex");
DeclareGlobalFunction("AG_IsEqualSphericalIndex");
DeclareGlobalFunction("AG_TopDegreeInSphericalIndex");
DeclareGlobalFunction("AG_DegreeOfLevelInSphericalIndex");

DeclareGlobalFunction("AG_TreeLevelTuples");

DeclareGlobalVariable("AG_AbelImageXvar");
MakeReadWriteGlobal("AG_AbelImageXvar");
DeclareGlobalFunction("AG_AbelImageX");
DeclareGlobalFunction("AG_AbelImageSpherTrans");


# implemented in parser.g
DeclareGlobalFunction("AG_ParseAutomatonString");
DeclareGlobalFunction("AG_ParseAutomatonStringFR");


#############################################################################
##
##  AG_AbelImageAutomatonInList(<list>)
##
##  Returns list of images of the automaton states under the canonical
##  projection onto \mathbb{Z}^\mathbb{N}.
##
DeclareGlobalFunction("AG_AbelImageAutomatonInList");

DeclareGlobalFunction("AG_PermFromTransformation");
DeclareGlobalFunction("AG_PrintTransformation");
DeclareGlobalFunction("AG_TransformationString");
DeclareGlobalFunction("AG_TrCmp");


#E
