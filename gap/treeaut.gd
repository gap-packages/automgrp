#############################################################################
##
#W  treeaut.gd                 automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeAutomorphism
##
##  <#GAPDoc Label="IsTreeAutomorphism">
##  <ManSection>
##  <Filt Name="IsTreeAutomorphism" Arg="" Type="Category"/>
##  <Description>
##  Category of rooted tree automorphisms.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory("IsTreeAutomorphism", IsTreeHomomorphism and
                                      IsMultiplicativeElementWithInverse);
DeclareCategoryFamily("IsTreeAutomorphism");
DeclareCategoryCollections("IsTreeAutomorphism");
InstallTrueMethod(IsActingOnTree, IsTreeAutomorphismFamily);
InstallTrueMethod(IsActingOnTree, IsTreeAutomorphismCollection);
InstallTrueMethod(IsGeneratorsOfMagmaWithInverses, IsTreeAutomorphismCollection);


###############################################################################
##
#O  TreeAutomorphism( <states>, <perm> )
##
##  <#GAPDoc Label="TreeAutomorphism">
##  <ManSection>
##  <Oper Name="TreeAutomorphism" Arg="states, perm"/>
##  <Description>
##  Constructs the tree automorphism with states on the first level given by the
##  argument <A>states</A> and acting
##  on the first level as the permutation <A>perm</A>. The <A>states</A> must
##  belong to the same family.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> r := TreeAutomorphism([p, q, p, q^2],(1,2)(3,4));
##  (p, q, p, q^2)(1,2)(3,4)
##  gap> t := TreeAutomorphism([q, 1, p*q, q],(1,2));
##  (q, 1, p*q, q)(1,2)
##  gap> r*t;
##  (p, q^2, p*q, q^2*p*q)(3,4)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("TreeAutomorphism", [IsList, IsPerm]);
DeclareOperation("TreeAutomorphismFamily", [IsObject]);
DeclareOperation("TreeAutomorphism", [IsObject, IsObject, IsPerm]);
DeclareOperation("TreeAutomorphism", [IsObject, IsObject, IsObject, IsPerm]);
DeclareOperation("TreeAutomorphism", [IsObject, IsObject, IsObject, IsObject, IsPerm]);
DeclareOperation("TreeAutomorphism", [IsObject, IsObject, IsObject, IsObject, IsObject, IsPerm]);


#E
