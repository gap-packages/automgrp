#############################################################################
##
#W  selfsimsg.gd             automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
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
##  Creates the semigroup generated by finite automaton, described by <string>
##  or <list>, or given as an argument <automaton>.
##
##  The <string> is a conventional notation of the form
##  `name1 = (name11, name12, ..., name1d)trans1, name2 = ...'
##  where each `name\*' is a name of state or `1', and each `trans\*' is either a
##  permutation written in {\GAP} notation, or the list defining a transformation
##  of the alphabet via `Transformation(trans\*)'. Trivial permutations may be
##  omitted. This function ignores whitespace, and states may be separated
##  by commas or semicolons.
##
##  The <list> is a list consisting of $n$ entries corresponding to $n$ states of automaton.
##  Each entry is of the form $[a_1,...,a_d,p]$,
##  where $d \geq 2$ is the size of the alphabet the group acts on, $a_i$ are `IsInt' in 
##  $\{1,\ldots,n\}$ and
##  represent the sections of corresponding state at all vertices of the first level of the tree;
##  and each $p$ is a transformation of the alphabet describing the action of the corresponding 
##  state on the alphabet.
##
##  Optional <names> and <bind_vars> have the same meaning as in `SelfSimilarGroup' (see "SelfSimilarGroup").
##
##  \beginexample
##  gap> SelfSimilarSemigroup("a = (a, b), b = (a, b)(1,2)");
##  < a, b >
##  gap> SelfSimilarSemigroup("a=(b, a, 1)[1,1,3], b=(1, a, b)(1,2,3)");
##  < a, b >
##  gap> A:=MealySelfSimilar("f0=(f0,f0)(1,2),f1=(f1,f0)[2,2]");
##  <automaton>
##  gap> G:=SelfSimilarSemigroup(A);
##  < f0, f1 >
##  \endexample
##
DeclareOperation("SelfSimilarSemigroup", [IsList]);
DeclareOperation("SelfSimilarSemigroup", [IsList, IsList]);


# #############################################################################
# ##
# #O  AutomSemigroupNoBindGlobal( <list>[, <names>] )
# #O  AutomSemigroupNoBindGlobal( <string> )
# #O  AutomSemigroupNoBindGlobal( <automaton> )
# ##
# ##  These three do the same thing as AutomatonSemigroup, except they do not assign
# ##  generators of the group to variables.
# ##  \beginexample
# ##  gap> AutomSemigroupNoBindGlobal("t = (1, t)(1,2)");;
# ##  gap> t;
# ##  Variable: 't' must have a value
# ##
# ##  gap> AutomatonSemigroup("t = (1, t)(1,2)");;
# ##  gap> t;
# ##  t
# ##  \endexample
# ##
DeclareOperation("SelfSimilarSemigroup", [IsList, IsBool]);
DeclareOperation("SelfSimilarSemigroup", [IsList, IsList, IsBool]);


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
##  Returns an `AutomatonList' of `UnderlyingAutomaton'(<G>) (see "UnderlyingAutomaton").
##  \beginexample
##  gap> AutomatonList(Basilica);
##  [ [ 2, 5, (1,2) ], [ 1, 5, () ], [ 5, 4, (1,2) ], [ 3, 5, () ], [ 5, 5, () ] ]
##  \endexample
##
DeclareAttribute("RecurList", IsSelfSimSemigroup, "mutable");

DeclareAttribute("GeneratingRecurList", IsSelfSimSemigroup, "mutable");

#E
