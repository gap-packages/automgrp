#############################################################################
##
#W  listops.gd              automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.listops_gd :=
  "@(#)$Id$";


###############################################################################
##
#F  IsCorrectAutomatonList( <list> )
##
##  Checks whether the list is correct list to define automaton, i.e.:
##  [[a_11,...,a_1n,p_1],[a_21,...,a_2n,p_2],...,[a_m1...a_mn,p_m]],
##  where n >= 2, m >= 1, a_ij are IsInt in [1..m], and all p_i are
##  in SymmetricalGroup(n).
##
DeclareGlobalFunction("IsCorrectAutomatonList");


###############################################################################
##
#F  ConnectedStatesInList( <state>, <list>)
##
##  Returns list of states which can be reached from given state.
##  It does not check correctness of arguments.
##
DeclareGlobalFunction("ConnectedStatesInList");


###############################################################################
##
#F  IsTrivialStateInList( <state>, <list>)
##
##  Checks whether given state is trivial.
##  Does not check correctness of arguments.
##
DeclareGlobalFunction("IsTrivialStateInList");


###############################################################################
##
#F  AreEquivalentStatesInList( <state1>, <state2>, <list> )
##
##  Checks whether two given states are equivalent.
##  Does not check correctness of arguments.
##
DeclareGlobalFunction("AreEquivalentStatesInList");


###############################################################################
##
#F  AreEquivalentStatesInLists( <state1>, <state2>, <list1>, <list2>)
##
##  Checks whether two given states in different lists are equivalent.
##  Does not check correctness of arguments.
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
##  It does not remove trivial state, so it's not really "reduced automaton",
##  it just removes equivalent states.
##  TODO: write such function which removes trivial state
##
##  Does not check correctness of list.
##
DeclareGlobalFunction("ReducedAutomatonInList");


###############################################################################
##
#F  MinimalSubAutomatonInlist(<states>, <list>)
##
##  Returns list representation of automaton given by <list> which is minimal
##  subatomaton of automaton containing states <states>.
##
##  Does not check correctness of list.
##
DeclareGlobalFunction("MinimalSubAutomatonInlist");


###############################################################################
##
#F  PermuteStatesInList(<list>, <perm>)
##
##  Try to see what it does. I can never memorize what does "permute" mean.
##  I guess it means that i-th state goes to (i^perm)-th place.
##  Does not check correctness of arguments.
##
DeclareGlobalFunction("PermuteStatesInList");


DeclareGlobalFunction("StateOfWordInAutomatonList");


#E