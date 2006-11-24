#############################################################################
##
#W  automatonobj.gd            automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsAutomatonObject
##
##  IsAutomatonObject is a category parent for all automata-like categories,
##    i.e. for automata, automata groups, automata families, etc.
##
DeclareCategory("IsAutomatonObject", IsTreeAutObject);
InstallTrueMethod(IsActingOnHomogeneousTree, IsAutomatonObject);


###############################################################################
##
#A  AutomatonList (<obj>)
##
##  It's the list representing automaton in case of initial or noninitial
##  automata, or it's the list representing genrators of automata group.
##  In case of initial automata and automata groups extra information is
##  needed to identify the object - initial state in case of automaton and
##  initial states of generators - they are declared for coresponding
##  categories.
##
DeclareAttribute("AutomatonList", IsAutomatonObject, "mutable");


#E
