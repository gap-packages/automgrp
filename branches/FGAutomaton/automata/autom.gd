#############################################################################
##
#W  autom.gd                 automata package                  Yevgen Muntyan
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
DeclareCategory("IsAutom", IsInitialAutomaton);
DeclareCategoryCollections("IsAutom");
DeclareCategoryFamily( "IsAutom" );


###############################################################################
##
#O  AutomFamily(<list>, <names>, <trivname>)
##
DeclareOperation("AutomFamily", [IsList, IsList, IsString]);


###############################################################################
##
#O  Autom(<word>, <a>)
#O  Autom(<word>, <fam>)
##
DeclareOperation("Autom", [IsAssocWord, IsAutomFamily]);


###############################################################################
##
#A  One(<fam>)
##
DeclareAttribute("One", IsAutomFamily);


###############################################################################
##
#O  StatesWords(<a>)
##
DeclareOperation("StatesWords", [IsAutom]);


#E
