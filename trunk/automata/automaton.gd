#############################################################################
##
#W  automaton.gd               automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##

Revision.automaton_gd := 
  "@(#)$Id$";


###############################################################################
##
#C  IsAutomaton
##
##  This is a category parent for all automata categories.
##
DeclareCategory("IsAutomaton",  IsMultiplicativeElementWithInverse and 
                                IsAssociativeElement);


###############################################################################
##
#O  Perm(<autom>, <level>)
#A  TopPerm(<autom>)
##
DeclareOperation("Perm", [IsAutomObj, IsInt]);
DeclareAttribute("TopPerm", IsAutomObj);


###############################################################################
##
#O  Expand(<automobj>)
##
DeclareOperation("Expand", [IsAutomObj]);


###############################################################################
##
#O  ExpandRen(<automobj>)
##
DeclareOperation("ExpandRen", [IsAutomObj]);


###############################################################################
##
#O  StabilizesPath(<automobj>, <path>)
##
DeclareOperation("StabilizesPath", [IsAutomObj, IsObject]);


###############################################################################
##
#A  ListRep(<autom>)
##
DeclareAttribute("ListRep", IsAutomObj);


###############################################################################
##
#O  PermMatrices(<automobj>, <level>)
##
DeclareOperation("PermMatrices", [IsAutomObj, IsInt]);











#E
