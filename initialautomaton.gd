#############################################################################
##
#W  initialautomaton.gd        automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.initialautomaton_gd := 
  "@(#)$Id$";


###############################################################################
##
#C  IsInitialAutomaton
##
##  This is a category parent for all initial automata categories.
##
DeclareCategory("IsInitialAutomaton", IsAutomaton and
                                      IsMultiplicativeElementWithInverse);












#E
