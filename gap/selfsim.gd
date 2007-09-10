#############################################################################
##
#W  selfsim.gd               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsSelfSim
##
##  A category of objects created using `SelfSimGroup'~("SelfSimGroup"). These
##  objects are (possibly infinite) initial automata.
##
DeclareCategory("IsSelfSim", IsTreeHomomorphism);
DeclareCategoryCollections("IsSelfSim");
DeclareCategoryFamily("IsSelfSim");
InstallTrueMethod(IsActingOnRegularTree, IsSelfSimCollection);
InstallTrueMethod(IsActingOnRegularTree, IsSelfSim);

DeclareCategory("IsInvertibleSelfSim", IsSelfSim and IsTreeAutomorphism);
DeclareCategoryCollections("IsInvertibleSelfSim");


###############################################################################
##
#O  Word( <a> )
##
##  Returns <a> as an associative word (an element of underlying free group) in
##  generators of the self-similar group
##  to which <a> belongs.
##  \beginexample
##  gap> w:=Word(a*b^2*a^-1);
##  a*b^2*a^-1
##  gap> Length(w);
##  4
##  \endexample
##
DeclareOperation("Word", [IsSelfSim]);


###############################################################################
##
#O  SelfSim(<word>, <a>)
#O  SelfSim(<word>, <fam>)
##
##  Given assosiative word <word> constructs a tree automorphism from the family
##  <fam>, or to which automorphism <a> belongs. This function is useful when
##  one needs to make some operations with associative words. See also `Word' ("Word").
##  \beginexample
##  gap> G:=AutomatonGroup("a=(a,b)(1,2), b=(a,b)");
##  < a, b >
##  gap> F:=UnderlyingFreeGroup(G);
##  <free group on the generators [ a, b ]>
##  gap> c:=SelfSim(F.1*F.2^2,a);
##  a*b^2
##  gap> IsSelfSim(c);
##  true
##  \endexample
##
DeclareOperation("SelfSim", [IsAssocWord, IsSelfSim]);
DeclareOperation("SelfSim", [IsAssocWord, IsSelfSimFamily]);


###############################################################################
##
#O  StatesWords(<a>)
##
DeclareOperation("StatesWords", [IsSelfSim]);


###############################################################################
##
#P  IsFiniteState(<a>)
##
DeclareProperty("IsFiniteState", IsSelfSim);


###############################################################################
##
#A  AllSections(<a>)
##
DeclareAttribute("AllSections", IsSelfSim);


################################################################################
##
#O  OrderUsingSections ( <a>[, <max_depth>] )
##
DeclareOperation("OrderUsingSections",[IsSelfSim]);
DeclareOperation("OrderUsingSections",[IsSelfSim, IsCyclotomic]);


DeclareGlobalFunction("$AG_CreateSelfSim");


#E
