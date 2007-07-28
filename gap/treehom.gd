#############################################################################
##
#W  treehom.gd              automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsTreeHomomorphism
##
##  Category of level-preserving rooted tree homomorphisms.
##
DeclareCategory("IsTreeHomomorphism", IsActingOnTree and
                                      IsMultiplicativeElementWithOne and
                                      IsAssociativeElement);
DeclareCategoryFamily("IsTreeHomomorphism");
DeclareCategoryCollections("IsTreeHomomorphism");
InstallTrueMethod(IsActingOnTree, IsTreeHomomorphismFamily);
InstallTrueMethod(IsActingOnTree, IsTreeHomomorphismCollection);


# XXX
DeclareAttribute("AutomatonList", IsTreeHomomorphism and IsActingOnRegularTree, "mutable");


###############################################################################
##
#O  TreeHomomorphism( <states>, <tr> )
##
##  Constructs an automaton transformation with states <states> and acting
##  on the first level with transformation <tr>.
##
DeclareOperation("TreeHomomorphism", [IsList, IsObject]);

###############################################################################
##
#O  TreeHomomorphismFamily( <sph_ind> )
##
##  Constructs a family to which all homomorphisms of a tree with spherical
##  index <sph_ind> belong. It is used internally, objects created with
##  `TreeAutomorphism' belong to this family.
##
DeclareOperation("TreeHomomorphismFamily", [IsObject]);


###############################################################################
##
#O  TransformationOnLevel( <a>, <lev> )
#O  TransformationOnFirstLevel( <a> )
##
##  The first function returns transformation induced by tree homomorphism
##  <a> on the level <lev>. See also `PermOnLevel'~("PermOnLevel").
##
##  If the transformation is invertible then it returns a permutation, and
##  `Transformation'~("ref:Transformation") otherwise.
##
##  `TransformationOnFirstLevel'(<a>) is equivalent to
##  `TransformationOnLevel'(<a>, `1').
##
KeyDependentOperation("TransformationOnLevel", IsTreeHomomorphism, IsPosInt, ReturnTrue);
DeclareAttribute("TransformationOnFirstLevel", IsTreeHomomorphism);


###############################################################################
##
#O  Section( <a>, <v> )
##
##  Returns the section of automorphism (homomorphism) <a> at vertex <v>.
##  Vertex <v> can be a list representing vertex, or a positive integer
##  representing a vertex of the first level of the tree.
##  \beginexample
##  gap> Section(a*b*a^2,[1,2,2,1,2,1]);
##  a^2*b^2
##  \endexample
##
DeclareOperation("Section", [IsTreeHomomorphism, IsList]);
DeclareOperation("Section", [IsTreeHomomorphism, IsPosInt]);

###############################################################################
##
#O  Sections( <a> [, <lev>] )
##
##  Returns the list of sections of <a> at the <lev>-th level. If <lev> is ommited
##  it is assumed to be 1.
##  \beginexample
##  gap> Sections(a*b*a^2);
##  [ a*b^2*a, b*a^2*b ]
##  \endexample
##
DeclareOperation("Sections", [IsTreeHomomorphism]);

###############################################################################
##
#O  Decompose( <a>[, <k>] )
##
##  Returns a decomposition of tree homomorphism <a> on the <k>-th level of the tree, i.e. the
##  representation of the form $$a = (a_1, a_2, \ldots, a_{d_1\times...\times d_k})\sigma$$
##  where $a_i$ are the sections of <a> at the <k>-th level, and $\sigma$ is the
##  transformation of the <k>-th level. If <k> is omitted it is assumed to be 1.
##  \beginexample
##  gap> Decompose(a*b^2);
##  (a*b^2, b*a^2)(1,2)
##  gap> Decompose(a*b^2,3);
##  (a*b^2, b*a^2, a^2*b, b^2*a, a*b*a, b*a*b, a^3, b^3)(1,8,3,5)(2,7,4,6)
##  \endexample
##
DeclareOperation("Decompose", [IsTreeHomomorphism]);
DeclareOperation("Decompose", [IsTreeHomomorphism, IsPosInt]);


DeclareGlobalFunction("AG_TreeHomomorphismCmp");


#E
