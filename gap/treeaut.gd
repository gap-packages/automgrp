#############################################################################
##
#W  treeaut.gd                 automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeAutomorphism
#C  IsTreeAutomorphismFamily
#C  IsTreeAutomorphismCollection
##
DeclareCategory("IsTreeAutomorphism", IsTreeAutObject and
                                      IsMultiplicativeElementWithInverse and
                                      IsAssociativeElement);
DeclareCategoryFamily("IsTreeAutomorphism");
DeclareCategoryCollections("IsTreeAutomorphism");
InstallTrueMethod(IsTreeAutObject, IsTreeAutomorphismFamily);
InstallTrueMethod(IsTreeAutObject, IsTreeAutomorphismCollection);
InstallTrueMethod(IsGeneratorsOfMagmaWithInverses, IsTreeAutomorphismCollection);


###############################################################################
##
#O  TreeAutomorphismFamily(<spherical_index>)
#O  TreeAutomorphism(<states>, <perm>)
##
DeclareOperation("TreeAutomorphismFamily", [IsObject]);
DeclareOperation("TreeAutomorphism", [IsList, IsPerm]);


###############################################################################
##
#C  Perm(<a>)
#C  Perm(<a>, <k>)
#O  PermOnLevel(<a>, <k>)
##
##  In the first form Perm returns the permutation on the first level,
##  in the second form - permutation on k-th level.
##  PermOnLevel does the same. It's here for the reason that the name "Perm"
##  is already taken, so we cannot declare it as KeyDependentOperation.
##
DeclareOperation("Perm", [IsTreeAutomorphism, IsPosInt]);
KeyDependentOperation("PermOnLevel", IsTreeAutomorphism, IsPosInt, ReturnTrue);


###############################################################################
##
#C  State(<a>, <k>)
#C  State(<a>, <vertex>)
##
##  This is the 'state' or 'projection' of given automorphism in given vertex.
##  <vertex> is a list representing vertex;
##  if integer <k> is given, then corresponding vertex on the first level of
##  tree is taken.
##
DeclareOperation("State", [IsTreeAutomorphism, IsList]);


###############################################################################
##
#A  CanEasilyComputeOrder(<a>)
##
DeclareFilter("CanEasilyComputeOrder");


#E
