#############################################################################
##
#W  selfsimfam.gd            automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#O  SelfSimFamily(<list> [, <names>] [, <bind_vars>])
##
##  <#GAPDoc Label="SelfSimFamily">
##  <ManSection>
##  <Oper Name="SelfSimFamily" Arg="list [, names] [, bind_vars]"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("SelfSimFamily", [IsList]);
DeclareOperation("SelfSimFamily", [IsList, IsBool]);
DeclareOperation("SelfSimFamily", [IsList, IsList]);
DeclareOperation("SelfSimFamily", [IsList, IsList, IsBool]);

# XXX
#DeclareAttribute("RecurList", IsSelfSimFamily);
#DeclareAttribute("GeneratingRecurList", IsSelfSimFamily);



################################################################################
###
##A  One(<fam>)
###
##DeclareAttribute("One", IsSelfSimFamily);



#############################################################################
##
#A  GroupOfSelfSimFamily(<fam>)
#A  SemigroupOfSelfSimFamily(<fam>)
##
##  <#GAPDoc Label="selfsimfam:GroupOfSelfSimFamily">
##  <ManSection>
##  <Attr Name="GroupOfSelfSimFamily" Arg="fam"/>
##  <Attr Name="SemigroupOfSelfSimFamily" Arg="fam"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("GroupOfSelfSimFamily", IsSelfSimFamily);
DeclareAttribute("SemigroupOfSelfSimFamily", IsSelfSimFamily);



#############################################################################
##
#A  UnderlyingFreeMonoid(<fam>)
#A  UnderlyingFreeGroup(<fam>)
##
##  <#GAPDoc Label="selfsimfam:UnderlyingFreeMonoid">
##  <ManSection>
##  <Attr Name="UnderlyingFreeMonoid" Arg="fam"/>
##  <Attr Name="UnderlyingFreeGroup" Arg="fam"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("UnderlyingFreeMonoid", IsSelfSimFamily);
DeclareAttribute("UnderlyingFreeGroup", IsSelfSimFamily);


#############################################################################
##
#P  IsObviouslyFiniteState(<G>)
##
##  <#GAPDoc Label="IsObviouslyFiniteState">
##  <ManSection>
##  <Prop Name="IsObviouslyFiniteState" Arg="G"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsObviouslyFiniteState", IsSelfSimFamily);


#############################################################################
##
#A  GeneratorsOfOrderTwo(<fam>)
##
##  <#GAPDoc Label="selfsimfam:GeneratorsOfOrderTwo">
##  <ManSection>
##  <Attr Name="GeneratorsOfOrderTwo" Arg="fam"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("GeneratorsOfOrderTwo", IsSelfSimFamily);


###############################################################################
##
##  AG_AbelImagesGenerators(<fam>)
##
DeclareAttribute("AG_AbelImagesGenerators", IsSelfSimFamily);


#E
