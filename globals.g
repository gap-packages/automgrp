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
##  It's made as one record with million (possible:) entries in order to not
##  pollute global namespace (and we can put any trash in here).
##
BindGlobal ( "AutomataParameters", rec (
  identity_symbol := "e",
  state_symbol := "a",
  state_symbol_dual := "d",
  bind_vars_autom_family := true,
  round_spectra := 7,
  scilab_stacksize := 100000000,
  use_inv_order_in_apply_nielsen := true
));


###############################################################################
##
#V  InfoAutomata
##
DeclareInfoClass("InfoAutomata");
SetInfoLevel(InfoAutomata, 5);


#E
