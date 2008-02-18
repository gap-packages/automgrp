#############################################################################
##
#W  automsg.gd               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsAutomSemigroup( <G> )
##
##  Whether semigroup <G> is generated by elements from category IsAutom.
##
DeclareSynonym("IsAutomSemigroup", IsSemigroup and IsAutomCollection);


#############################################################################
##
#O  AutomatonSemigroup( <string>[, <bind_vars>] )
#O  AutomatonSemigroup( <list>[, <names>, <bind_vars>] )
#O  AutomatonSemigroup( <automaton>[, <bind_vars>] )
##
##  Creates the semigroup generated by the finite automaton, described by <string>
##  or <list>, or by the argument <automaton>.
##
##  The argument <string> is a conventional notation of the form
##  `name1=(name11,name12,...,name1d)trans1, name2=...'
##  where each `name\*' is a name of a state or `1', and each `trans\*' is either a
##  permutation written in {\GAP} notation, or a list defining a transformation
##  of the alphabet via `Transformation(trans\*)'. Trivial permutations may be
##  omitted. This function ignores whitespace, and states may be separated
##  by commas or semicolons.
##
##  The argument <list> is a list consisting of $n$ entries corresponding to $n$ states of the automaton.
##  Each entry is of the form $[a_1,...,a_d,p]$,
##  where $d \geq 2$ is the size of the alphabet the group acts on, $a_i$ are `IsInt' in
##  $\{1,\ldots,n\}$ and
##  represent the sections of the corresponding state at all vertices of the first level of the tree;
##  and $p$ is a transformation of the alphabet describing the action of the corresponding
##  state on the alphabet.
##
##  The optional arguments <names> and <bind_vars> have the same meaning as in `AutomatonGroup' (see "AutomatonGroup").
##
##  \beginexample
##  gap> AutomatonSemigroup("a=(a, b)[2,2], b=(a,b)(1,2)");
##  < a, b >
##  gap> AutomatonSemigroup("a=(b,a,1)[1,1,3], b=(1,a,b)(1,2,3)");
##  < 1, a, b >
##  gap> A := MealyAutomaton("f0=(f0,f0)(1,2), f1=(f1,f0)[2,2]");
##  <automaton>
##  gap> G := AutomatonSemigroup(A);
##  < f0, f1 >
##  \endexample
##  In the second form of this operation the definition of the second semigroup
##  looks like
##  \beginexample
##  gap> AutomatonSemigroup([ [1,2,Transformation([2,2])], [ 1,2,(1,2)] ], ["a","b"]);
##  < a, b >
##  \endexample
##
DeclareOperation("AutomatonSemigroup", [IsList]);
DeclareOperation("AutomatonSemigroup", [IsMealyAutomaton]);
DeclareOperation("AutomatonSemigroup", [IsList, IsList]);


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
DeclareOperation("AutomatonSemigroup", [IsList, IsBool]);
DeclareOperation("AutomatonSemigroup", [IsMealyAutomaton, IsBool]);
DeclareOperation("AutomatonSemigroup", [IsList, IsList, IsBool]);


#############################################################################
##
#A  UnderlyingAutomFamily( <G> )
##
##  Returns the family to which the elements of <G> belong.
##
DeclareAttribute("UnderlyingAutomFamily", IsAutomCollection);
InstallSubsetMaintenance(UnderlyingAutomFamily, IsCollection, IsCollection);


#############################################################################
##
#A  UnderlyingFreeGenerators(<G>)
#A  UnderlyingFreeMonoid(<G>)
#A  UnderlyingFreeGroup(<G>)
##
DeclareAttribute("UnderlyingFreeGenerators", IsAutomSemigroup, "mutable");
DeclareAttribute("UnderlyingFreeMonoid", IsAutomSemigroup);
DeclareAttribute("UnderlyingFreeGroup", IsAutomSemigroup);


#############################################################################
##
#A  UnderlyingAutomaton(<G>)
##
##  For a group (or semigroup) <G> returns an automaton generating a
##  self-similar group (or semigroup) containing <G>.
##  \beginexample
##  gap> GS := AutomatonSemigroup("x=(x,y)[1,1], y=(y,y)(1,2)");
##  < x, y >
##  gap> A := UnderlyingAutomaton(GS);
##  <automaton>
##  gap> Print(A);
##  a1 = (a1, a2)[ 1, 1 ], a2 = (a2, a2)[ 2, 1 ]
##  \endexample
##  For a subgroup of Basilica group we get the automaton generating Basilica group.
##  \beginexample
##  gap> H := Group([u*v^-1,v^2]);
##  < u*v^-1, v^2 >
##  gap> Print(UnderlyingAutomaton(H));
##  a1 = (a1, a1), a2 = (a3, a1)(1,2), a3 = (a2, a1)
##  \endexample
##
DeclareAttribute("UnderlyingAutomaton", IsAutomSemigroup);


# XXX

###############################################################################
##
#A  AutomatonList(<G>)
##
##  Returns an `AutomatonList' of `UnderlyingAutomaton'(<G>) (see "UnderlyingAutomaton").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> AutomatonList(Basilica);
##  [ [ 2, 5, (1,2) ], [ 1, 5, () ], [ 5, 4, (1,2) ], [ 3, 5, () ], [ 5, 5, () ] ]
##  \endexample
##
DeclareAttribute("AutomatonList", IsAutomSemigroup, "mutable");
DeclareAttribute("GeneratingAutomatonList", IsAutomSemigroup, "mutable");


#############################################################################
##
#P  IsAutomatonSemigroup (<G>)
##
##  is `true' if <G> is created using the command `AutomatonSemigroup' ("AutomatonSemigroup")
##  and `false' otherwise.
##  To test whether <G> is self-similar use `IsSelfSimilar' ("IsSelfSimilar") command.
DeclareProperty("IsAutomatonSemigroup", IsAutomSemigroup);


#E
