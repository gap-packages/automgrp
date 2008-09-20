#############################################################################
##
#W  automgroup.gd             automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsAutomGroup( <G> )
##
##  The category of groups generated by finite invertible initial automata
##  (elements from category `IsAutom').
##
DeclareSynonym("IsAutomGroup", IsAutomCollection and IsGroup);
InstallTrueMethod(IsTreeAutomorphismCollection, IsAutomGroup);
InstallTrueMethod(IsInvertibleAutomCollection, IsAutomGroup);


#############################################################################
##
#O  AutomatonGroup( <string>[, <bind_vars>] )
#O  AutomatonGroup( <list>[, <names>, <bind_vars>] )
#O  AutomatonGroup( <automaton>[, <bind_vars>] )
##
##  Creates the self-similar group generated by the finite automaton, described by <string>
##  or <list>, or by the argument <automaton>.
##
##  The argument <string> is a conventional notation of the form
##  `name1=(name11,name12,...,name1d)perm1, name2=...'
##  where each `name\*' is a name of a state or `1', and each `perm\*' is a
##  permutation written in {\GAP} notation. Trivial permutations may be
##  omitted. This function ignores whitespace, and states may be separated
##  by commas or semicolons.
##
##  The argument <list> is a list consisting of $n$ entries corresponding to $n$ states of an automaton.
##  Each entry is of the form $[a_1,\.\.\.,a_d,p]$,
##  where $d \geq 2$ is the size of the alphabet the group acts on, $a_i$ are `IsInt' in
##  $\{1,\ldots,n\}$ and
##  represent the sections of the corresponding state at all vertices of the first level of the tree;
##  and $p$ from `SymmetricGroup(<d>)' describes the action of the corresponding state on the
##  alphabet.
##
##  The optional argument <names> must be a list of names of generators of the group, corresponding to the
##  states of the automaton.
##  These names are used to display elements of the resulting group.
##
##  If the optional argument <bind_vars> is `false' the names of generators of the group are not assigned
##  to the global variables. The default value is `true'. One can use
##  `AssignGeneratorVariables' function to assign these names later, if they were not assigned
##  when the group was created.
##
##  \beginexample
##  gap> AutomatonGroup("a=(a,b), b=(a, b)(1,2)");
##  < a, b >
##  gap> AutomatonGroup("a=(b,a,1)(2,3), b=(1,a,b)(1,2,3)");
##  < a, b >
##  gap> A := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
##  <automaton>
##  gap> G := AutomatonGroup(A);
##  < a, b >
##  \endexample
##
##  In the second form of this operation the definition of the first group
##  looks like
##  \beginexample
##  gap> AutomatonGroup([ [ 1, 2, ()], [ 1, 2, (1,2) ] ], [ "a", "b" ]);
##  < a, b >
##  \endexample
##  The <bind_vars> argument works as follows
##  \beginexample
##  gap> AutomatonGroup("t = (1, t)(1,2)", false);;
##  gap> t;
##  Variable: 't' must have a value
##
##  gap> AutomatonGroup("t = (1, t)(1,2)", true);;
##  gap> t;
##  t
##  \endexample
##
DeclareOperation("AutomatonGroup", [IsList]);
DeclareOperation("AutomatonGroup", [IsMealyAutomaton]);
DeclareOperation("AutomatonGroup", [IsList, IsList]);
DeclareOperation("AutomatonGroup", [IsList, IsBool]);
DeclareOperation("AutomatonGroup", [IsMealyAutomaton, IsBool]);
DeclareOperation("AutomatonGroup", [IsList, IsList, IsBool]);


#############################################################################
##
#P  IsGroupOfAutomFamily( <G> )
##
##  Whether group <G> is the whole group generated by the automaton used to
##  construct elements of <G>.
##
DeclareProperty("IsGroupOfAutomFamily", IsAutomGroup);
InstallTrueMethod(IsSelfSimilar, IsGroupOfAutomFamily);



#############################################################################
##
#A  UnderlyingFreeSubgroup( <G> )
##
DeclareAttribute("UnderlyingFreeSubgroup", IsAutomGroup, "mutable");


#############################################################################
##
#A  IndexInFreeGroup( <G> )
##
DeclareAttribute("IndexInFreeGroup", IsAutomGroup, "mutable");


#############################################################################
##
#P  IsAutomatonGroup( <G> )
##
##  is `true' if <G> is created using the command `AutomatonGroup' ("AutomatonGroup")
##  or if the generators of <G> coincide with the generators of the corresponding family, and `false' otherwise.
##  To test whether <G> is self-similar use `IsSelfSimilar' ("IsSelfSimilar") command.
DeclareProperty("IsAutomatonGroup", IsAutomGroup);
InstallTrueMethod(IsGroupOfAutomFamily, IsAutomatonGroup);


#############################################################################
##
#A  MihailovaSystem( <G> )
##
DeclareAttribute("MihailovaSystem", IsAutomGroup, "mutable");


#E
