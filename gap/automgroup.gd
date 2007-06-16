#############################################################################
##
#W  automgroup.gd             automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsAutomGroup
##
##  The category of groups generated by finite invertible initial automata
##  (elements from category `IsAutom').
##
DeclareSynonym("IsAutomGroup", IsAutomCollection and IsGroup);
InstallTrueMethod(IsTreeAutomorphismCollection, IsAutomGroup);
InstallTrueMethod(IsInvertibleAutomCollection, IsAutomGroup);


#############################################################################
##
#O  AutomGroup( <string>[, <bind_vars>] )
#O  AutomGroup( <list>[, <names>][, <bind_vars>] )
#O  AutomGroup( <automaton>[, <bind_vars>] )
##
##  Creates the self-similar group generated by finite automaton, described by <string>
##  or <list>, or given as an argument <automaton>.
##
##  The <string> is a conventional notation of the form
##  `name1 = (name11, name12, ..., name1d)perm1, name2 = ...'
##  where each `name\*' is a name of state or `1', and each `perm\*' is a
##  permutation written in {\GAP} notation. Trivial permutations may be
##  omitted. This function ignores whitespace, and states may be separated
##  by commas or semicolons.
##
##  The <list> is a list consisting of `n' entries corresponding to `n' states of automaton.
##  Each entry is of the form $[a_1,\.\.\.,a_d,p]$,
##  where $d >= 2$ is the size of the alphabet the group acts on, $a_i$ are `IsInt' in `[1..m]' and
##  represent the sections of corresponding state at all vertices of the first level of the tree;
##  and all `p' is in `SymmetricalGroup(d)' describes the action of the corresponding state on the
##  alphabet.
##
##  Optional <names> must be a list of names of states in <automaton>.
##  These names are used to display elements of resulted group.
##
##  \beginexample
##  gap> AutomGroup("a = (a, b), b = (a, b)(1,2)");
##  < a, b >
##  gap> AutomGroup("a=(b, a, 1)(2,3), b=(1, a, b)(1,2,3)");
##  < a, b >
##  gap> A:=Automaton("a=(b,1)(1,2),b=(a,1)");
##  <automaton>
##  gap> G:=AutomGroup(A);
##  < a, b >
##  \endexample
##
##  These operations accept also optional boolean argument <bind_vars>, which tells
##  whether to asign generators of the group to \GAP variables.
##  \beginexample
##  gap> AutomGroup("t = (1, t)(1,2)", false);;
##  gap> t;
##  Variable: 't' must have a value
##
##  gap> AutomGroup("t = (1, t)(1,2)", true);;
##  gap> t;
##  t
##  \endexample
##
DeclareOperation("AutomGroup", [IsList]);
DeclareOperation("AutomGroup", [IsAutomaton]);
DeclareOperation("AutomGroup", [IsList, IsList]);
DeclareOperation("AutomGroup", [IsList, IsBool]);
DeclareOperation("AutomGroup", [IsAutomaton, IsBool]);
DeclareOperation("AutomGroup", [IsList, IsList, IsBool]);


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
#P  IsFractalByWords(<G>)
##
DeclareProperty("IsFractalByWords", IsAutomGroup);
InstallTrueMethod(IsFractal, IsFractalByWords);


#############################################################################
##
#A  UnderlyingFreeSubgroup(<G>)
##
DeclareAttribute("UnderlyingFreeSubgroup", IsAutomGroup, "mutable");


#############################################################################
##
#A  IndexInFreeGroup(<G>)
##
DeclareAttribute("IndexInFreeGroup", IsAutomGroup, "mutable");


#############################################################################
##
#A  LevelOfFaithfulAction (<G>)
##
DeclareAttribute("LevelOfFaithfulAction", IsAutomGroup and IsSelfSimilar);


#############################################################################
##
#P  IsAutomatonGroup (<G>)  `true' if generators of <G> coincide with generators
##                             of GroupOfAutomFamily(UnderlyingAutomFamily(<G>))
##                            means that the group is generated by its automaton
DeclareProperty("IsAutomatonGroup", IsAutomGroup);
InstallTrueMethod(IsGroupOfAutomFamily, IsAutomatonGroup);


#############################################################################
##
#A  MihailovaSystem(<G>)
##
DeclareAttribute("MihailovaSystem", IsAutomGroup, "mutable");




#E
