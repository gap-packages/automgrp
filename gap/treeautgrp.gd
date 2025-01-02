#############################################################################
##
#W  treeautgrp.gd              automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeAutomorphismGroup( <G> )
##
##  The category of groups of tree automorphisms.
##
DeclareSynonym("IsTreeAutomorphismGroup", IsGroup and IsTreeAutomorphismCollection);
InstallTrueMethod(IsActingOnTree, IsTreeAutomorphismGroup);


###############################################################################
##
#O  TreeAutomorphismGroup( <G>, <S> )
##
##  Constructs wreath product of tree automorphisms group <G> and permutation
##  group <S>.
##
DeclareOperation("TreeAutomorphismGroup", [IsTreeAutomorphismGroup, IsPermGroup]);


###############################################################################
##
#P  IsFractal( <G> )
##
##  Returns whether the group <G> is fractal (also called as <self-replicating>). In other
##  words, if <G> acts transitively on the first level and for any vertex $v$ of the tree
##  the projection of the stabilizer of $v$ in <G>
##  on this vertex coincides with the whole group <G>.
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> IsFractal(Grigorchuk_Group);
##  true
##  \endexample
##
DeclareProperty("IsFractal", IsTreeAutomorphismGroup);


#############################################################################
##
#P  IsFractalByWords( <G> )
##
##  Computes the generators of stabilizers of vertices of the first level
##  and their projections on these vertices. Returns `true' if  the preimages of these
##  projections in the free group under the canonical epimorphism generate the whole free
##  group for each stabilizer, and the <G> acts transitively on the first level.
##  This is sufficient but not necessary condition for <G> to be fractal. See also
##  `IsFractal' ("IsFractal").
##
DeclareProperty("IsFractalByWords", IsTreeAutomorphismGroup);
InstallTrueMethod(IsFractal, IsFractalByWords);


###############################################################################
##
#A  LevelOfFaithfulAction( <G> )
#A  LevelOfFaithfulAction( <G>, <max_lev> )
##
##  For a given finite self-similar group <G> determines the smallest level of
##  the tree, where <G> acts faithfully, i.e. the stabilizer of this level in <G>
##  is trivial. The idea here is that for a self-similar group all nontrivial level
##  stabilizers are different. If <max_lev> is given it finds only first <max_lev>
##  quotients by stabilizers and if all of them have different size it returns `fail'.
##  If <G> is infinite and <max_lev> is not specified it will loop forever.
##
##  See also `IsomorphismPermGroup' ("IsomorphismPermGroup").
##  \beginexample
##  gap> H := SelfSimilarGroup("a=(a,a)(1,2), b=(a,a), c=(b,a)(1,2)");
##  < a, b, c >
##  gap> LevelOfFaithfulAction(H);
##  3
##  gap> Size(H);
##  16
##  gap> Adding_Machine := AutomatonGroup("a=(1,a)(1,2)");
##  < a >
##  gap> LevelOfFaithfulAction(Adding_Machine, 10);
##  fail
##  \endexample
##
DeclareAttribute("LevelOfFaithfulAction", IsTreeAutomorphismGroup and IsSelfSimilar);


################################################################################
##
#A  IsContracting( <G> )
##
##  Given a self-similar group <G> tries to compute whether it is contracting or not.
##  Only a partial method is implemented (since there is no general algorithm so far).
##  First it tries to find the nucleus up to size 50 using `FindNucleus'(<G>,50) (see~"FindNucleus"), then
##  it tries to find evidence that the group is noncontracting using
##  `IsNoncontracting'(<G>,10,10) (see~"IsNoncontracting"). If the answer was not found one can try to use
##  `FindNucleus' and `IsNoncontracting' with bigger parameters.  Also one can use
##  `SetInfoLevel(InfoAutomGrp, 3)' for more information to be displayed.
##
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> IsContracting(Basilica);
##  true
##  gap> IsContracting(AutomatonGroup("a=(c,a)(1,2), b=(c,b), c=(b,a)"));
##  false
##  \endexample
##
DeclareProperty("IsContracting", IsTreeAutomorphismGroup);


###############################################################################
##
#A  StabilizerOfFirstLevel( <G> )
##
##  Returns the stabilizer of the first level, see also~"StabilizerOfLevel".
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> StabilizerOfFirstLevel(Basilica);
##  < v, u^2, u*v*u^-1 >
##  \endexample
##
DeclareAttribute("StabilizerOfFirstLevel", IsTreeAutomorphismGroup);

###############################################################################
##
#O  StabilizerOfLevel( <G>, <k> )
##
##  Returns the stabilizer of the <k>-th level.
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> StabilizerOfLevel(Basilica, 2);
##  < u^2, v^2, u*v^2*u^-1, v*u^2*v^-1, u*v*u^2*v^-1*u^-1, (v*u)^2*(v^-1*u^-1)^2, v*u*\
##  v^2*u^-1*v^-1, (u*v)^2*u*v^-1*u^-1*v^-1, (u*v)^2*v*u^-1*v^-1*u^-1 >
##  \endexample
##
KeyDependentOperation("StabilizerOfLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);

###############################################################################
##
#O  StabilizerOfVertex( <G>, <v> )
##
##  Returns the stabilizer of the vertex <v>. Here <v> can be a list representing a
##  vertex, or a positive integer representing a vertex at the first level.
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> StabilizerOfVertex(Basilica, [1,2,1]);
##  < u^2, u*v*u^-1, v^2, v*u*v*u^-1*v^-1, v*u^-1*v*u*v^-1, v*u^4*v^-1, v*u^2*v^2*u^-2\
##  *v^-1, (v*u^2)^2*v^-1*u^-2*v^-1, v*u*(u*v)^2*u^-1*v^-1*u^-2*v^-1 >
##  \endexample
##
DeclareOperation("StabilizerOfVertex", [IsTreeAutomorphismGroup, IsObject]);


###############################################################################
##
#O  Projection( <G>, <v> )
#O  ProjectionNC( <G>, <v> )
##
##  Returns the projection of the group <G> at the vertex <v>. The group <G> must fix the
##  vertex <v>, otherwise `Error'() will be called. The operation `ProjectionNC' does the
##  same thing, except it does not check whether <G> fixes the vertex <v>.
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> Projection(StabilizerOfVertex(Basilica, [1,2,1]), [1,2,1]);
##  < u, v >
##  \endexample
##
DeclareOperation("Projection", [IsTreeAutomorphismGroup, IsList]);
DeclareOperation("ProjectionNC", [IsTreeAutomorphismGroup, IsObject]);

###############################################################################
##
#O  ProjStab (<G>, <v>)
##
##  Returns the projection of the stabilizer of <v> at itself. It is a shortcut for
##  `Projection'(`StabilizerOfVertex'(G, v), v) (see "Projection",
##  "StabilizerOfVertex").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> ProjStab(Basilica, [1,2,1]);
##  < u, v >
##  \endexample
##
DeclareOperation("ProjStab", [IsTreeAutomorphismGroup, IsObject]);


DeclareOperation("__AG_SubgroupOnLevel", [IsTreeAutomorphismGroup,
                                         IsTreeHomomorphismCollection,
                                         IsPosInt]);
DeclareOperation("__AG_SimplifyGroupGenerators", [IsObject]);


###############################################################################
##
#O  PermGroupOnLevel (<G>, <k>)
##
##  Returns the group of permutations induced by the action of the group <G> at the <k>-th
##  level.
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> PermGroupOnLevel(Basilica, 4);
##  Group([ (1,11,3,9)(2,12,4,10)(5,13)(6,14)(7,15)(8,16), (1,6,2,5)(3,7)(4,8) ])
##  gap> H := PermGroupOnLevel(Group([u,v^2]),4);
##  Group([ (1,11,3,9)(2,12,4,10)(5,13)(6,14)(7,15)(8,16), (1,2)(5,6) ])
##  gap> Size(H);
##  64
##  \endexample
##
KeyDependentOperation("PermGroupOnLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);


###############################################################################
##
#A  ContainsSphericallyTransitiveElement( <G> )
##
##  For a self-similar group <G> acting on a binary tree returns `true' if <G> contains
##  an element acting spherically transitively on the levels of the tree and `false'
##  otherwise. See also `SphericallyTransitiveElement' ("SphericallyTransitiveElement").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> ContainsSphericallyTransitiveElement(Basilica);
##  true
##  gap> G := SelfSimilarGroup("a=(a^-1*b^-1,1)(1,2), b=(b^-1,a*b)");
##  < a, b >
##  gap> ContainsSphericallyTransitiveElement(G);
##  false
##  \endexample
##
DeclareAttribute("ContainsSphericallyTransitiveElement", IsTreeAutomorphismGroup);


###############################################################################
##
#A  SphericallyTransitiveElement( <G> )
##
##  For a self-similar group <G> acting on a binary tree returns
##  an element of <G> acting spherically transitively on the levels of the tree if
##  such an element exists and `fail'
##  otherwise. See also `ContainsSphericallyTransitiveElement'
##  ("ContainsSphericallyTransitiveElement").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> SphericallyTransitiveElement(Basilica);
##  u*v
##  gap> G := SelfSimilarGroup("a=(a^-1*b^-1,1)(1,2), b=(b^-1,a*b)");
##  < a, b >
##  gap> SphericallyTransitiveElement(G);
##  fail
##  \endexample
##
DeclareAttribute("SphericallyTransitiveElement", IsTreeAutomorphismGroup);


#E
