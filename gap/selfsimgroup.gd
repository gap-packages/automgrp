#############################################################################
##
#W  selfsimgroup.gd           automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsSelfSimGroup
##
##  The category of groups generated by finite invertible initial automata
##  (elements from category `IsSelfSim').
##
DeclareSynonym("IsSelfSimGroup", IsSelfSimCollection and IsGroup);
InstallTrueMethod(IsTreeAutomorphismCollection, IsSelfSimGroup);
InstallTrueMethod(IsInvertibleSelfSimCollection, IsSelfSimGroup);


#############################################################################
##
#O  SelfSimilarGroup( <string>[, <bind_vars>] )
#O  SelfSimilarGroup( <list>[, <names>, <bind_vars>] )
#O  SelfSimilarGroup( <automaton>[, <bind_vars>] )
##
##  Creates the self-similar group generated by the wreath recursion, described by <string>
##  or <list>, or given as an argument <automaton>.
##
##  The <string> is a conventional notation of the form
##  `name1 = (word11, word12, ..., word1d)perm1, name2 = ...'
##  where each `name\*' is a name of state, `word\*' is an associative word
##  over the alphabet consisting of all `name\*', and each `perm\*' is a
##  permutation written in {\GAP} notation. Trivial permutations may be
##  omitted. This function ignores whitespace, and states may be separated
##  by commas or semicolons.
##
##  The <list> is a list consisting of $n$ entries corresponding to $n$ generators of a group.
##  Each entry is of the form $[a_1,\.\.\.,a_d,p]$,
##  where $d \geq 2$ is the size of the alphabet the group acts on, $a_i$ are the lists
##  acceptable by `AssocWordByLetterRep' (e.g. if the names of generators are `x', `y' and `z',
##  then `[1, 1, -2, -2, 1, 3]' will produce `x^2*y^-2*x*z')
##  representing the sections of corresponding generator at all vertices of the first level of the tree;
##  and $p$ is in `SymmetricGroup(<d>)' describes the action of the corresponding generator on the
##  alphabet.
##
##  Optional <names> must be a list of names of generators of the group.
##  These names are used to display the elements of resulted group.
##
##  If optional <bind_vars> is `false' the names of generators of the group are not assigned
##  to the global variables. The default value is `true'. One can use
##  `AssignGeneratorVariables' function to assign these names later, if they were not assigned
##  when the group was created.
##
##  \beginexample
##  gap> SelfSimilarGroup("a = (a*b, b^-1), b = (1, b^2*a)(1,2)");
##  < a, b >
##  gap> SelfSimilarGroup("a=(b, a, a^-1)(2,3), b=(1, a*b, b)(1,2,3)");
##  < a, b >
##  gap> A:=MealyAutomaton("f0=(f0,f0)(1,2),f1=(f1,f0)");
##  <automaton>
##  gap> SelfSimilarGroup(A);
##  < f0, f1 >
##  \endexample
##  In the second form of this operation the definition of the first group
##  looks like
##  \beginexample
##  gap> SelfSimilarGroup([ [ [1,2], [-2], ()], [ [], [2,2,1], (1,2) ] ], ["a","b"]);
##  < a, b >
##  \endexample
##  The <bind_vars> argument works as follows
##  \beginexample
##  gap> SelfSimilarGroup("t = (t^2, t)(1,2)", false);;
##  gap> t;
##  Variable: 't' must have a value
##  gap> SelfSimilarGroup("t = (t^2, t)(1,2)", true);;
##  gap> t;
##  t
##  \endexample
##
DeclareOperation("SelfSimilarGroup", [IsList]);
DeclareOperation("SelfSimilarGroup", [IsList, IsList]);
DeclareOperation("SelfSimilarGroup", [IsList, IsBool]);
DeclareOperation("SelfSimilarGroup", [IsList, IsList, IsBool]);
DeclareOperation("SelfSimilarGroup", [IsMealyAutomaton]);
DeclareOperation("SelfSimilarGroup", [IsMealyAutomaton, IsBool]);



#############################################################################
##
#P  IsGroupOfSelfSimFamily( <G> )
##
##  Whether group <G> is the whole group generated by the automaton used to
##  construct elements of <G>.
##
DeclareProperty("IsGroupOfSelfSimFamily", IsSelfSimGroup);
InstallTrueMethod(IsSelfSimilar, IsGroupOfSelfSimFamily);


#############################################################################
##
#A  UnderlyingFreeSubgroup(<G>)
##
DeclareAttribute("UnderlyingFreeSubgroup", IsSelfSimGroup, "mutable");


#############################################################################
##
#A  IndexInFreeGroup(<G>)
##
DeclareAttribute("IndexInFreeGroup", IsSelfSimGroup, "mutable");





#############################################################################
##
#P  IsSelfSimilarGroup (<G>)
##
##  is `true' if generators of <G> coincide with generators
##  of `GroupOfSelfSimFamily(UnderlyingSelfSimFamily(<G>))', which
##  means that the <G> is generated by the states of underlying automaton
##  and generators of <G> correspond to the states of this automaton.
DeclareProperty("IsSelfSimilarGroup", IsSelfSimGroup);
InstallTrueMethod(IsGroupOfSelfSimFamily, IsSelfSimilarGroup);


#############################################################################
##
#A  MihailovaSystem(<G>)
##
DeclareAttribute("MihailovaSystem", IsSelfSimGroup, "mutable");


#############################################################################
##
#A  IsomorphicAutomGroup(<G>)
##
##  In case <G> is finite-state returns a group generated by automata, isomorphic to <G>,
##  Which is a subgroup of `UnderlyingAutomatonGroup'(<G>) (see "UnderlyingAutomatonGroup").
##  The natural isomorphism between <G> and `IsomorphicAutomGroup'(<G>) is stored in the
##  attribute `MonomorphismToAutomatonGroup'(<G>) ("MonomorphismToAutomatonGroup").
##  \beginexample
##  gap> R := SelfSimilarGroup("a=(a^-1*b,b^-1*a)(1,2), b=(a^-1,b^-1)");
##  < a, b >
##  gap> UR := UnderlyingAutomatonGroup(R);
##  < a1, a2, a4, a5 >
##  gap> IR := IsomorphicAutomGroup(R);
##  < a1, a5 >
##  gap> hom := MonomorphismToAutomatonGroup(R);
##  MappingByFunction( < a, b >, < a1, a5 >, function( a ) ... end, function( b ) ... end )
##  gap> (a*b)^hom;
##  a1*a5
##  gap> PreImagesRepresentative(hom,last);
##  a*b
##  gap> List( GeneratorsOfGroup (UR),x -> PreImagesRepresentative( hom, x));
##  [ a, a^-1*b, b^-1*a, b ]
##  \endexample
##
##  All these operations work also for the subgroups of groups generated by `SelfSimilarGroup'.
##  ("SelfSimilarGroup").
##  \beginexample
##  gap> T:=Group([b*a,a*b]);
##  < b*a, a*b >
##  gap> IT := IsomorphicAutomGroup(T);
##  < a1, a4 >
##  \endexample
##  Note, that different groups have different `UnderlyingAutomGroup' attributes. For example,
##  the generator `a1' of group `IT' above is different from the generator `a1' of group `IR'.
##
DeclareAttribute("IsomorphicAutomGroup", IsSelfSimGroup, "mutable");


#############################################################################
##
#A  UnderlyingAutomatonGroup(<G>)
##
##  In case <G> is finite-state returns a self-similar closure of <G> as a group
##  generated by automaton.
##  The natural monomorphism from <G> and `UnderlyingAutomatonGroup'(<G>) is stored in the
##  attribute `MonomorphismToAutomatonGroup'(<G>) ("MonomorphismToAutomatonGroup"). If
##  <G> is created by `SelfSimilarGroup' (see "SelfSimilarGroup"), then the self-similar closure
##  of <G> coincides with <G>, so one can use `MonomorphismToAutomatonGroup'(<G>) to
##  get preimages of elements of `UnderlyingAutomatonGroup'(<G>) in <G>. See the example for
##  `IsomorphicAutomGroup' ("IsomorphicAutomGroup").
##
DeclareAttribute("UnderlyingAutomatonGroup", IsSelfSimGroup, "mutable");


#############################################################################
##
#A  MonomorphismToAutomatonGroup(<G>)
##
##  In case <G> is finite-state returns a monomorphism from <G> into `UnderlyingAutomatonGroup'(<G>)
##  (see "UnderlyingAutomatonGroup"). If <G> is created by `SelfSimilarGroup' (see "SelfSimilarGroup"),
##  then one can use `MonomorphismToAutomatonGroup'(<G>) to
##  get preimages of elements of `UnderlyingAutomatonGroup'(<G>) in <G>. See the example for
##  `IsomorphicAutomGroup' ("IsomorphicAutomGroup").
##
DeclareAttribute("MonomorphismToAutomatonGroup", IsSelfSimGroup, "mutable");


#E
