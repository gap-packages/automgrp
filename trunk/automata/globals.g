#############################################################################
##
#W  globals.g               automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.globals_g := 
  "@(#)$Id$";


###############################################################################
##
#V  AutomataParameters
##
##  This record contains various global variables for automata package.
##  It's made as one record with million entries in order to not pollute
##  global namespace (and we can put any trash in here).
##
BindGlobal ( "AutomataParameters", rec (
  identity_symbol := "e"
));


###############################################################################
##
#V  InfoAutomata
##
DeclareInfoClass("InfoAutomata");
DeclareInfoClass("MDbg"); # it's my debug info, create your own if you wish




