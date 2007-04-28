#############################################################################
##
#W  tree.gd                 automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsActingOnTree
##
##  This is a category to which all objects acting on a tree belong: tree
##  homomorphisms and groups and semigroups acting on trees.
##
DeclareCategory("IsActingOnTree", IsObject);


#############################################################################
##
#A  SphericalIndex (<obj>)
##
##  Returns "spherical index" of the tree on which <obj> acts. It is returned
##  as a tuple of two lists [start, period], where start may be empty.
##
DeclareAttribute("SphericalIndex", IsActingOnTree);
InstallSubsetMaintenance(SphericalIndex, IsCollection, IsCollection);

#############################################################################
##
#A  TopDegreeOfTree (<obj>)
##
##  Returns degree of the tree on the first level, i.e. the number of vertices
##  adjacent to the root vertex.
##
DeclareAttribute("TopDegreeOfTree", IsActingOnTree);
InstallSubsetMaintenance(TopDegreeOfTree, IsCollection, IsCollection);

#############################################################################
##
#O  DegreeOfLevel (<obj>, <lev>)
##
##  Returns degree of the tree on the level <lev>.
##
DeclareOperation("DegreeOfLevel", [IsActingOnTree, IsPosInt]);

#############################################################################
##
#P  IsActingOnRegularTree (<obj>)
##
##  Tells whether <obj> is acting on a "regular" tree.
##
DeclareProperty("IsActingOnRegularTree", IsActingOnTree);
InstallSubsetMaintenance(IsActingOnRegularTree, IsCollection, IsCollection);

#############################################################################
##
#P  IsActingOnBinaryTree (<obj>)
##
##  Tells whether <obj> is acting on a "binary" tree.
##
DeclareProperty("IsActingOnBinaryTree", IsActingOnTree);
InstallSubsetMaintenance(IsActingOnBinaryTree, IsCollection, IsCollection);
InstallTrueMethod(IsActingOnRegularTree, IsActingOnBinaryTree);

#############################################################################
##
#A  DegreeOfTree (<obj>)
##
##  This is a synonym for TopDegreeOfTree~("TopDegreeOfTree") for the case of
##  regular tree. It is an error to call this method for an object which acts
##  on a non-regular tree.
##
DeclareAttribute("DegreeOfTree", IsActingOnTree);
InstallSubsetMaintenance(DegreeOfTree, IsCollection, IsCollection);

#############################################################################
##
#O  FixesVertex (<obj>, <v>)
##
##  Whether <obj> fixes vertex <v>. Vertex <v> may be given as a list, or as
##  a positive integer, in which case it denotes <v>-th vertex at the first
##  level.
##
DeclareOperation("FixesVertex", [IsActingOnTree, IsObject]);

#############################################################################
##
#O  FixesLevel (<obj>, <lev>)
##
##  Whether <obj> fixes level <lev>, i.e. fixes every vertex at the level
##  <lev>.
##
DeclareOperation("FixesLevel", [IsActingOnTree, IsPosInt]);

#############################################################################
##
#A  FirstMovedLevel (<obj>)
##
##  First level on which <obj> acts non-trivially if such a level exists
##  (i.e. if <obj> is not trivial), or `infinity'.
##
DeclareAttribute("FirstMovedLevel", IsActingOnTree);

#############################################################################
##
#A  AbelImage(<obj>)
##
##  Returns image of <obj> in canonical projection onto abelianization of
##  the full group of tree automorphisms, represented as a subgroup of additive
##  group of rational functions.
##  XXX it doesn't make sense for non-invertible automata, does it?
##
DeclareAttribute("AbelImage", IsActingOnTree);


#E
