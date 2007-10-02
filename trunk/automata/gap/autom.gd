#############################################################################
##
#W  autom.gd                 automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsAutom
##
##  A category of objects created using `AutomatonGroup'~("AutomatonGroup"). These
##  objects are finite initial automata.
##
DeclareCategory("IsAutom", IsTreeHomomorphism);
DeclareCategoryCollections("IsAutom");
DeclareCategoryFamily("IsAutom");
InstallTrueMethod(IsActingOnRegularTree, IsAutomCollection);
InstallTrueMethod(IsActingOnRegularTree, IsAutom);

DeclareCategory("IsInvertibleAutom", IsAutom and IsTreeAutomorphism);
DeclareCategoryCollections("IsInvertibleAutom");



###############################################################################
##
#O  Autom(<word>, <a>)
#O  Autom(<word>, <fam>)
##
##  Given assosiative word <word> constructs a tree homomorphism from the family
##  <fam>, or to which homomorphism <a> belongs. This function is useful when
##  one needs to make some operations with associative words. See also `Word' ("Word").
##  \beginexample
##  gap> G:=AutomatonGroup("a=(a,b)(1,2), b=(a,b)");
##  < a, b >
##  gap> F:=UnderlyingFreeGroup(G);
##  <free group on the generators [ a, b ]>
##  gap> c:=Autom(F.1*F.2^2,a);
##  a*b^2
##  gap> Decompose(c);
##  (a*b^2, b*a^2)(1,2)
##  \endexample
##
DeclareOperation("Autom", [IsAssocWord, IsAutom]);
DeclareOperation("Autom", [IsAssocWord, IsAutomFamily]);


###############################################################################
##
#O  StatesWords(<a>)
##
DeclareOperation("StatesWords", [IsAutom]);


DeclareGlobalFunction("$AG_CreateAutom");


#E
