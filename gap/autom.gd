#############################################################################
##
#W  autom.gd                 automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
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
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> F := UnderlyingFreeGroup(L);
##  <free group on the generators [ p, q ]>
##  gap> r := Autom(F.1*F.2^2, p);
##  p*q^2
##  gap> Decompose(r);
##  (p*q^2, q*p^2)(1,2)
##  \endexample
##
DeclareOperation("Autom", [IsAssocWord, IsAutom]);
DeclareOperation("Autom", [IsAssocWord, IsAutomFamily]);
DeclareOperation("Autom", [IsAssocWord, IsList]);


###############################################################################
##
#O  StatesWords(<a>)
##
DeclareOperation("StatesWords", [IsAutom]);

#DeclareOperation("Perm", [IsAutom]);

DeclareGlobalFunction("__AG_CreateAutom");


#E
