#############################################################################
##
#W  listops.gd              automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


##  No function here checks correctness of arguments


###############################################################################
##
#F  IsCorrectAutomatonList( <list>, <invertible> )
##
##  Checks whether the list is correct list to define automaton, i.e.:
##  $[[a_11,...,a_1n,p_1],[a_21,...,a_2n,p_2],...,[a_m1...a_mn,p_m]]$,
##  where $n >= 2$, $m >= 1$, $a_ij$ are IsInt in $[1..m]$; and all p_i are
##  in SymmetricalGroup(n) (semigroup of transformations of the set $\{1..n\}$)
##  if invertible=true (false).
##
DeclareGlobalFunction("IsCorrectAutomatonList");


###############################################################################
##
#F  InverseAutomatonList(<list>)
##
DeclareGlobalFunction("InverseAutomatonList");


###############################################################################
##
#F  ConnectedStatesInList( <state>, <list>)
##
##  Returns list of states which can be reached from given state.
##
DeclareGlobalFunction("ConnectedStatesInList");


###############################################################################
##
#F  IsTrivialStateInList( <state>, <list>)
##
##  Checks whether given state is trivial.
##
DeclareGlobalFunction("IsTrivialStateInList");

###############################################################################
##
#F  IsInvertibleStateInList( <state>, <list>)
##
##  Checks whether given state is invertible.
##
DeclareGlobalFunction("IsInvertibleStateInList");


###############################################################################
##
#F  AreEquivalentStatesInList( <state1>, <state2>, <list> )
##
##  Checks whether two given states are equivalent.
##
DeclareGlobalFunction("AreEquivalentStatesInList");


###############################################################################
##
#F  AreEquivalentStatesInLists( <state1>, <state2>, <list1>, <list2>)
##
##  Checks whether two given states in different lists are equivalent.
##
DeclareGlobalFunction("AreEquivalentStatesInLists");


###############################################################################
##
#F  ReducedAutomatonInList( <list> )
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
DeclareGlobalFunction("ReducedAutomatonInList");


###############################################################################
##
#F  MinimalSubAutomatonInlist(<states>, <list>)
##
##  Returns list representation of automaton given by <list> which is minimal
##  subatomaton of automaton containing states <states>.
##
DeclareGlobalFunction("MinimalSubAutomatonInlist");


###############################################################################
##
#F  PermuteStatesInList(<list>, <perm>)
##
##  I guess it means that i-th state goes to (i^perm)-th place.
##
DeclareGlobalFunction("PermuteStatesInList");


###############################################################################
##
#F  ImageOfVertexInList(<list>, <init>, <vertex>)
##
DeclareGlobalFunction("ImageOfVertexInList");


###############################################################################
##
#F  WordStateInList(<word>, <s>, <list>, <reduce>, <trivstate>)
#F  WordStateAndPermInList(<word>, <s>, <list>)
##
##  It's ProjectWord from selfs.g
##
DeclareGlobalFunction("WordStateInList");
DeclareGlobalFunction("WordStateAndPermInList");


###############################################################################
##
#F  DiagonalActionInList(<list>, <n>)
##
DeclareGlobalFunction("DiagonalActionInList");


###############################################################################
##
#F  MultAlphabetInList(<list>, <n>)
##
DeclareGlobalFunction("MultAlphabetInList");


###############################################################################
##
#F  HasDualInList(<list>)
#F  HasDualOfInverseInList(<list>)
#F  DualAutomatonList(<list>)
##
DeclareGlobalFunction("HasDualInList");
DeclareGlobalFunction("HasDualOfInverseInList");
DeclareGlobalFunction("DualAutomatonList");


#E
