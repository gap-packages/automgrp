#############################################################################
##
#W  fgautom.gd               automata package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v0.9, started 01/22/2004
##


###############################################################################
##
#C  IsFGAutom
#C  IsFGAutomFamily
#C  IsFGAutomCollection
##
DeclareCategory("IsFGAutom", IsAutomaton);
DeclareCategoryFamily("IsFGAutom");
DeclareCategoryCollections("IsFGAutom");


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


DeclareOperation("ListRep", [IsFGAutom]);
DeclareOperation("StabilizesPath", [IsFGAutom, IsList]);
