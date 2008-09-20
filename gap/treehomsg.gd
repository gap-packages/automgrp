#############################################################################
##
#W  treehomsg.gd             automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
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

###############################################################################
##
#O  TransformationSemigroupOnLevel (<G>, <k>)
##
##  Returns the semigroup of transformations induced by the action of the semigroup <G> at the <k>-th
##  level.
##  \beginexample
##  gap> S:=AutomatonSemigroup("y=(1,u)[1,1],u=(y,u)(1,2)");
##  < 1, y, u >
##  gap> T:=TransformationSemigroupOnLevel(S,3);
##  <semigroup with 3 generators>
##  gap> Size(T);
##  11
##  \endexample
##
KeyDependentOperation("TransformationSemigroupOnLevel", IsTreeHomomorphismSemigroup, IsPosInt, ReturnTrue);

#E
