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
##  A category of objects created using `AutomGroup'~("AutomGroup"). These
##  objects are finite initial automata.
##
DeclareCategory("IsAutom", IsTreeAutomorphism);
DeclareCategoryCollections("IsAutom");
DeclareCategoryFamily("IsAutom");
InstallTrueMethod(IsActingOnRegularTree, IsAutomCollection);
InstallTrueMethod(IsActingOnRegularTree, IsAutom);


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
DeclareOperation("Autom", [IsAssocWord, IsAutom]);
DeclareOperation("Autom", [IsAssocWord, IsAutomFamily]);


###############################################################################
##
#O  StatesWords(<a>)
##
DeclareOperation("StatesWords", [IsAutom]);


#E
