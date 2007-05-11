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
##  Category of groups of tree automorphisms.
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
##  Whether group <G> is fractal.
##
DeclareProperty("IsFractal", IsTreeAutomorphismGroup);



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
##  gap> IsContracting(AutomGroup("a=(c,a)(1,2),b=(c,b),c=(b,a)"));
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
##  Returns stabilizer of the first level, see also~"StabilizerOfLevel".
##
DeclareAttribute("StabilizerOfFirstLevel", IsTreeAutomorphismGroup);

###############################################################################
##
#O  StabilizerOfLevel (<G>, <k>)
##
##  Returns stabilizer of the <k>-th level.
##
KeyDependentOperation("StabilizerOfLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);

###############################################################################
##
#O  StabilizerOfVertex (<G>, <v>)
##
##  Returns stabilizer of the vertex <v>. <v> can be a list represnting a
##  vertex, or a positive intger representing a vertex at the first level.
##
DeclareOperation("StabilizerOfVertex", [IsTreeAutomorphismGroup, IsObject]);


###############################################################################
##
#O  Projection (<G>, <v>)
#O  ProjectionNC (<G>, <v>)
##
##  Returns projection of the group <G> at the vertex <v>. <G> must fix the
##  the vertex <v>, otherwise `Error'() will be called. `ProjectionNC' does the
##  same thing, except it does not check whether <G> fixes vertex <v>.
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
##
DeclareOperation("ProjStab", [IsTreeAutomorphismGroup, IsObject]);


DeclareOperation("$SubgroupOnLevel", [IsTreeAutomorphismGroup,
                                      IsList and IsTreeAutomorphismCollection,
                                      IsPosInt]);
DeclareOperation("$SimplifyGenerators", [IsList and IsTreeAutomorphismCollection]);


###############################################################################
##
#O  PermGroupOnLevel (<G>, <k>)
##
##  Returns group of permutations induced by action of group <G> at the <k>-th
##  level.
##
KeyDependentOperation("PermGroupOnLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);


#############################################################################
##
#P  IsSphericallyTransitive (<G>)
##
##  Whether group <G> is spherically transitive (see~"spherically
##  transitive").
##
DeclareProperty("IsSphericallyTransitive", IsTreeAutomorphismGroup);


#############################################################################
##
#O  IsTransitiveOnLevel (<G>, <lev>)
##
##  Whether group <G> acts transitively on level <lev>.
##
DeclareOperation("IsTransitiveOnLevel", [IsTreeAutomorphismGroup, IsPosInt]);


#E
