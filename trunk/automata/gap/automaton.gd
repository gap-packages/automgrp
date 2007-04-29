#############################################################################
##
#W  automaton.gd              automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsAutomaton
##
##  A category of non-initial finite Mealy automata with the same input and
##  output alphabet.
##
DeclareCategory("IsAutomaton", IsObject);
DeclareCategoryFamily("IsAutomaton");

###############################################################################
##
#O  Automaton( <table>[, <names>[, <alphabet>]] )
##
##  Creates a Mealy automaton defined by the <table>. Format of the <table> is
##  the following: it is a list of states, where each state is a list of
##  positive integers which represent transition function at given state and a
##  permutation or transformation which represent output function at this
##  state.
##  \beginexample
##  XXX
##  \endexample
##
DeclareOperation("Automaton", [IsList]);
DeclareOperation("Automaton", [IsList, IsList]);
DeclareOperation("Automaton", [IsList, IsList, IsList]);

###############################################################################
##
#O  Automaton( <string> )
##
##  Creates a Mealy automaton defined by the conventional notation in <string>.
##  \beginexample
##  XXX
##  \endexample
##


# ###############################################################################
# ##
# #A  TransitionFunction( <automaton> )
# ##
# ##  Returns transition function of <automaton> as a {\GAP} function of two
# ##  variables.
# ##
# DeclareAttribute("TransitionFunction", IsAutomaton);
#
# ###############################################################################
# ##
# #A  OutputFunction( <automaton>[, <state>] )
# ##
# ##  Returns output function of <automaton> as a {\GAP} function of two
# ##  variables.
# ##
# DeclareAttribute("OutputFunction", IsAutomaton);


#E
