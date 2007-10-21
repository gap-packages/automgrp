#############################################################################
##
#W  treehomsg.gd             automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.0
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


#############################################################################
##
#P  IsSphericallyTransitive (<G>)
##
##  Returns whether the group <G> is spherically transitive (see~"Short math background").
##  \beginexample
##  gap> GrigorchukGroup := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> IsSphericallyTransitive(GrigorchukGroup);
##  true
##  \endexample
##
DeclareProperty("IsSphericallyTransitive", IsTreeHomomorphismSemigroup);


#############################################################################
##
#O  IsTransitiveOnLevel (<G>, <lev>)
##
##  Returns whether the group (semigroup) <G> acts transitively on level <lev>.
##
##  \beginexample
##  gap> GrigorchukGroup := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> IsTransitiveOnLevel(Group([a,b]),3);
##  true
##  gap> IsTransitiveOnLevel(Group([a,b]),4);
##  false
##  \endexample
##
DeclareOperation("IsTransitiveOnLevel", [IsTreeHomomorphismSemigroup, IsPosInt]);


#E
