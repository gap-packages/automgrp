#############################################################################
##
#W  autls.gd                automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


###############################################################################
##
#F  IsCorrectListCompOfAutomaton( list )
##
##  checks if given list can be list component of automaton structure
##  returns list with two components: first component is true/false,
##  second one is error message
##
DeclareGlobalFunction("IsCorrectListComponentOfAutomaton");


###############################################################################
##
#F  ConnectedStatesInList(state, list)
##
##  Returns list of states which are reachable from given state,
##  it does not check correctness of arguments
##
DeclareGlobalFunction("ConnectedStatesInList");


###############################################################################
##
#F  IsTrivialStateInList(state, list)
##
##  it does not check correctness of arguments
##
DeclareGlobalFunction("IsTrivialStateInList");


###############################################################################
##
#F  AreEquivalentStatesInList(state1, state2, list)
##
##  it does not check correctness of arguments
##
DeclareGlobalFunction("AreEquivalentStatesInList");


###############################################################################
##
#F  AreEquivalentStatesInLists(state1, state2, list1, list2)
##
##  it does not check correctness of arguments
##
DeclareGlobalFunction("AreEquivalentStatesInLists");


###############################################################################
##
#F  ReducedAutomatonInList(list)
##
##  returns new list which is list representation of reduced form of automaton
##  given by list
##  first state of returned list is always first state if given one
##  this function does not remove trivial state - it's for initial automata
##
##  It does not check correctness of list
##
DeclareGlobalFunction("ReducedAutomatonInList");


###############################################################################
##
#F  MinimalSubAutomatonInlist(<states>, <list>)
##
##  Returns list rep of automaton which is minimal subatomaton of automaton
##  with list rep <list> containing states <states>.
##
##  It does not check correctness of list
##
DeclareGlobalFunction("MinimalSubAutomatonInlist");


###############################################################################
##
#F  PermuteStatesInList(<list>, <perm>)
##
##  It does not check correctness of arguments
##
DeclareGlobalFunction("PermuteStatesInList");
























