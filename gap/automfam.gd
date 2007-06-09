#############################################################################
##
#W  automfam.gd              automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#O  AutomFamily(<list>[, <names>])
#O  AutomFamilyNoBindGlobal(<list>[, <names>])
##
DeclareOperation("AutomFamily", [IsList]);
DeclareOperation("AutomFamily", [IsList, IsList]);
DeclareOperation("AutomFamilyNoBindGlobal", [IsList]);
DeclareOperation("AutomFamilyNoBindGlobal", [IsList, IsList]);

# XXX
DeclareAttribute("AutomatonList", IsAutomFamily);
DeclareAttribute("GeneratingAutomatonList", IsAutomFamily);


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
#A  AbelImagesGenerators(<fam>)
##
DeclareAttribute("AbelImagesGenerators", IsAutomFamily);


#############################################################################
##
#A  GroupOfAutomFamily(<fam>)
#A  SemigroupOfAutomFamily(<fam>)
##
DeclareAttribute("GroupOfAutomFamily", IsAutomFamily);
DeclareAttribute("SemigroupOfAutomFamily", IsAutomFamily);


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

#############################################################################
##
#A  GeneratorsOfOrderTwo(<fam>)
##
DeclareAttribute("GeneratorsOfOrderTwo", IsAutomFamily);


#############################################################################
##
#A  UnderlyingFreeMonoid(<G>)
#A  UnderlyingFreeGroup(<G>)
##
DeclareAttribute("UnderlyingFreeMonoid", IsAutomFamily);
DeclareAttribute("UnderlyingFreeGroup", IsAutomFamily);


#E
