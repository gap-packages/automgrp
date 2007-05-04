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
#C  IsAutomGroup( <G> )
##
##  Whether group <G> is generated by elements from category IsAutom.
##
DeclareSynonym("IsAutomGroup", IsGroup and IsAutomCollection);


#############################################################################
##
#O  AutomGroup( <automaton>[, <names>] )
##
##  Creates the self-similar group generated by finite automaton <automaton>.
##  Optional <names> must be a list of names for each state in <automaton>.
##  These names are used to display elements of resulted group, and for
##  convenience it also binds variables with those names (see also~"AutomGroupNoBindGlobal").
##
DeclareOperation("AutomGroup", [IsList]);

#############################################################################
##
#O  AutomGroup( <string> )
##
##  Creates the self-similar group generated by finite automaton described
##  by <string>. The <string> is a conventional notation of the form
##  `name1 = (name11, name12, ..., name1d)perm1, name2 = ...'
##  where each `name\*' is a name of state or `1', and each perm1 is a
##  permutation written in {\GAP} notation. Trivial permutations may be
##  omitted. This function ignores whitespace, and states may be separated
##  by commas or semicolons.
##  \beginexample
##  gap> AutomGroup("a=(1,a)(1,2)");
##  < a >
##  gap> AutomGroup("a = (b, a), b = (a, b)(1,2)");
##  < a, b >
##  gap> AutomGroup("a=(b, a, 1)(2,3), b=(1, a, b)(1,2,3)");
##  < a, b >
##  \endexample
##
DeclareOperation("AutomGroup", [IsList, IsList]);

#############################################################################
##
#O  AutomGroupNoBindGlobal( <automaton_list>[, <names>] )
#O  AutomGroupNoBindGlobal( <string> )
##
##  These two do the same thing as AutomGroup, except they do not assign
##  generators of the group to variables.
##  \beginexample
##  gap> AutomGroupNoBindGlobal("t = (1, t)(1,2)");;
##  gap> t;
##  Variable: 't' must have a value
##
##  gap> AutomGroup("t = (1, t)(1,2)");;
##  gap> t;
##  t
##  \endexample
##
DeclareOperation("AutomGroupNoBindGlobal", [IsList]);
DeclareOperation("AutomGroupNoBindGlobal", [IsList, IsList]);


#############################################################################
##
#A  UnderlyingAutomFamily( <G> )
##
##  Returns the family to which elements of <G> belong.
##
DeclareAttribute("UnderlyingAutomFamily", IsAutomGroup);
InstallSubsetMaintenance(UnderlyingAutomFamily, IsCollection, IsCollection);


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
#A  UnderlyingFreeGenerators(<G>)
#A  UnderlyingFreeGroup(<G>)
##
DeclareAttribute("UnderlyingFreeSubgroup", IsAutomGroup, "mutable");
DeclareAttribute("UnderlyingFreeGenerators", IsAutomGroup, "mutable");
DeclareAttribute("UnderlyingFreeGroup", IsAutomGroup);


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


#E
