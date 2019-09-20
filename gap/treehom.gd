#############################################################################
##
#W  treehom.gd              automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
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
##  Constructs an homomorphism with states <states> and acting
##  on the first level with transformation <tr>. The <states> must
##  belong to the same family.
##  \beginexample
##  gap> S := AutomatonSemigroup("a=(a,b)[1,1],b=(b,a)(1,2)");
##  < a, b >
##  gap> x := TreeHomomorphism([a,b^2,a,a*b],Transformation([3,1,2,2]));
##  (a, b^2, a, a*b)[3,1,2,2]
##  gap> y := TreeHomomorphism([a*b,b,b,b^2],Transformation([1,4,2,3]));
##  (a*b, b, b, b^2)[1,4,2,3]
##  gap> x*y;
##  (a*b, b^2*a*b, a*b, a*b^2)[2,1,4,4]
##  \endexample
##


##
DeclareOperation("TreeHomomorphism", [IsList, IsObject]);

###############################################################################
##
#M  TreeHomomorphism(<state_1>, <state_2>, ..., <state_n>, <perm>)
##
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsTransformation]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsTransformation]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsObject, IsTransformation]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsPerm]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsPerm]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsObject, IsPerm]);


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
##  The first function returns the transformation induced by the tree homomorphism
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
#O  Perm( <a>[, <lev>] )
##
##  Returns the permutation induced by the tree automorphism <a> on the level <lev>
##  (or first level if <lev> is not given). See also
##  `TransformationOnLevel'~("TransformationOnLevel").
##
DeclareOperation("Perm", [IsTreeHomomorphism]);
DeclareOperation("Perm", [IsTreeHomomorphism, IsPosInt]);

###############################################################################
##
#O  PermOnLevel( <a>, <k> )
##
##  Does the same thing as `Perm'~("Perm").
##
KeyDependentOperation("PermOnLevel", IsTreeHomomorphism, IsPosInt, ReturnTrue);


###############################################################################
##
#O  Section( <a>, <v> )
##
##  Returns the section of the automorphism (homomorphism) <a> at the vertex <v>.
##  The vertex <v> can be a list representing the vertex, or a positive integer
##  representing a vertex of the first level of the tree.
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> Section(p*q*p^2, [1,2,2,1,2,1]);
##  p^2*q^2
##  \endexample
##
DeclareOperation("Section", [IsTreeHomomorphism, IsList]);
DeclareOperation("Section", [IsTreeHomomorphism, IsPosInt]);

###############################################################################
##
#O  Sections( <a> [, <lev>] )
##
##  Returns the list of sections of <a> at the <lev>-th level. If <lev> is omitted
##  it is assumed to be 1.
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> Sections(p*q*p^2);
##  [ p*q^2*p, q*p^2*q ]
##  \endexample
##
DeclareOperation("Sections", [IsTreeHomomorphism]);
DeclareOperation("Sections", [IsTreeHomomorphism, IsCyclotomic]);

###############################################################################
##
#O  Decompose( <a>[, <k>] )
##
##  Returns the decomposition of the tree homomorphism <a> on the <k>-th level of the tree, i.e. the
##  representation of the form $$a = (a_1, a_2, \ldots, a_{d_1\times...\times d_k})\sigma$$
##  where $a_i$ are the sections of <a> at the <k>-th level, and $\sigma$ is the
##  transformation of the <k>-th level. If <k> is omitted it is assumed to be 1.
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> Decompose(p*q^2);
##  (p*q^2, q*p^2)(1,2)
##  gap> Decompose(p*q^2,3);
##  (p*q^2, q*p^2, p^2*q, q^2*p, p*q*p, q*p*q, p^3, q^3)(1,8,3,5)(2,7,4,6)
##  \endexample
##
DeclareOperation("Decompose", [IsTreeHomomorphism]);
DeclareOperation("Decompose", [IsTreeHomomorphism, IsPosInt]);
DeclareOperation("Decompose", [IsTreeHomomorphism, IsInt and IsZero]);



###############################################################################
##
#O  Representative( <word>, <fam> )
#O  Representative( <word>, <a> )
##
##  Given an associative word <word> constructs the tree homomorphism from the family
##  <fam>, or to which homomorphism <a> belongs. This function is useful when
##  one needs to make some operations with associative words. See also `Word' ("Word").
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> F := UnderlyingFreeGroup(L);
##  <free group on the generators [ p, q ]>
##  gap> r := Representative(F.1*F.2^2, p);
##  p*q^2
##  gap> Decompose(r);
##  (p*q^2, q*p^2)(1,2)
##  gap> H := SelfSimilarGroup("x=(x*y,x)(1,2), y=(x^-1,y)");
##  < x, y >
##  gap> F := UnderlyingFreeGroup(H);
##  <free group on the generators [ x, y ]>
##  gap> r := Representative(F.1^-1*F.2, x);
##  x^-1*y
##  gap> Decompose(r);
##  (x^-1*y, y^-1*x^-2)(1,2)
##  \endexample
##
DeclareOperation("Representative", [IsAssocWord, IsTreeHomomorphism]);
DeclareOperation("Representative", [IsAssocWord, IsTreeHomomorphismFamily]);


###############################################################################
##
#O  Word( <a> )
##
##  Returns <a> as an associative word (an element of the underlying free group) in
##  the generators of the self-similar group (semigroup) to which <a> belongs.
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> w := Word(p*q^2*p^-1);
##  p*q^2*p^-1
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


#############################################################################
###
##O  \^ ( <ver>, <a> )
###
###  Returns the image of a vertex <ver> under the action of a homomorphism <a>.
###
DeclareOperation("\^", [IsList, IsTreeHomomorphism]);

###DeclareOperation("\^", [IsPosInt, IsTreeHomomorphism]);


###############################################################################
##
#A  AllSections( <a> )
##
##  Returns the list of all sections of <a> if there are finitely many of them and
##  this fact can be established using free reduction of words in sections. Otherwise
##  will never stop. Note, that in the case when <a> is an element of a self-similar
##  (semi)group defined by wreath recurion it does not check whether all elements of the list
##  are actually different automorphisms (homomorphisms) of the tree. If <a> is a element of
##  of a (semi)group generated by finite automaton, it will always return the list of
##  all distinct sections of <a>.
##  \beginexample
##  gap> D := SelfSimilarGroup("x=(1,y)(1,2), y=(z^-1,1)(1,2), z=(1,x*y)");
##  < x, y, z >
##  gap> AllSections(x*y^-1);
##  [ x*y^-1, z, 1, x*y, y*z^-1, z^-1*y^-1*x^-1, y^-1*x^-1*z*y^-1, z*y^-1*x*y*z,
##    y*z^-1*x*y, z^-1*y^-1*x^-1*y*z^-1, x*y*z, y, z^-1, y^-1*x^-1, z*y^-1 ]
##  \endexample
##
DeclareAttribute("AllSections", IsTreeHomomorphism);


#E
