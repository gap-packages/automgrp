#############################################################################
##
#W  automaton.gd               automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##

Revision.automaton_gd :=
  "@(#)$Id$";


###############################################################################
##
#C  IsAutomaton
#C  IsAutomatonFamily
#C  IsAutomatonCollection
##
##  This is a category parent for all initial automata categories.
##
DeclareCategory("IsAutomaton",  IsAutomatonObject and IsTreeAutomorphism);
DeclareCategoryFamily("IsAutomaton");
DeclareCategoryCollections("IsAutomaton");
InstallTrueMethod(IsAutomatonObject, IsAutomatonCollection);
InstallTrueMethod(IsAutomatonObject, IsAutomatonFamily);


###############################################################################
##
#A  AutomatonListInitialState (<a>)
##
DeclareAttribute( "AutomatonListInitialState", IsAutomaton, "mutable" );


#E
