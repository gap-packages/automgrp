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
#O  SelfSim( <word>, <a> )
#O  SelfSim( <word>, <fam> )
##
##  Given assosiative word <word> constructs a tree homomorphism from the family
##  <fam>, or to which homomorphism <a> belongs. This function is useful when
##  one needs to make some operations with associative words. See also `Word' ("Word").
##  \beginexample
##  gap> G:=SelfSimilarGroup("a=(a*b,b)(1,2), b=(a^-1,b)");
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
#O  StatesWords( <a> )
##
DeclareOperation("StatesWords", [IsSelfSim]);


###############################################################################
##
#P  IsFiniteState( <a> )
##
##  Returns `true' if <a> has finitely many different sections at the vertices
##  of the tree. It will never stop if the free reduction of words is not sufficient
##  to establish the finite-state property or if <a> is not finite-state (has
##  infinitely many different sections).
##
##  See also `AllSections' ("AllSections") for the list of all sections and
##  `MealyAutomaton' ("MealyAutomaton"), which allows to construct
##  a Mealy automaton whose states are the sections of <a> and which
##  encodes its action on the tree.
##  \beginexample
##  gap> gap> D:=SelfSimilarGroup("x=(1,y)(1,2),y=(z^-1,1)(1,2),z=(1,x*y)");
##  < x, y, z >
##  gap> IsFiniteState(x*y^-1);
##  true
##  \endexample
##
DeclareProperty("IsFiniteState", IsSelfSim);


###############################################################################
##
#A  AllSections( <a> )
##
##  Returns the list of all sections of <a> if there are finitely many of them and
##  that can be established using free reduction of words in sections. Otherwise
##  will never stop.
##  \beginexample
##  gap> D:=SelfSimilarGroup("x=(1,y)(1,2),y=(z^-1,1)(1,2),z=(1,x*y)");
##  < x, y, z >
##  gap> AllSections(x*y^-1);
##  [ x*y^-1, z, 1, x*y, y*z^-1, z^-1*y^-1*x^-1, y^-1*x^-1*z*y^-1, z*y^-1*x*y*z,
##    y*z^-1*x*y, z^-1*y^-1*x^-1*y*z^-1, x*y*z, y, z^-1, y^-1*x^-1, z*y^-1 ]
##  \endexample
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
