#############################################################################
##
#W  selfsim.gd               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
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
#O  SelfSim( <word>, <a> )
#O  SelfSim( <word>, <fam> )
##
##  Given assosiative word <word> constructs a tree homomorphism from the family
##  <fam>, or to which homomorphism <a> belongs. This function is useful when
##  one needs to make some operations with associative words. See also `Word' ("Word").
##  \beginexample
##  gap> G := SelfSimilarGroup("a=(a*b,b)(1,2), b=(a^-1,b)");
##  < a, b >
##  gap> F := UnderlyingFreeGroup(G);
##  <free group on the generators [ a, b ]>
##  gap> c := SelfSim(F.1*F.2^2,a);
##  a*b^2
##  gap> IsSelfSim(c);
##  true
##  \endexample
##
DeclareOperation("SelfSim", [IsAssocWord, IsSelfSim]);
DeclareOperation("SelfSim", [IsAssocWord, IsSelfSimFamily]);
DeclareOperation("SelfSim", [IsAssocWord, IsList]);

###############################################################################
##
#O  StatesWords( <a> )
##
DeclareOperation("StatesWords", [IsSelfSim]);


###############################################################################
##
#P  IsFiniteState( <a> )
##
##  Returns `true' if <a> has finitely many different sections.
##  It will never stop if the free reduction of words is not sufficient
##  to establish the finite-state property or if <a> is not finite-state (has
##  infinitely many different sections).
##
##  See also `AllSections' ("AllSections") for the list of all sections and
##  `MealyAutomaton' ("MealyAutomaton"), which allows to construct
##  a Mealy automaton whose states are the sections of <a> and which
##  encodes its action on the tree.
##  \beginexample
##  gap> D := SelfSimilarGroup("x=(1,y)(1,2), y=(z^-1,1)(1,2), z=(1,x*y)");
##  < x, y, z >
##  gap> IsFiniteState(x*y^-1);
##  true
##  \endexample
##
DeclareProperty("IsFiniteState", IsSelfSim);





DeclareOperation("OrderUsingSections",[IsSelfSim]);
DeclareOperation("OrderUsingSections",[IsSelfSim, IsCyclotomic]);


DeclareGlobalFunction("__AG_CreateSelfSim");


#E
