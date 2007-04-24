#############################################################################
##
#W  treeautgrp.gd              automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeAutomorphismGroup
##
DeclareSynonym("IsTreeAutomorphismGroup", IsGroup and IsTreeAutomorphismCollection);
InstallTrueMethod(IsTreeAutObject, IsTreeAutomorphismGroup);

###############################################################################
##
#O  TreeAutomorphismGroup
##
DeclareOperation("TreeAutomorphismGroup", [IsTreeAutomorphismGroup, IsPermGroup]);


###############################################################################
##
#P  IsSelfSimilar (<G>)
#O  CanEasilyTestSelfSimilarity (<G>)
##
##  SelfSimilar means that $G \< G \wr S_d$ - state closed.
##  GeneratingAutomatonList is a list representing automaton such that G is
##  generated by all its states.
##
DeclareProperty("IsSelfSimilar", IsTreeAutomorphismGroup and IsActingOnHomogeneousTree);
DeclareFilter("CanEasilyTestSelfSimilarity");
InstallTrueMethod(CanEasilyTestSelfSimilarity, HasIsSelfSimilar);


###############################################################################
##
#P  IsFractal (<G>)
#P  IsContracting (<G>)
##
##  Fractal means that $Projection(St_G(x),x) > G$ for any $x\in X$ and $G$ is
##  spherically transitive.
##
DeclareProperty("IsFractal", IsTreeAutomorphismGroup);
DeclareProperty("IsContracting", IsTreeAutomorphismGroup);
DeclareFilter("CanEasilyTestFractalness");
DeclareFilter("CanEasilyTestContractingProperty");


###############################################################################
##
#O  CanEasilyComputeSize (<G>)
##
DeclareFilter("CanEasilyComputeSize");


###############################################################################
##
#A  StabilizerOfFirstLevel (<G>)
#O  StabilizerOfLevel (<G>, <k>)
#O  StabilizerOfVertex (<G>, <vertex>)
##
DeclareAttribute("StabilizerOfFirstLevel", IsTreeAutomorphismGroup);
KeyDependentOperation("StabilizerOfLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);
DeclareOperation("StabilizerOfVertex", [IsTreeAutomorphismGroup, IsObject]);


###############################################################################
##
#O  Projection (<G>, <k>)
#O  Projection (<G>, <vertex>)
#O  ProjStab (<G>, <k>)
#O  ProjStab (<G>, <vertex>)
##
KeyDependentOperation("Projection", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);
DeclareOperation("ProjectionNC", [IsTreeAutomorphismGroup, IsObject]);
DeclareOperation("ProjStab", [IsTreeAutomorphismGroup, IsObject]);

DeclareOperation("$SubgroupOnLevel", [IsTreeAutomorphismGroup,
                                      IsList and IsTreeAutomorphismCollection,
                                      IsPosInt]);
DeclareOperation("$SimplifyGenerators", [IsList and IsTreeAutomorphismCollection]);


###############################################################################
##
#O  PermGroupOnLevel (<G>, <k>)
##
KeyDependentOperation("PermGroupOnLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);


###############################################################################
##
#P  IsAmenable (<G>)
##
DeclareProperty("IsAmenable", IsTreeAutomorphismGroup);
InstallTrueMethod(IsAmenable, IsAbelian);
InstallTrueMethod(IsAmenable, IsFinite);
#E
