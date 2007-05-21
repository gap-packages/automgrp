#############################################################################
##
#W  testall.g                automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Dmytro Savchuk, Yevgen Muntyan
##

# Do this to run tests:
# Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.g"));
#
# Test AutomataParameters.run_tests_forever flag for tests which require
# lot of time, i.e. if a test needs a minute to run, put it inside
# if AutomataParameters.run_tests_forever then ... fi;

Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testutil.g"));

saved := rec(
  info_level := InfoLevel(InfoAutomGrp),
  bind_vars_autom_family := AutomataParameters.bind_vars_autom_family,
);

SetInfoLevel(InfoAutomGrp, 0);
AutomataParameters.bind_vars_autom_family := false;

UnitTestInit("automgrp package");

for name in [
  "testexternal.g",
  "teststructures.g",
  "testorder.g",
  "testcontr.g",
  "testiter.g",
  "testmisc.g",
]
do
Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), name));
od;

UnitTestRun();

SetInfoLevel(InfoAutomGrp, saved.info_level);
AutomataParameters.bind_vars_autom_family := saved.bind_vars_autom_family;
