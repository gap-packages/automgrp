#############################################################################
##
#W  automsg.gd               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
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
#O  AutomSemigroup( <string> )
#O  AutomSemigroup( <list>[, <names>] )
#O  AutomSemigroup( <automaton> )
##
##  Creates the semigroup generated by finite automaton, described by <string>
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
##  Each entry is of the form $[a_1,...,a_d,p]$,
##  where $d >= 2$ is the size of the alphabet the group acts on, $a_i$ are `IsInt' in $[1..m]$ and
##  represent the sections of corresponding state at all vertices of the first level of the tree;
##  and all `p' is in `SymmetricalGroup(d)' describes the action of the corresponding state on the
##  alphabet.
##
##  Optional <names> must be a list of names of states in <automaton>.
##  These names are used to display elements of resulted smigroup, and for
##  convenience it also binds variables with those names (see also~"AutomSemigroupNoBindGlobal").
##
##  \beginexample
##  gap> AutomSemigroup("a = (a, b), b = (a, b)(1,2)");
##  < a, b >
##  gap> AutomSemigroup("a=(b, a, 1)(2,3), b=(1, a, b)(1,2,3)");
##  < a, b >
##  gap> A:=Automaton("a=(b,1)(1,2),b=(a,1)");
##  <automaton>
##  gap> G:=AutomSemigroup(A);
##  < a, b >
##  \endexample
##
DeclareOperation("AutomSemigroup", [IsList]);
DeclareOperation("AutomSemigroup", [IsAutomaton]);
DeclareOperation("AutomSemigroup", [IsList, IsList]);


#############################################################################
##
#O  AutomSemigroupNoBindGlobal( <list>[, <names>] )
#O  AutomSemigroupNoBindGlobal( <string> )
#O  AutomSemigroupNoBindGlobal( <automaton> )
##
##  These three do the same thing as AutomSemigroup, except they do not assign
##  generators of the group to variables.
##  \beginexample
##  gap> AutomSemigroupNoBindGlobal("t = (1, t)(1,2)");;
##  gap> t;
##  Variable: 't' must have a value
##
##  gap> AutomSemigroup("t = (1, t)(1,2)");;
##  gap> t;
##  t
##  \endexample
##
DeclareOperation("AutomSemigroupNoBindGlobal", [IsList]);
DeclareOperation("AutomSemigroupNoBindGlobal", [IsList, IsList]);
DeclareOperation("AutomSemigroupNoBindGlobal", [IsAutomaton]);


#############################################################################
##
#A  UnderlyingAutomFamily( <G> )
##
##  Returns the family to which elements of <G> belong.
##
DeclareAttribute("UnderlyingAutomFamily", IsAutomCollection);
InstallSubsetMaintenance(UnderlyingAutomFamily, IsCollection, IsCollection);


#############################################################################
##
#A  UnderlyingFreeSubgroup(<G>)
#A  UnderlyingFreeGenerators(<G>)
#A  UnderlyingFreeGroup(<G>)
##
DeclareAttribute("UnderlyingFreeSubsemigroup", IsAutomSemigroup, "mutable");
DeclareAttribute("UnderlyingFreeGenerators", IsAutomSemigroup, "mutable");
DeclareAttribute("UnderlyingFreeSemigroup", IsAutomSemigroup);


#E