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
##  `Transformation' otherwise.
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



###############################################################################
##
#O  Representative( <word>, <fam> )
#O  Representative( <word>, <a> )
##
##  Given assosiative word <word> constructs a tree homomorphism from the family
##  <fam>, or to which homomorphism <a> belongs. This function is useful when
##  one needs to make some operations with associative words. See also `Word' ("Word").
##  \beginexample
##  gap> G := AutomatonGroup("a=(a,b)(1,2), b=(a,b)");
##  < a, b >
##  gap> F := UnderlyingFreeGroup(G);
##  <free group on the generators [ a, b ]>
##  gap> c := Representative( F.1*F.2^2, a);
##  a*b^2
##  gap> Decompose(c);
##  (a*b^2, b*a^2)(1,2)
##  gap> H := SelfSimilarGroup("x=(x*y,x)(1,2), y=(x^-1,y)");
##  < x, y >
##  gap> F := UnderlyingFreeGroup(H);
##  <free group on the generators [ x, y ]>
##  gap> c := SelfSim( F.1^-1*F.2, x);
##  x^-1*y
##  gap> Decompose(c);
##  (x^-1*y, y^-1*x^-2)(1,2)
##  \endexample
##
DeclareOperation("Representative", [IsAssocWord, IsTreeHomomorphism]);
DeclareOperation("Representative", [IsAssocWord, IsTreeHomomorphismFamily]);


###############################################################################
##
#O  Word( <a> )
##
##  Returns <a> as an associative word (an element of underlying free group) in
##  generators of the self-similar group (semigroup) to which <a> belongs.
##  \beginexample
##  gap> w:=Word(a*b^2*a^-1);
##  a*b^2*a^-1
##  gap> Length(w);
##  4
##  \endexample
##
DeclareOperation("Word", [IsTreeHomomorphism]);


DeclareGlobalFunction("AG_TreeHomomorphismCmp");


#############################################################################
##
#P  IsSphericallyTransitive ( <a> )
##
##  Returns whether the action of <a> is spherically transitive (see "Short math background").
##
DeclareProperty("IsSphericallyTransitive", IsTreeHomomorphism);
# XXX CanEasilyTestSphericalTransitivity isn't really used except for
# automorphisms of binary tree
DeclareFilter("CanEasilyTestSphericalTransitivity");
InstallTrueMethod(CanEasilyTestSphericalTransitivity, IsSphericallyTransitive);

#############################################################################
##
#O  IsTransitiveOnLevel ( <a>, <lev> )
##
##  Returns whether <a> acts transitively on level <lev> of the tree.
##
DeclareOperation("IsTransitiveOnLevel", [IsTreeHomomorphism, IsPosInt]);


#E
