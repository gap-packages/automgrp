#############################################################################
##
#W  testall.g                automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.2.4
##
#Y  Copyright (C) 2003 - 2014 Dmytro Savchuk, Yevgen Muntyan
##

# Do this to run tests:
# Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.g"));
#
# Test AG_Globals.run_tests_forever flag for tests which require
# lot of time, i.e. if a test needs a minute to run, put it inside
# if AG_Globals.run_tests_forever then ... fi;

Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testutil.g"));

saved := rec(
  info_level := InfoLevel(InfoAutomGrp),
  bind_vars_autom_family := AG_Globals.bind_vars_autom_family,
);

SetInfoLevel(InfoAutomGrp, 0);
AG_Globals.bind_vars_autom_family := false;

UnitTestInit("automgrp package");

for name in [
  "testexternal.g",
  "teststructures.g",
  "testorder.g",
  "testcontr.g",
  "testiter.g",
  "testmisc.g",
  "testselfsim.g",
  "testmanual.g",
  "testrws.g",
]
do
Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), name));
od;

UnitTestRun();

SetInfoLevel(InfoAutomGrp, saved.info_level);
AG_Globals.bind_vars_autom_family := saved.bind_vars_autom_family;
