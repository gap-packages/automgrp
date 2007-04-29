#############################################################################
##
#W  treehomsg.gd             automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeHomomorphismSemigroup
##
##  Category of semigroups of tree homomorphisms.
##
DeclareSynonym("IsTreeHomomorphismSemigroup", IsSemigroup and IsTreeHomomorphismCollection);
InstallTrueMethod(IsActingOnTree, IsTreeHomomorphismSemigroup);


###############################################################################
##
#P  IsSelfSimilar (<G>)
##
##  Whether semigroup <G> is "self-similar".
##
DeclareProperty("IsSelfSimilar", IsTreeHomomorphismSemigroup and IsActingOnRegularTree);
DeclareFilter("CanEasilyTestSelfSimilarity");
InstallTrueMethod(CanEasilyTestSelfSimilarity, HasIsSelfSimilar);


# XXX
DeclareAttribute("AutomatonList", IsTreeHomomorphismSemigroup and IsActingOnRegularTree, "mutable");
DeclareAttribute("AutomatonListInitialStatesGenerators", IsTreeHomomorphismSemigroup and IsActingOnRegularTree, "mutable");
DeclareAttribute("GeneratingAutomatonList", IsTreeHomomorphismSemigroup and IsActingOnRegularTree, "mutable");


#E
