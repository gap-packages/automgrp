#############################################################################
##
#W  testall.g                automata package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Dmytro Savchuk, Yevgen Muntyan
##

# Do this to run tests:
# Read(Filename(DirectoriesLibrary("pkg/automata/tst"), "testall.g"));
#
# Test AutomataParameters.run_tests_forever flag for tests which require
# lot of time, i.e. if a test needs a minute to run, put it inside
# if AutomataParameters.run_tests_forever then ... fi;

Read(Filename(DirectoriesLibrary("pkg/automata/tst"), "testutil.g"));

saved := rec(
  info_level := InfoLevel(InfoAutomata),
  bind_vars_autom_family := AutomataParameters.bind_vars_autom_family,
);

SetInfoLevel(InfoAutomata, 0);
AutomataParameters.bind_vars_autom_family := false;

UnitTestInit("automata package");

for name in [
  "teststructures.g",
  "testorder.g",
]
do
Read(Filename(DirectoriesLibrary("pkg/automata/tst"), name));
od;

UnitTestRun();

SetInfoLevel(InfoAutomata, saved.info_level);
AutomataParameters.bind_vars_autom_family := saved.bind_vars_autom_family;
