#############################################################################
##
#W  automfam.gd              automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#O  AutomFamily(<list> [, <names>] [, <bind_vars>])
##
DeclareOperation("AutomFamily", [IsList]);
DeclareOperation("AutomFamily", [IsList, IsBool]);
DeclareOperation("AutomFamily", [IsList, IsList]);
DeclareOperation("AutomFamily", [IsList, IsList, IsBool]);

# XXX
DeclareAttribute("AutomatonList", IsAutomFamily);
DeclareAttribute("GeneratingAutomatonList", IsAutomFamily);


###############################################################################
##
#A  DualAutomFamily(<fam>)
##
DeclareAttribute("DualAutomFamily", IsAutomFamily);


################################################################################
###
##A  One(<fam>)
###
### DeclareAttribute("One", IsAutomFamily);


###############################################################################
##
##  AG_AbelImagesGenerators(<fam>)
##
DeclareAttribute("AG_AbelImagesGenerators", IsAutomFamily);


#############################################################################
##
#A  GroupOfAutomFamily(<fam>)
#A  SemigroupOfAutomFamily(<fam>)
##
DeclareAttribute("GroupOfAutomFamily", IsAutomFamily);
DeclareAttribute("SemigroupOfAutomFamily", IsAutomFamily);


###############################################################################
##
#O  DiagonalPower(<fam>[, <k>])
##
##  For a given automaton group <G> acting on alphabet $X$ and corresponding family
##  <fam> of automata one can consider the action of $<G>^<k>$ on $X^<k>$ defined by
##  $(x_1,x_2,\ldots, x_k)^{(g_1,g_2,\ldots,g_k)}=(x_1^{g_1},x_2^{g_2},\ldots,x_k^{g_k})$.
##  This function constructs a self-similar group, which encodes this action. If
##  <k> is not given it is assumed to be $2$.
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> S := DiagonalPower(UnderlyingAutomFamily(Basilica));
##  < uu, uv, u1, vu, vv, v1, 1u, 1v >
##  gap> Decompose(uu);
##  (vv, v1, 1v, 1)(1,4)(2,3)
##  \endexample
##
KeyDependentOperation("DiagonalPower", IsAutomFamily, IsPosInt, ReturnTrue);


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
