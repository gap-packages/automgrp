#############################################################################
##
#W  autom.gd                 automata package                  Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


###############################################################################
##
#C  IsAutom
##
DeclareCategory("IsFGAutom", IsInitialAutomaton);

DeclareCategoryCollections("IsFGAutom");


#############################################################################
##
#C  IsFGAutomFamily
##
DeclareCategoryFamily( "IsFGAutom" );


###############################################################################
##
#O  CreateAutom(<object>)
##
DeclareOperation("CreateAutom", [IsObject]);


###############################################################################
##
#O  Autom(<object>)
##
DeclareOperation("FGAutom", [IsObject]);


###############################################################################
##
#P  IsActingOnBinaryTree
##
DeclareProperty("IsActingOnBinaryTree", IsFGAutomFamily);
