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
##  <#GAPDoc Label="IsActingOnTree">
##  <ManSection>
##  <Filt Name="IsActingOnTree" Arg="" Type="Category"/>
##  <Description>
##  This is a category to which all objects acting on a tree belong: tree
##  homomorphisms and groups and semigroups acting on trees.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory("IsActingOnTree", IsObject);


#############################################################################
##
#A  SphericalIndex (<obj>)
##
##  <#GAPDoc Label="SphericalIndex">
##  <ManSection>
##  <Attr Name="SphericalIndex" Arg="obj"/>
##  <Description>
##  Returns the <Q>spherical index</Q> of the tree on which <A>obj</A> acts. It is returned
##  as a tuple of two lists [start, period], where start may be empty.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("SphericalIndex", IsActingOnTree);
InstallSubsetMaintenance(SphericalIndex, IsCollection, IsCollection);

#############################################################################
##
#A  TopDegreeOfTree (<obj>)
##
##  <#GAPDoc Label="TopDegreeOfTree">
##  <ManSection>
##  <Attr Name="TopDegreeOfTree" Arg="obj"/>
##  <Description>
##  Returns the degree of the tree on the first level, i.e. the number of vertices
##  adjacent to the root vertex.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("TopDegreeOfTree", IsActingOnTree);
InstallSubsetMaintenance(TopDegreeOfTree, IsCollection, IsCollection);

#############################################################################
##
#O  DegreeOfLevel (<obj>, <lev>)
##
##  <#GAPDoc Label="DegreeOfLevel">
##  <ManSection>
##  <Oper Name="DegreeOfLevel" Arg="obj, lev"/>
##  <Description>
##  Returns degree of the tree on the level <A>lev</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("DegreeOfLevel", [IsActingOnTree, IsPosInt]);

#############################################################################
##
#P  IsActingOnRegularTree (<obj>)
##
##  <#GAPDoc Label="IsActingOnRegularTree">
##  <ManSection>
##  <Prop Name="IsActingOnRegularTree" Arg="obj"/>
##  <Description>
##  Tells whether <A>obj</A> is acting on a <Ref Func="regular"/> tree.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsActingOnRegularTree", IsActingOnTree);
InstallSubsetMaintenance(IsActingOnRegularTree, IsCollection, IsCollection);

#############################################################################
##
#P  IsActingOnBinaryTree (<obj>)
##
##  <#GAPDoc Label="IsActingOnBinaryTree">
##  <ManSection>
##  <Prop Name="IsActingOnBinaryTree" Arg="obj"/>
##  <Description>
##  Tells whether <A>obj</A> is acting on a <Q>binary</Q> tree.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsActingOnBinaryTree", IsActingOnTree);
InstallSubsetMaintenance(IsActingOnBinaryTree, IsCollection, IsCollection);
InstallTrueMethod(IsActingOnRegularTree, IsActingOnBinaryTree);

#############################################################################
##
#A  DegreeOfTree (<obj>)
##
##  <#GAPDoc Label="DegreeOfTree">
##  <ManSection>
##  <Attr Name="DegreeOfTree" Arg="obj"/>
##  <Description>
##  This is a synonym for TopDegreeOfTree&nbsp;(<Ref Func="TopDegreeOfTree"/>) for the case of
##  a regular tree. It is an error to call this method for an object which acts
##  on a non-regular tree.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("DegreeOfTree", IsActingOnTree);
InstallSubsetMaintenance(DegreeOfTree, IsCollection, IsCollection);

#############################################################################
##
#O  FixesVertex (<obj>, <v>)
##
##  <#GAPDoc Label="FixesVertex">
##  <ManSection>
##  <Oper Name="FixesVertex" Arg="obj, v"/>
##  <Description>
##  Returns whether <A>obj</A> fixes the vertex <A>v</A>. The vertex <A>v</A> may be given as a list, or as
##  a positive integer, in which case it denotes the <A>v</A>-th vertex at the first
##  level.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("FixesVertex", [IsActingOnTree, IsObject]);

#############################################################################
##
#O  FixesLevel (<obj>, <lev>)
##
##  <#GAPDoc Label="FixesLevel">
##  <ManSection>
##  <Oper Name="FixesLevel" Arg="obj, lev"/>
##  <Description>
##  Returns whether <A>obj</A> fixes level <A>lev</A>, i.e. fixes every vertex at the level
##  <A>lev</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("FixesLevel", [IsActingOnTree, IsPosInt]);

#############################################################################
##
#A  AbelImage(<obj>)
##
##  <#GAPDoc Label="AbelImage">
##  <ManSection>
##  <Attr Name="AbelImage" Arg="obj"/>
##  <Description>
##  Returns image of <A>obj</A> in the canonical projection onto the abelianization of
##  the full group of tree automorphisms, represented as a subgroup of the additive
##  group of rational functions.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("AbelImage", IsActingOnTree);

#XXX it doesn't make sense for non-invertible automata, does it?

#E
