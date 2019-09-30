#############################################################################
##
#W  testall.tst              automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##
gap> START_TEST("automgrp");
gap> __save_AG_Globals_unit_test_dots := AG_Globals.unit_test_dots;
false
gap> AG_Globals.unit_test_dots := false;
false
gap> Read(Filename(DirectoriesPackageLibrary("automgrp", "tst"), "run_unittests.g"));
Testing automgrp package

Parsing automaton string  done
Groups  done
Semigroups  done
Multiplication in groups  done
Multiplication in self-similar groups  done
Multiplication in semigroups  done
Multiplication in self-similar semigroups  done
Rewriting systems  done
Rewriting systems self-sim  done
Decompose  done
Order  done
SelfSim  done

All 6380 tests passed
gap> AG_Globals.unit_test_dots := __save_AG_Globals_unit_test_dots;
false
gap> STOP_TEST("automgrp/tst/testall.tst", 10000);
