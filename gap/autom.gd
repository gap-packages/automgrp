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
DeclareOperation("Word", [IsAutom]);


###############################################################################
##
#O  Autom(<word>, <a>)
#O  Autom(<word>, <fam>)
##
##  Given assosiative word <word> constructs a tree automorphism from the family
##  <fam>, or to which automorphism <a> belongs. This function is useful when
##  one needs to make some operations with associative words. See also `Word' ("Word").
##  \beginexample
##  gap> G:=AutomatonGroup("a=(a,b)(1,2), b=(a,b)");
##  < a, b >
##  gap> F:=UnderlyingFreeGroup(G);
##  <free group on the generators [ a, b ]>
##  gap> c:=Autom(F.1*F.2^2,a);
##  a*b^2
##  gap> IsAutom(c);
##  true
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
