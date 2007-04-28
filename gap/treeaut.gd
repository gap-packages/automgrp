#############################################################################
##
#W  treeaut.gd                 automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
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
##  Constructs a tree automorphism with states <states> and acting
##  on the first level as permutation <perm>.
##
DeclareOperation("TreeAutomorphism", [IsList, IsPerm]);
DeclareOperation("TreeAutomorphismFamily", [IsObject]);


###############################################################################
##
#O  Perm( <a>[, <lev>] )
##
##  Returns permutation induced by tree automorphism <a> on the level <lev>
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

#############################################################################
##
#P  IsSphericallyTransitive( <a> )
##
##  Whether action of <a> is "spherically transitive".
##
DeclareProperty("IsSphericallyTransitive", IsTreeAutomorphism);
# XXX CanEasilyTestSphericalTransitivity isn't really used except for
# automorphisms of binary tree
DeclareFilter("CanEasilyTestSphericalTransitivity");
InstallTrueMethod(CanEasilyTestSphericalTransitivity, IsSphericallyTransitive);

#############################################################################
##
#O  IsTransitiveOnLevel( <a>, <lev> )
##
##  Whether <a> acts transitively on level <lev>.
##
DeclareOperation("IsTransitiveOnLevel", [IsTreeAutomorphism, IsPosInt]);


#E
