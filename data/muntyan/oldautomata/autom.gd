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
DeclareCategory("IsAutom",
                IsAutomObj and
                IsMultiplicativeElementWithInverse and IsAssociativeElement);

DeclareCategoryCollections("IsAutom");


#############################################################################
##
#C  IsAutomFamily
##
DeclareCategoryFamily( "IsAutom" );


###############################################################################
##
#O  CreateAutom(<object>)
##
DeclareOperation("CreateAutom", [IsObject]);


###############################################################################
##
#O  Autom(<object>)
##
DeclareOperation("Autom", [IsObject]);


###############################################################################
##
#P  IsActingOnBinaryTree
##
DeclareProperty("IsActingOnBinaryTree", IsAutomFamily);
