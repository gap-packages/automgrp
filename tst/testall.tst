#############################################################################
##
#W  testall.tst              automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.3.1
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

# Do this to run tests:
# Test(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.tst"), rec( compareFunction := "uptowhitespace" ));

gap> START_TEST("automgrp");
gap> __save_AG_Globals_unit_test_dots := AG_Globals.unit_test_dots;
false
gap> AG_Globals.unit_test_dots := false;
false
gap> Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.g"));
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
Contracting groups  done
Iterator  done
Miscellaneous  done
SelfSim  done
Examples from manual  done
RWS 1  done
Automaton  done

All 6480 tests passed
gap> AG_Globals.unit_test_dots := __save_AG_Globals_unit_test_dots;
false
gap> STOP_TEST("automgrp/tst/testall.tst", 10000);
automgrp
GAP4stones: 0


## -*- gap -*-
