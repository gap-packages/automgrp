#############################################################################
##
#W  agroup.gd               automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##
##	Declarations of functions dealing with FGAutomGroup's
##

###############################################################################
##
#C  IsFGAutomGroup
##
DeclareCategory("IsFGAutomGroup", IsObject);


###############################################################################
##
#O  FGAutomGroup(<gens>)
##
##  Creates FGAutomGroup generated by <gens>
##
DeclareOperation("FGAutomGroup", [IsList]);


###############################################################################
##
#A  StabilizerOfFirstLevel
#O  StabilizerOfLevel
#A  StabilizerOfVertex
##
DeclareAttribute("StabilizerOfFirstLevel", IsFGAutomGroup);
DeclareOperation("StabilizerOfLevel", [IsFGAutomGroup, IsInt]);
DeclareOperation("StabilizerOfVertex", [IsFGAutomGroup, IsInt]);


###############################################################################
##
#O  IndexInFreeGroup(<automata_group>)
##
DeclareOperation("IndexInFreeGroup", [IsFGAutomGroup]);


###############################################################################
##
#O  Mihaylov(<object>)
##
DeclareOperation("Mihaylov", [IsFGAutomGroup]);


###############################################################################
##
#P  IsActingOnBinaryTree
##
DeclareProperty("IsActingOnBinaryTree", IsFGAutomGroup);


DeclareProperty("IsFractalByWords", IsFGAutomGroup);















































