#############################################################################
##
#W  autom.gd                 automata package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v0.9, started 01/22/2004
##

Revision.autom_gd :=
  "@(#)$Id$";


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


###############################################################################
##
#O  Autom(<word>, <a>)
#O  Autom(<word>, <fam>)
##
DeclareOperation("Autom", [IsAssocWord, IsAutomFamily]);


###############################################################################
##
#O  StatesWords(<a>)
##
DeclareOperation("StatesWords", [IsAutom]);



#E
