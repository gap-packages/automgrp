#############################################################################
##
#W  treeautobj.gd              automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.treeautobj_gd :=
  "@(#)$Id$";


###############################################################################
##
#C  IsTreeAutObject
##
DeclareCategory("IsTreeAutObject", IsObject);


###############################################################################
##
#A  SphericalIndex
#A  TopDegreeOfTree
#O  DegreeOfLevel
#P  IsActingOnHomogeneousTree
#A  DegreeOfTree
#P  IsActingOnBinaryTree
##
DeclareAttribute("SphericalIndex", IsTreeAutObject);
DeclareAttribute("TopDegreeOfTree", IsTreeAutObject);
DeclareOperation("DegreeOfLevel", [IsTreeAutObject, IsPosInt]);
DeclareProperty("IsActingOnHomogeneousTree", IsTreeAutObject);
DeclareAttribute("DegreeOfTree", IsTreeAutObject);
DeclareProperty("IsActingOnBinaryTree", IsTreeAutObject);
InstallTrueMethod(IsActingOnHomogeneousTree, IsActingOnBinaryTree);
InstallSubsetMaintenance(SphericalIndex, IsCollection, IsCollection);
InstallSubsetMaintenance(TopDegreeOfTree, IsCollection, IsCollection);
InstallSubsetMaintenance(IsActingOnHomogeneousTree, IsCollection, IsCollection);
InstallSubsetMaintenance(DegreeOfTree, IsCollection, IsCollection);
InstallSubsetMaintenance(IsActingOnBinaryTree, IsCollection, IsCollection);


###############################################################################
##
#P  IsSphericallyTransitive
#O  CanEasilyTestSphericalTransitivity
##
DeclareProperty("IsSphericallyTransitive", IsTreeAutObject);
DeclareFilter("CanEasilyTestSphericalTransitivity");
InstallTrueMethod(CanEasilyTestSphericalTransitivity, IsSphericallyTransitive);


###############################################################################
##
#O  FixesVertex
#O  FixesLevel
#A  FirstMovedLevel
##
DeclareOperation("FixesVertex", [IsTreeAutObject, IsList]);
DeclareOperation("FixesLevel", [IsTreeAutObject, IsPosInt]);
DeclareAttribute("FirstMovedLevel", IsTreeAutObject);


###############################################################################
##
#A  AbelImage(<obj>)
##
DeclareAttribute("AbelImage", IsTreeAutObject);


#E
