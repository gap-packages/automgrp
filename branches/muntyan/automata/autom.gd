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


# ###############################################################################
# ##
# #O  ProductOfAutomataList(<automaton>)
# ##
# DeclareOperation("ProductOfAutomataList", [IsList]);


# ###############################################################################
# ##
# #A  AbelianType
# ##
# DeclareAttribute("AbelianType", IsAutomaton);
# 
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




###############################################################################
##
#P  IsActingOnBinaryTree
##
DeclareProperty("IsActingOnBinaryTree", IsAutomFamily);
