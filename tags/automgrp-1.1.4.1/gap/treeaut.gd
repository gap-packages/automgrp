#############################################################################
##
#W  treeaut.gd                 automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeAutomorphism
##
##  Category of rooted tree automorphisms.
##
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
##  Constructs the tree automorphism with states on the first level given by the
##  argument <states> and acting
##  on the first level as the permutation <perm>. The <states> must
##  belong to the same family.
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> r := TreeAutomorphism([p, q, p, q^2],(1,2)(3,4));
##  (p, q, p, q^2)(1,2)(3,4)
##  gap> t := TreeAutomorphism([q, 1, p*q, q],(1,2));
##  (q, 1, p*q, q)(1,2)
##  gap> r*t;
##  (p, q^2, p*q, q^2*p*q)(3,4)
##  \endexample
##
DeclareOperation("TreeAutomorphism", [IsList, IsPerm]);
DeclareOperation("TreeAutomorphismFamily", [IsObject]);


###############################################################################
##
#O  Perm( <a>[, <lev>] )
##
##  Returns the permutation induced by the tree automorphism <a> on the level <lev>
##  (or first level if <lev> is not given). See also
##  `TransformationOnLevel'~("TransformationOnLevel").
##
DeclareOperation("Perm", [IsTreeAutomorphism, IsPosInt]);

###############################################################################
##
#O  PermOnLevel( <a>, <k> )
##
##  Does the same thing as `Perm'~("Perm").
##
KeyDependentOperation("PermOnLevel", IsTreeAutomorphism, IsPosInt, ReturnTrue);




#E
