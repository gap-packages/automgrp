#############################################################################
##
#W  listops.gd              automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


##  No function here checks correctness of arguments


###############################################################################
##
##  AG_IsCorrectAutomatonList( <list>, <invertible> )
##
##  Checks whether the list is correct list to define automaton, i.e.:
##  $[[a_11,...,a_1n,p_1],[a_21,...,a_2n,p_2],...,[a_m1...a_mn,p_m]]$,
##  where $n >= 2$, $m >= 1$, $a_ij$ are IsInt in $[1..m]$; and all $p_i$ are
##  in `SymmetricGroup'($n$) (semigroup of transformations of the set $\{1..n\}$)
##  if <invertible>=`true' (`false').
##
DeclareGlobalFunction("AG_IsCorrectAutomatonList");


###############################################################################
##
##  AG_IsCorrectRecurList( <list>, <invertible> )
##
##  Checks whether the list is correct list to define a self-similar group, i.e.:
##  $[[a_11,...,a_1n,p_1],[a_21,...,a_2n,p_2],...,[a_m1...a_mn,p_m]]$,
##  where $n >= 2$, $m >= 1$, $a_ij$ are `IsInt' in $[1..m]\cup [-m..-1]$ or `IsList' with
##  entries from $[1..m]\cup [-m..-1]$; and all $p_i$ are
##  in `SymmetricGroup'($n$) (semigroup of transformations of the set $\{1..n\}$)
##  if <invertible>=`true' (`false').
##
DeclareGlobalFunction("AG_IsCorrectRecurList");


###############################################################################
##
##  AG_InverseAutomatonList(<list>)
##
DeclareGlobalFunction("AG_InverseAutomatonList");


###############################################################################
##
##  AG_ConnectedStatesInList( <state>, <list>)
##
##  Returns list of states which can be reached from given state.
##
DeclareGlobalFunction("AG_ConnectedStatesInList");


###############################################################################
##
##  AG_IsTrivialStateInList( <state>, <list>)
##
##  Checks whether given state is trivial.
##
DeclareGlobalFunction("AG_IsTrivialStateInList");


###############################################################################
##
##  AG_IsObviouslyTrivialStateInList( <state>, <list>)
##
##  Checks whether given state is obviously trivial.
##  Works for lists generating self-similar groups.
##  Returns `true' if <state>=(*,...,*)(), where
##  * could be either +-<state> or [+-<state>].
##
DeclareGlobalFunction("AG_IsObviouslyTrivialStateInList");


###############################################################################
##
##  AG_IsInvertibleStateInList( <state>, <list>)
##
##  Checks whether given state is invertible.
##
DeclareGlobalFunction("AG_IsInvertibleStateInList");


###############################################################################
##
##  AG_AreEquivalentStatesInList( <state1>, <state2>, <list> )
##
##  Checks whether two given states are equivalent.
##
DeclareGlobalFunction("AG_AreEquivalentStatesInList");


###############################################################################
##
##  AG_AreEquivalentStatesInLists( <state1>, <state2>, <list1>, <list2>)
##
##  Checks whether two given states in different lists are equivalent.
##
DeclareGlobalFunction("AG_AreEquivalentStatesInLists");


###############################################################################
##
##  AG_ReducedAutomatonInList( <list> )
##
##  Returns [new_list, list_of_states] where new_list is a new list which
##  represents reduced form of given automaton, i-th elmt of list_of_states
##  is the number of i-th state of new automaton in the old one.
##
##  First state of returned list is always first state of given one.
##  It does not remove trivial state, so it's not really ``reduced automaton'',
##  it just removes equivalent states.
##  TODO: write such function which removes trivial state
##
DeclareGlobalFunction("AG_ReducedAutomatonInList");


###############################################################################
##
##  AG_MinimalSubAutomatonInlist(<states>, <list>)
##
##  Returns list representation of automaton given by <list> which is minimal
##  subatomaton of automaton containing states <states>.
##
DeclareGlobalFunction("AG_MinimalSubAutomatonInlist");


###############################################################################
##
##  AG_PermuteStatesInList(<list>, <perm>)
##
##  I guess it means that i-th state goes to (i^perm)-th place.
##
DeclareGlobalFunction("AG_PermuteStatesInList");


###############################################################################
##
##  AG_ImageOfVertexInList(<list>, <init>, <vertex>)
##
DeclareGlobalFunction("AG_ImageOfVertexInList");


###############################################################################
##
##  AG_WordStateInList(<word>, <s>, <list>, <reduce>, <trivstate>)
##  AG_WordStateAndPermInList(<word>, <s>, <list>)
##
##  It's ProjectWord from selfs.g
##
DeclareGlobalFunction("AG_WordStateInList");
DeclareGlobalFunction("AG_WordStateAndPermInList");


###############################################################################
##
##  AG_DiagonalPowerInList(<list>, <n>)
##
DeclareGlobalFunction("AG_DiagonalPowerInList");


###############################################################################
##
##  AG_MultAlphabetInList(<list>, <n>)
##
DeclareGlobalFunction("AG_MultAlphabetInList");


###############################################################################
##
##  AG_HasDualInList(<list>)
##  AG_HasDualOfInverseInList(<list>)
##  AG_DualAutomatonList(<list>)
##
DeclareGlobalFunction("AG_HasDualInList");
DeclareGlobalFunction("AG_HasDualOfInverseInList");
DeclareGlobalFunction("AG_DualAutomatonList");


#E
