#############################################################################
##
#W  globals.g               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
##  AG_Globals
##
##  This record contains various global variables for automata package.
##  It's made as one record with million (possible) entries in order to not
##  pollute global namespace (and we can put any trash in here).
##
BindGlobal("AG_Globals", rec(
  identity_symbol := "1",
  state_symbol := "a",
  state_symbol_dual := "d",
  bind_vars_autom_family := true,
  round_spectra := 7,
  scilab_stacksize := 100000000,
  use_inv_order_in_apply_nielsen := true,
  run_tests_forever := false,
));


###############################################################################
##
#V  InfoAutomGrp
##
DeclareInfoClass("InfoAutomGrp");
SetInfoLevel(InfoAutomGrp, 5);


#E
