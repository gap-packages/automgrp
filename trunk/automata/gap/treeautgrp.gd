#############################################################################
##
#W  treeautgrp.gd              automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeAutomorphismGroup
##
##  The category of groups of tree automorphisms.
##
DeclareSynonym("IsTreeAutomorphismGroup", IsGroup and IsTreeAutomorphismCollection);
InstallTrueMethod(IsActingOnTree, IsTreeAutomorphismGroup);


###############################################################################
##
#O  TreeAutomorphismGroup (<G>, <S>)
##
##  Constructs wreath product of tree automorphisms group <G> and permutation
##  group <S>.
##
DeclareOperation("TreeAutomorphismGroup", [IsTreeAutomorphismGroup, IsPermGroup]);


###############################################################################
##
#P  IsFractal (<G>)
##
##  Returns whether the group <G> is fractal.
##  \beginexample
##  gap> IsFractal(GrigorchukGroup);
##  true
##  \endexample
##
DeclareProperty("IsFractal", IsTreeAutomorphismGroup);


#############################################################################
##
#P  IsFractalByWords(<G>)
##
##  Computes the generators of stabilizers of vertices of the first level
##  and their projections on these vertices. Returns `true' if  the preimages of these
##  projections in the free group under canonical epimorphism generate the whole free
##  group for each stabilizer, and the <G> acts transitively on the first level.
##  This is sufficient but not necessary condition for <G> to be fractal. See also
##  `IsFractal' ("IsFractal").
DeclareProperty("IsFractalByWords", IsTreeAutomorphismGroup);
InstallTrueMethod(IsFractal, IsFractalByWords);


###############################################################################
##
#A  LevelOfFaithfulAction (<G>)
#A  LevelOfFaithfulAction (<G>, <max_lev>)
##
##  For a given finite self-similar group <G> determines the smallest level of
##  the tree, where <G> acts faithfully, i.e. the stabilizer of this level in <G>
##  is trivial. The idea here is that for self-similar group all nontrivial level
##  stabilizers are different. If <max_lev> is given it finds only first <max_lev>
##  quotients by stabilizers and if all of them have different size returns `fail'.
##  If <G> is infinite and <max_lev> is not specified will loop forever.
##
##  See also `IsomorphismPermGroup' ("IsomorphismPermGroup").
##  \beginexample
##  gap> H:=SelfSimilarGroup("a=(a,a)(1,2),b=(a,a),c=(b,a)(1,2)");
##  < a, b, c >
##  gap> LevelOfFaithfulAction(H);
##  3
##  gap> LevelOfFaithfulAction(AddingMachine,10);
##  fail
##  \endexample
##
DeclareAttribute("LevelOfFaithfulAction", IsTreeAutomorphismGroup and IsSelfSimilar);


################################################################################
##
#A  IsContracting (<G>)
##
##  Given a self-similar group <G> tries to compute whether it is contracting or not.
##  Only the partial method is implemented (since there is no general algorithm so far).
##  First it tries to find the nucleus up to size 50 using `FindNucleus'(<G>,50) (see~"FindNucleus"), then
##  it tries to find the evidence that the group is noncontracting using
##  `IsNoncontracting'(<G>,10,10) (see~"IsNoncontracting"). If the answer was not found one can try to use
##  `FindNucleus' and `IsNoncontracting' with bigger tolerances.
##
##  \beginexample
##  gap> IsContracting(Basilica);
##  true
##  gap> IsContracting(AutomatonGroup("a=(c,a)(1,2),b=(c,b),c=(b,a)"));
##  #I  (b*c^-1)^1 has b*a^-1 as a section at vertex [ 2 ]
##  #I  (b*a^-1)^2 has congutate of a^-1*b as a section at vertex [ 1 ]
##  false
##  \endexample
##
DeclareProperty("IsContracting", IsTreeAutomorphismGroup);


###############################################################################
##
#A  StabilizerOfFirstLevel (<G>)
##
##  Returns the stabilizer of the first level, see also~"StabilizerOfLevel".
##  \beginexample
##  gap> StabilizerOfFirstLevel(Basilica);
##  < u^2, u*v*u^-1, v >
##  \endexample
##
DeclareAttribute("StabilizerOfFirstLevel", IsTreeAutomorphismGroup);

###############################################################################
##
#O  StabilizerOfLevel (<G>, <k>)
##
##  Returns the stabilizer of the <k>-th level.
##  \beginexample
##  gap> StabilizerOfLevel(Basilica, 2);
##  < u*v^2*u^-1, u*v*u*v^2*u^-1*v^-1*u^-1, v^2, v*u^2*v^-1, u*v*u^2*v^-1*u^-1, u^
##  2, v*u*v*u*v^-1*u^-1*v^-1*u^-1 >
##  \endexample
##
KeyDependentOperation("StabilizerOfLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);

###############################################################################
##
#O  StabilizerOfVertex (<G>, <v>)
##
##  Returns stabilizer of the vertex <v>. Here <v> can be a list represnting a
##  vertex, or a positive intger representing a vertex at the first level.
##  \beginexample
##  gap> StabilizerOfVertex(Basilica,[1,2,1]);
##  < v*u^4*v^-1, v*u^2*v^2*u^-2*v^-1, v^2, u^2, v*u^2*v*u^2*v^-1*u^-2*v^-1, u*v*u^
##  -1, v*u^-1*v*u*v^-1, v*u^2*v*u*v*u^-1*v^-1*u^-2*v^-1 >
##  \endexample
##
DeclareOperation("StabilizerOfVertex", [IsTreeAutomorphismGroup, IsObject]);


###############################################################################
##
#O  Projection (<G>, <v>)
#O  ProjectionNC (<G>, <v>)
##
##  Returns projection of the group <G> at the vertex <v>. The group <G> must fix the
##  the vertex <v>, otherwise `Error'() will be called. The operation `ProjectionNC' does the
##  same thing, except it does not check whether <G> fixes vertex <v>.
##  \beginexample
##  gap> Projection(StabilizerOfVertex(Basilica,[1,2,1]),[1,2,1]);
##  < v, u >
##  \endexample
##
KeyDependentOperation("Projection", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);
DeclareOperation("Projection", [IsTreeAutomorphismGroup, IsList]);
DeclareOperation("ProjectionNC", [IsTreeAutomorphismGroup, IsObject]);

###############################################################################
##
#O  ProjStab (<G>, <v>)
##
##  Returns projection of the stabilizer of <v> at itself. It is a shortcut for
##  `Projection'(`StabilizerOfVertex'(G, v), v) (see "Projection",
##  "StabilizerOfVertex").
##  \beginexample
##  gap> ProjStab(Basilica,[1,2,1]);
##  < v, u >
##  \endexample
##
DeclareOperation("ProjStab", [IsTreeAutomorphismGroup, IsObject]);


DeclareOperation("$AG_SubgroupOnLevel", [IsTreeAutomorphismGroup,
                                         IsTreeHomomorphismCollection,
                                         IsPosInt]);
DeclareOperation("$AG_SimplifyGroupGenerators", [IsTreeHomomorphismCollection]);


###############################################################################
##
#O  PermGroupOnLevel (<G>, <k>)
##
##  Returns group of permutations induced by action of group <G> at the <k>-th
##  level.
##  \beginexample
##  gap> PermGroupOnLevel(Basilica,4);
##  Group([ (1,11,3,9)(2,12,4,10)(5,13)(6,14)(7,15)(8,16), (1,6,2,5)(3,7)(4,8) ])
##  gap> H:=PermGroupOnLevel(Group([u,v^2]),4);
##  Group([ (1,11,3,9)(2,12,4,10)(5,13)(6,14)(7,15)(8,16), (1,2)(5,6) ])
##  gap> Size(H);
##  64
##  \endexample
##
KeyDependentOperation("PermGroupOnLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);


#############################################################################
##
#P  IsSphericallyTransitive (<G>)
##
##  Returns whether the group <G> is spherically transitive (see~"Short math background").
##  \beginexample
##  gap> IsSphericallyTransitive(GrigorchukGroup);
##  true
##  \endexample
##
DeclareProperty("IsSphericallyTransitive", IsTreeAutomorphismGroup);


#############################################################################
##
#O  IsTransitiveOnLevel (<G>, <lev>)
##
##  Returns whether the group <G> acts transitively on level <lev>.
##  \beginexample
##  gap> IsTransitiveOnLevel(Group([a,b]),3);
##  true
##  gap> IsTransitiveOnLevel(Group([a,b]),4);
##  false
##  \endexample
##
DeclareOperation("IsTransitiveOnLevel", [IsTreeAutomorphismGroup, IsPosInt]);


#E
