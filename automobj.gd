#############################################################################
##
#W  automobj.gd              automata package                  Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


##
##	AutomObj is category parent for all automata categories - IsAutom, 
##	IsAGroup etc.
##

###############################################################################
##
#C  IsAutomObj
##
DeclareCategory("IsAutomObj", IsObject);


###############################################################################
##
#O  Projection(<object>, <number>)
#O  LeftProjection(<object>)
#O  RightProjection(<object>)
##
DeclareOperation("Projection", [IsAutomObj, IsInt]);
DeclareOperation("LeftProjection", [IsAutomObj]);
DeclareOperation("RightProjection", [IsAutomObj]);


###############################################################################
##
#O  Perm(<autom>, <level>)
#A  TopPerm(<autom>)
##
DeclareOperation("Perm", [IsAutomObj, IsInt]);
DeclareAttribute("TopPerm", IsAutomObj);


# ###############################################################################
# ##
# #O  Degree(<object>)
# ##
# DeclareOperation("Degree", [IsAutomObj]);
# 
# 
# ###############################################################################
# ##
# #O  IsActingOnBinaryTree
# ##
# DeclareOperation("IsActingOnBinaryTree", IsAutomObj);


# ###############################################################################
# ##
# #A  AbelianType
# ##
# DeclareAttribute("AbelianType", IsAutomaton);
# 
# ###############################################################################
# ##
# #O  CanEasilyCheckSphericalTransitivity
# ##
# ##  It and CanEasilyComputeOrder (and maybe something else?) are not properties
# ##  because of crossreferences.
# ##
# DeclareOperation("CanEasilyCheckSphericalTransitivity", [IsAutomaton]);
# 
# ###############################################################################
# ##
# #P  IsSphericallyTransitive
# ##
# DeclareProperty("IsSphericallyTransitive", IsAutomaton);
# 
# 
# ###############################################################################
# ##
# #A  Heigth
# ##
# DeclareAttribute("Heigth", IsAutomaton);
# 
# 
# ###############################################################################
# ##
# #O  CanEasilyComputeOrder
# ##
# DeclareOperation("CanEasilyComputeOrder", [IsAutomaton]);




