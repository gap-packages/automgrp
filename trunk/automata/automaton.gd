#############################################################################
##
#W  automaton.gd               automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##

Revision.automaton_gd := 
  "@(#)$Id$";


###############################################################################
##
#C  IsAutomaton
##
##  This is a category parent for all automata categories.
##
DeclareCategory("IsAutomaton",  IsMultiplicativeElement and 
                                IsAssociativeElement);


###############################################################################
##
#O  GetList (<automaton>)
#O  GetListWithNames (<automaton>)
##
##  It has different meaning for initial and noninitial automata.
##  Maybe it's worth to make this function always return a list of length
##  1 or 2 where the first elmt is the 'list' and optional second elmt is 
##  number of initial state?
##
DeclareOperation("GetList", [IsAutomaton]);
DeclareOperation("GetListWithNames", [IsAutomaton]);


###############################################################################
##
#P  IsFiniteAutomaton
#P  CanEasilyCheckFinitnessAutomaton
##
##  This is defined for IsAutomaton, not for IsInitialAutomaton, because we 
##  can consider things like
##  a = (b^2, a)(1,2)
##  b = (a, a^2),
##  can't we? Hope we will be able to deal with such things.
##
DeclareProperty("IsFiniteAutomaton", IsAutomaton);
DeclareFilter("CanEasilyCheckFinitnessAutomaton");








#E
