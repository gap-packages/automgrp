#############################################################################
##
#W  selfsimsg.gd             automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.5
##
#Y  Copyright (C) 2003 - 2013 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsSelfSimSemigroup( <G> )
##
##  Whether semigroup <G> is generated by elements from category IsSelfSim.
##
DeclareSynonym("IsSelfSimSemigroup", IsSemigroup and IsSelfSimCollection);


#############################################################################
##
#O  SelfSimilarSemigroup( <string>[, <bind_vars>] )
#O  SelfSimilarSemigroup( <list>[, <names>, <bind_vars>] )
#O  SelfSimilarSemigroup( <automaton>[, <bind_vars>] )
##
##  Creates the semigroup generated by the wreath recursion, described by <string>
##  or <list>, or given by the argument <automaton>. Note, that on the contrary to
##  `AutomatonSemigroup' ("AutomatonSemigroup") in some cases the defined semigroup
##  may not be self-similar, since the sections of generators may include inverses of
##  generators or trivial homomorphisms, not included in the semigroup generated by the
##  generators. If one needs to have self-similarity it is always possible to include the
##  necessary sections in the generating set.
##
##  The argument <string> is a conventional notation of the form
##  `name1=(word11,word12,...,word1d)trans1, name2=...'
##  where each `name\*' is a name of a state, `word\*' is an associative word
##  over the alphabet consisting of all `name\*', and each `trans\*' is either a
##  permutation written in {\GAP} notation, or a list defining a transformation
##  of the alphabet via `Transformation(trans\*)'. Trivial permutations may be
##  omitted. This function ignores whitespace, and states may be separated
##  by commas or semicolons.
##
##  The argument <list> is a list consisting of $n$ entries corresponding to $n$ generators of the semigroup.
##  Each entry is of the form $[a_1,\.\.\.,a_d,p]$,
##  where $d \geq 2$ is the size of the alphabet the semigroup acts on, $a_i$ are lists
##  acceptable by `AssocWordByLetterRep' (e.g. if the names of generators are `x', `y' and `z',
##  then `[1, 1, 2, 3]' will produce `x^2*y*z')
##  representing the sections of the corresponding generator at all vertices of the first level of the tree;
##  and $p$ is a transformation of the alphabet describing the action of the corresponding
##  generator.
##
##  The optional arguments <names> and <bind_vars> have the same meaning as in `SelfSimilarGroup' (see "SelfSimilarGroup").
##
##  \beginexample
##  gap> SelfSimilarSemigroup("a=(a*b,b)[1,1], b=(a,b^2*a)(1,2)");
##  < a, b >
##  gap> SelfSimilarSemigroup("a=(b,a,a^3)(2,3), b=(1,a*b,b^-1)(1,2,3)");
##  < a, b >
##  gap> A := MealyAutomaton("f0=(f0,f0)(1,2), f1=(f1,f0)[2,2]");
##  <automaton>
##  gap> SelfSimilarSemigroup(A);
##  < f0, f1 >
##  \endexample
##  In the second form of this operation the definition of the first semigroup
##  looks like
##  \beginexample
##  gap> SelfSimilarSemigroup([[[1,2], [2], ()], [[1], [2,2,1], (1,2)]],["a","b"]);
##  < a, b >
##  \endexample
##  The <bind_vars> argument works as follows
##  \beginexample
##  gap> SelfSimilarSemigroup("t = (t^2, t)(1,2)", false);;
##  gap> t;
##  Variable: 't' must have a value
##
##  gap> SelfSimilarSemigroup("t = (t^2, t)(1,2)", true);;
##  gap> t;
##  t
##  \endexample
##
DeclareOperation("SelfSimilarSemigroup", [IsList]);
DeclareOperation("SelfSimilarSemigroup", [IsList, IsList]);
DeclareOperation("SelfSimilarSemigroup", [IsMealyAutomaton]);
DeclareOperation("SelfSimilarSemigroup", [IsList, IsBool]);
DeclareOperation("SelfSimilarSemigroup", [IsList, IsList, IsBool]);
DeclareOperation("SelfSimilarSemigroup", [IsMealyAutomaton, IsBool]);


#############################################################################
##
#A  UnderlyingSelfSimFamily( <G> )
##
##  Returns the family to which elements of <G> belong.
##
DeclareAttribute("UnderlyingSelfSimFamily", IsSelfSimCollection);
InstallSubsetMaintenance(UnderlyingSelfSimFamily, IsCollection, IsCollection);


#############################################################################
##
#A  UnderlyingFreeGenerators(<G>)
#A  UnderlyingFreeMonoid(<G>)
#A  UnderlyingFreeGroup(<G>)
##
DeclareAttribute("UnderlyingFreeGenerators", IsSelfSimSemigroup, "mutable");
DeclareAttribute("UnderlyingFreeMonoid", IsSelfSimSemigroup);
DeclareAttribute("UnderlyingFreeGroup", IsSelfSimSemigroup);


###############################################################################
##
#A  RecurList(<G>)
##
##  Returns an internal representation of the wreath recursion of the
##  self-similar group (semigroup) containing <G>.
##  \beginexample
##  gap> R := SelfSimilarGroup("a=(a^-1*b,b^-1*a)(1,2), b=(a^-1,b^-1)");
##  < a, b >
##  gap> RecurList(R);
##  [ [ [ -1, 2 ], [ -2, 1 ], (1,2) ], [ [ -1 ], [ -2 ], () ],
##    [ [ -1, 2 ], [ -2, 1 ], (1,2) ], [ [ 1 ], [ 2 ], () ] ]
##  \endexample
##
DeclareAttribute("RecurList", IsSelfSimSemigroup, "mutable");

DeclareAttribute("GeneratingRecurList", IsSelfSimSemigroup, "mutable");




#############################################################################
##
#P  IsSemigroupOfSelfSimFamily( <G> )
##
##  Whether semigroup <G> is the whole semigroup generated by the automaton used to
##  construct elements of <G>.
##
#DeclareProperty("IsSemigroupOfSelfSimFamily", IsSelfSimSemigroup);
#InstallTrueMethod(IsSelfSimilar, IsSemigroupOfSelfSimFamily);



#############################################################################
##
#P  IsSelfSimilarSemigroup (<G>)
##
##  is `true' if <G> is created using the command `SelfSimilarSemigroup' ("SelfSimilarSemigroup")
##  or if generators of <G> coincide with generators of corresponding family, and `false' otherwise.
##  To test whether <G> is self-similar use `IsSelfSimilar' ("IsSelfSimilar") command.
DeclareProperty("IsSelfSimilarSemigroup", IsSelfSimSemigroup);
#InstallTrueMethod(IsSemigroupOfSelfSimFamily, IsSelfSimilarSemigroup);


#############################################################################
##
#P  IsFiniteState (<G>)
##
##  For a group or semigroup of homomorphisms of the tree defined using a
##  wreath recursion, returns `true' if all
##  generators can be represented as finite automata (have finitely many different
##  sections).
##  It will never stop if the free reduction of words is not sufficient to establish
##  the finite-state property or if the group is not finite-state.
##  In case <G> is a finite-state group it automatically computes the attributes
##  `UnderlyingAutomatonGroup'(<G>) ("UnderlyingAutomatonGroup"),
##  `IsomorphicAutomGroup'(<G>) ("IsomorphicAutomGroup") and
##  `MonomorphismToAutomatonGroup'(<G>) ("MonomorphismToAutomatonGroup").
##  For a finite-state semigroup it computes the corresponding attributes
##  `UnderlyingAutomatonSemigroup'(<G>) ("UnderlyingAutomatonSemigroup"),
##  `IsomorphicAutomSemigroup'(<G>) ("IsomorphicAutomSemigroup") and
##  `MonomorphismToAutomatonSemigroup'(<G>) ("MonomorphismToAutomatonSemigroup").
##  \beginexample
##  gap> W:=SelfSimilarGroup("x=(x^-1,y)(1,2), y=(z^-1,1)(1,2), z=(1,x*y)");
##  < x, y, z >
##  gap> IsFiniteState(W);
##  true
##  gap> Size(GeneratorsOfGroup(UnderlyingAutomatonGroup(W)));
##  50
##  \endexample
DeclareProperty("IsFiniteState", IsSelfSimSemigroup);


#############################################################################
##
#A  IsomorphicAutomSemigroup(<G>)
##
##  In case <G> is finite-state returns a semigroup generated by automata, isomorphic to <G>,
##  which is a subsemigroup of `UnderlyingAutomatonSemigroup'(<G>) (see "UnderlyingAutomatonSemigroup").
##  The natural isomorphism between <G> and `IsomorphicAutomSemigroup'(<G>) is stored in the
##  attribute `MonomorphismToAutomatonSemigroup'(<G>) ("MonomorphismToAutomatonSemigroup").
##  \beginexample
##  gap> R := SelfSimilarSemigroup("a=(1,1)[1,1], b=(a*c,1)(1,2), c=(1,a*b)");
##  < a, b, c >
##  gap> UR := UnderlyingAutomatonSemigroup(R);
##  < 1, a1, a3, a5, a6 >
##  gap> IR := IsomorphicAutomSemigroup(R);
##  < a1, a3, a5 >
##  gap> hom := MonomorphismToAutomatonSemigroup(R);
##  MappingByFunction( < a, b, c >, < a1, a3, a5 >, function( a ) ... end, functio\
##  n( b ) ... end )
##  gap> (a*b)^hom;
##  a1*a3
##  gap> PreImagesRepresentative(hom, last);
##  a*b
##  gap> List(GeneratorsOfSemigroup(UR), x -> PreImagesRepresentative(hom, x));
##  [ 1, a, b, c, a*b ]
##  \endexample
##
##  All these operations work also for the subsemigroups of semigroups generated by
##  `SelfSimilarSemigroup' ("SelfSimilarSemigroup").
##  \beginexample
##  gap> T := Semigroup([a*b, b^2]);
##  < a*b, b^2 >
##  gap> IT := IsomorphicAutomSemigroup(T);
##  < a1, a4 >
##  \endexample
##  Note, that different semigroups have different `UnderlyingAutomSemigroup' attributes. For example,
##  the generator `a1' of semigroup `IT' above is different from the generator `a1' of semigroup `IR'.
##
DeclareAttribute("IsomorphicAutomSemigroup", IsSelfSimSemigroup, "mutable");


#############################################################################
##
#A  UnderlyingAutomatonSemigroup(<G>)
##
##  In case <G> is finite-state returns a self-similar closure of <G> as a semigroup
##  generated by automaton.
##  The natural monomorphism from <G> and `UnderlyingAutomatonSemigroup'(<G>) is stored in the
##  attribute `MonomorphismToAutomatonSemigroup'(<G>) ("MonomorphismToAutomatonSemigroup"). If
##  <G> is created by `SelfSimilarSemigroup' (see "SelfSimilarSemigroup"), then the self-similar closure
##  of <G> coincides with <G>, so one can use `MonomorphismToAutomatonSemigroup'(<G>) to
##  get preimages of elements of `UnderlyingAutomatonSemigroup'(<G>) in <G>. See the example for
##  `IsomorphicAutomSemigroup' ("IsomorphicAutomSemigroup").
##
DeclareAttribute("UnderlyingAutomatonSemigroup", IsSelfSimSemigroup, "mutable");


#############################################################################
##
#A  MonomorphismToAutomatonSemigroup(<G>)
##
##  In case <G> is finite-state returns a monomorphism from <G> into `UnderlyingAutomatonSemigroup'(<G>)
##  (see "UnderlyingAutomatonSemigroup"). If <G> is created by `SelfSimilarSemigroup'
##  (see "SelfSimilarSemigroup"),
##  then one can use `MonomorphismToAutomatonSemigroup'(<G>) to
##  get preimages of elements of `UnderlyingAutomatonSemigroup'(<G>) in <G>. See the example for
##  `IsomorphicAutomSemigroup' ("IsomorphicAutomSemigroup").
##
DeclareAttribute("MonomorphismToAutomatonSemigroup", IsSelfSimSemigroup, "mutable");

#E
