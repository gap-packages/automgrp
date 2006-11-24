#############################################################################
##
#W  automfam.gd              automata package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#O  AutomFamily(<list>)
#O  AutomFamily(<list>, <names>)
#O  AutomFamilyNoBindGlobal(<list>)
#O  AutomFamilyNoBindGlobal(<list>, <names>)
##
DeclareOperation("AutomFamily", [IsList, IsList]);
DeclareOperation("AutomFamilyNoBindGlobal", [IsList, IsList]);


###############################################################################
##
#A  DualAutomFamily(<fam>)
##
DeclareAttribute("DualAutomFamily", IsAutomFamily);


###############################################################################
##
#A  One(<fam>)
##
DeclareAttribute("One", IsAutomFamily);


###############################################################################
##
#O  ComputedRelatorsOfAutomFamily(<fam>)
##
DeclareOperation("ComputedRelatorsOfAutomFamily", [IsAutomFamily]);


###############################################################################
##
#A  AbelImagesGenerators(<fam>)
##
DeclareAttribute("AbelImagesGenerators", IsAutomFamily);


###############################################################################
##
#O  DiagonalAction(<fam>)
##
KeyDependentOperation("DiagonalAction", IsAutomFamily, IsPosInt, ReturnTrue);


###############################################################################
##
#O  MultAutomAlphabet(<fam>)
##
KeyDependentOperation("MultAutomAlphabet", IsAutomFamily, IsPosInt, ReturnTrue);



#E
