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
DeclareAttribute("GroupOfSelfSimFamily", IsSelfSimFamily);
DeclareAttribute("SemigroupOfSelfSimFamily", IsSelfSimFamily);



#############################################################################
##
#A  UnderlyingFreeMonoid(<fam>)
#A  UnderlyingFreeGroup(<fam>)
##
DeclareAttribute("UnderlyingFreeMonoid", IsSelfSimFamily);
DeclareAttribute("UnderlyingFreeGroup", IsSelfSimFamily);


#############################################################################
##
#P  IsObviouslyFiniteState(<G>)
##
DeclareProperty("IsObviouslyFiniteState", IsSelfSimFamily);


#############################################################################
##
#A  GeneratorsOfOrderTwo(<fam>)
##
DeclareAttribute("GeneratorsOfOrderTwo", IsSelfSimFamily);


###############################################################################
##
##  AG_AbelImagesGenerators(<fam>)
##
DeclareAttribute("AG_AbelImagesGenerators", IsSelfSimFamily);


#E
