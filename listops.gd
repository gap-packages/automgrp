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


# ###############################################################################
# ##
# #F  IsTrivialStateInList(state, list)
# ##
# ##  it does not check correctness of arguments
# ##
# DeclareGlobalFunction("IsTrivialStateInList");
# 
# 
# ###############################################################################
# ##
# #F  AreEquivalentStatesInList(state1, state2, list)
# ##
# ##  it does not check correctness of arguments
# ##
# DeclareGlobalFunction("AreEquivalentStatesInList");
# 
# 
# ###############################################################################
# ##
# #F  AreEquivalentStatesInLists(state1, state2, list1, list2)
# ##
# ##  it does not check correctness of arguments
# ##
# DeclareGlobalFunction("AreEquivalentStatesInLists");
# 
# 
# ###############################################################################
# ##
# #F  ReducedAutomatonInList(list)
# ##
# ##  returns new list which is list representation of reduced form of automaton
# ##  given by list
# ##  first state of returned list is always first state if given one
# ##  this function does not remove trivial state - it's for initial automata
# ##
# ##  It does not check correctness of list
# ##
# DeclareGlobalFunction("ReducedAutomatonInList");
# 
# 
# ###############################################################################
# ##
# #F  MinimalSubAutomatonInlist(<states>, <list>)
# ##
# ##  Returns list rep of automaton which is minimal subatomaton of automaton
# ##  with list rep <list> containing states <states>.
# ##
# ##  It does not check correctness of list
# ##
# DeclareGlobalFunction("MinimalSubAutomatonInlist");
# 
# 
# ###############################################################################
# ##
# #F  PermuteStatesInList(<list>, <perm>)
# ##
# ##  It does not check correctness of arguments
# ##
# DeclareGlobalFunction("PermuteStatesInList");
























