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
##  Returns whether the group or semigroup <G> is self-similar (see "Short math background").
##
DeclareProperty("IsSelfSimilar", IsTreeHomomorphismSemigroup and IsActingOnRegularTree);
DeclareFilter("CanEasilyTestSelfSimilarity");
InstallTrueMethod(CanEasilyTestSelfSimilarity, HasIsSelfSimilar);


# XXX

###############################################################################
##
#A  AutomatonList(<G>)
##
##  Returns an `AutomatonList' of `UnderlyingAutomaton'(<G>) (see "UnderlyingAutomaton").
##  \beginexample
##  gap> AutomatonList(Basilica);
##  [ [ 2, 5, (1,2) ], [ 1, 5, () ], [ 5, 4, (1,2) ], [ 3, 5, () ], [ 5, 5, () ] ]
##  \endexample
##
DeclareAttribute("AutomatonList", IsTreeHomomorphismSemigroup and IsActingOnRegularTree, "mutable");

DeclareAttribute("GeneratingAutomatonList", IsTreeHomomorphismSemigroup and IsActingOnRegularTree, "mutable");


#E
