#############################################################################
##
#W  fgautom.gd                 automata package                Yevgen Muntyan
##
##  automata v 0.91 started June 07 2004
##

Revision.fgautom_gd := 
  "@(#)$Id$";


###############################################################################
##
#V  FGAutomatonFamilyCreated
##
##  This is a list containing already created FGAutomaton families.
##
DeclareGlobalVariable ("FGAutomatonFamilyCreated");


###############################################################################
##
#C  IsFGAutomaton
#C  IsFGAutomatonFamily
##
DeclareCategory ("IsFGAutomaton", IsInitialAutomaton);
DeclareCategoryCollections ("IsFGAutomaton");
DeclareCategoryFamily ("IsFGAutomaton");


###############################################################################
##
#O  FGAutomatonCreate(<object>)
##
DeclareOperation ("FGAutomatonCreate", [IsList]);


###############################################################################
##
#O  FGAutomaton(<object>)
##
DeclareOperation ("FGAutomaton", [IsObject]);



#E