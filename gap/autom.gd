#############################################################################
##
#W  autom.gd                 automata package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsAutom
#C  IsAutomCollection
#C  IsAutomFamily
##
DeclareCategory("IsAutom", IsAutomaton);
DeclareCategoryCollections("IsAutom");
DeclareCategoryFamily("IsAutom");
InstallTrueMethod(IsAutomatonObject, IsAutomCollection);
InstallTrueMethod(IsAutomatonObject, IsAutomFamily);

DeclareOperation("Word", [IsObject]);
DeclareOperation("Word", [IsGroup, IsGroup]);


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
