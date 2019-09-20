#############################################################################
##
#W  tree.gd                 automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
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
##  Returns the degree of the tree on the first level, i.e. the number of vertices
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
##  a regular tree. It is an error to call this method for an object which acts
##  on a non-regular tree.
##
DeclareAttribute("DegreeOfTree", IsActingOnTree);
InstallSubsetMaintenance(DegreeOfTree, IsCollection, IsCollection);

#############################################################################
##
#O  FixesVertex (<obj>, <v>)
##
##  Returns whether <obj> fixes the vertex <v>. The vertex <v> may be given as a list, or as
##  a positive integer, in which case it denotes the <v>-th vertex at the first
##  level.
##
DeclareOperation("FixesVertex", [IsActingOnTree, IsObject]);

#############################################################################
##
#O  FixesLevel (<obj>, <lev>)
##
##  Returns whether <obj> fixes level <lev>, i.e. fixes every vertex at the level
##  <lev>.
##
DeclareOperation("FixesLevel", [IsActingOnTree, IsPosInt]);

#############################################################################
##
#A  AbelImage(<obj>)
##
##  Returns image of <obj> in the canonical projection onto the abelianization of
##  the full group of tree automorphisms, represented as a subgroup of the additive
##  group of rational functions.
##
DeclareAttribute("AbelImage", IsActingOnTree);

#XXX it doesn't make sense for non-invertible automata, does it?

#E
