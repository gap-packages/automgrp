#############################################################################
##
#W  autom.gd                   automata package                Yevgen Muntyan
##
##  automata v 0.91 started June 07 2004
##

Revision.autom_gd := 
  "@(#)$Id$";


###############################################################################
##
#C  IsAutom
##
DeclareCategory("IsAutom", IsInitialAutomaton);
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



#E