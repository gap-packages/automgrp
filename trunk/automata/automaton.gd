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
#P  IsActingOnBinaryTree
#A  AlphabetOrder - better name?
##
DeclareProperty("IsActingOnBinaryTree", IsAutomaton);
DeclareAttribute("AlphabetOrder", IsAutomaton);


###############################################################################
##
#P  IsFiniteAutomaton
#P  CanEasilyCheckFinitnessAutomaton
##
DeclareProperty("IsFiniteAutomaton", IsAutomaton);
DeclareFilter("CanEasilyCheckFinitnessAutomaton");

#E
