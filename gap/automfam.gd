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
##  <#GAPDoc Label="AutomFamily">
##  <ManSection>
##  <Oper Name="AutomFamily" Arg="list [, names] [, bind_vars]"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="DualAutomFamily">
##  <ManSection>
##  <Attr Name="DualAutomFamily" Arg="fam"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="automfam:GroupOfAutomFamily">
##  <ManSection>
##  <Attr Name="GroupOfAutomFamily" Arg="fam"/>
##  <Attr Name="SemigroupOfAutomFamily" Arg="fam"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("GroupOfAutomFamily", IsAutomFamily);
DeclareAttribute("SemigroupOfAutomFamily", IsAutomFamily);


###############################################################################
##
#O  DiagonalPower(<fam>[, <k>])
##
##  <#GAPDoc Label="DiagonalPower">
##  <ManSection>
##  <Oper Name="DiagonalPower" Arg="fam[, k]"/>
##  <Description>
##  For a given automaton group <A>G</A> acting on alphabet <M>X</M> and corresponding family
##  <A>fam</A> of automata one can consider the action of <M>&lt;G&gt;^&lt;k&gt;</M> on <M>X^&lt;k&gt;</M> defined by
##  <M>(x_1,x_2,\ldots, x_k)^{(g_1,g_2,\ldots,g_k)}=(x_1^{g_1},x_2^{g_2},\ldots,x_k^{g_k})</M>.
##  This function constructs a self-similar group, which encodes this action. If
##  <A>k</A> is not given it is assumed to be <M>2</M>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> S := DiagonalPower(UnderlyingAutomFamily(Basilica));
##  < uu, uv, u1, vu, vv, v1, 1u, 1v >
##  gap> Decompose(uu);
##  (vv, v1, 1v, 1)(1,4)(2,3)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
KeyDependentOperation("DiagonalPower", IsAutomFamily, IsPosInt, ReturnTrue);


###############################################################################
##
#O  MultAutomAlphabet(<fam>)
##
##  <#GAPDoc Label="MultAutomAlphabet">
##  <ManSection>
##  <Oper Name="MultAutomAlphabet" Arg="fam"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
KeyDependentOperation("MultAutomAlphabet", IsAutomFamily, IsPosInt, ReturnTrue);

#############################################################################
##
#A  GeneratorsOfOrderTwo(<fam>)
##
##  <#GAPDoc Label="automfam:GeneratorsOfOrderTwo">
##  <ManSection>
##  <Attr Name="GeneratorsOfOrderTwo" Arg="fam"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("GeneratorsOfOrderTwo", IsAutomFamily);


#############################################################################
##
#A  UnderlyingFreeMonoid(<G>)
#A  UnderlyingFreeGroup(<G>)
##
##  <#GAPDoc Label="automfam:UnderlyingFreeMonoid">
##  <ManSection>
##  <Attr Name="UnderlyingFreeMonoid" Arg="G"/>
##  <Attr Name="UnderlyingFreeGroup" Arg="G"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("UnderlyingFreeMonoid", IsAutomFamily);
DeclareAttribute("UnderlyingFreeGroup", IsAutomFamily);


#E
