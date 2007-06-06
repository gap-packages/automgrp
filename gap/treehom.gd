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
DeclareOperation("TreeHomomorphism", [IsList, IsTransformation]);

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
#O  TransformationOnLevel( <a>[, <lev>] )
##
##  Returns transformation induced by tree homomorphism <a> on the level <lev>
##  (or first level if <lev> is not given). See also "Perm".
##
KeyDependentOperation("TransformationOnLevel", IsTreeHomomorphism, IsPosInt, ReturnTrue);

###############################################################################
##
#O  State( <a>, <v> )
##
##  Returns the "state" of given automorphism at the given vertex.
##  Vertex <v> can be a list representing vertex; or a positive integer
##  representing a vertex at the first level of the tree.
##  \beginexample
##  gap> State(a*b*a^2,[1,2,2,1,2,1]);
##  a^2*b^2
##  \endexample
##
DeclareOperation("State", [IsTreeHomomorphism, IsList]);
DeclareOperation("State", [IsTreeHomomorphism, IsPosInt]);

###############################################################################
##
#O  States( <a> )
##
##  Returns list of states of <a> at the first level.
##  \beginexample
##  gap> States(a*b*a^2);
##  [ a*b^2*a, b*a^2*b ]
##  \endexample
##
DeclareOperation("States", [IsTreeHomomorphism]);

###############################################################################
##
#O  Expand( <a>[, <k>] )
##
##  Returns an ``expanded'' form of tree homomorphism <a>, i.e. the
##  representation of the form $$a = (a_1, a_2, ..., a_{d_1\times...\times d_k})s$$
##  where $a_i$ are the states of <a> at the <k>-th level, and $s$ is the
##  transformation of the k-th level. By default <k> is equal to 1.
##  \beginexample
##  gap> Expand(a*b^2);
##  (a*b^2, b*a^2)(1,2)
##  gap> Expand(a*b^2,3);
##  (a*b^2, b*a^2, a^2*b, b^2*a, a*b*a, b*a*b, a^3, b^3)(1,8,3,5)(2,7,4,6)
##  \endexample
##
DeclareOperation("Expand", [IsTreeHomomorphism]);
DeclareOperation("Expand", [IsTreeHomomorphism, IsPosInt]);


#E
