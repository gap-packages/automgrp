#############################################################################
##
#W  testutil.g               automata package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Dmytro Savchuk, Yevgen Muntyan
##
##  This is a very simple version of unittest found in Java, C, Python, etc.
##  It can't inspect the tests code, it can't handle errors in tests,
##  therefore all it does is it wraps nicely test invocations, prints
##  some progress and produces some statistics.
##
##  The test suite (a file which is executed using Read()) looks like this:
##
##  UnitTestInit(name);
##  UnitTest(name,function-to-call);
##  ...
##  UnitTestRun();
##
##  The function-to-call argument to UnitTest must be a function with no
##  arguments, return value (if any) is ignored. It can do anything, the
##  actual unit test functoionality is in Assert* calls, for instance
##
##  UnitTest("Testing some stuff", function()
##    AssertEqual(1+1, 2);
##    AssertEqual(1+2, 3);
##    AssertTrue(1 = 1);
##    AssertFalse(1 = 2, "1 is equal to 2, OOPS!");
##  end);

UnitTestData := rec();
targ := "UnitTestSpecialArgument";
targ1 := "UnitTestSpecialArgument1";
targ2 := "UnitTestSpecialArgument2";

UnitTestInit := function(name)
  UnitTestData := rec(name := name,
                      tests := []);
end;

UnitTest := function(name, func)
  local test;

  test := rec(name := name,
              func := func,
              results := []);

  Add(UnitTestData.tests, test);
end;

UnitTestRun := function()
  local t, r, i, m, failed, total_failed, total;

  Print("Testing ", UnitTestData.name, "\n\n");

  for t in UnitTestData.tests do
    UnitTestData.current_test := t;
    Print(t.name, " ");
    t.func();
    Print(" done\n");
  od;

  total := 0;
  total_failed := 0;

  for t in UnitTestData.tests do
    failed := Filtered([1..Length(t.results)], i -> not t.results[i][1]);
    total := total + Length(t.results);
    total_failed := total_failed + Length(failed);

    if IsEmpty(failed) then
      continue;
    fi;

    Print("\n", t.name, "\n");

    for i in failed do
      r := t.results[i];
      Print("test ", i, " of ", Length(t.results), ": ");
      for m in r[3] do
        if m = targ then
          Print(r[2][1]);
        elif m = targ1 then
          Print(r[2][2]);
        elif m = targ2 then
          Print(r[2][3]);
        else
          Print(m);
        fi;
      od;
      Print("\n");
    od;
  od;

  if total_failed > 0 then
    Print("\n", total_failed, " of ", total, " tests failed\n");
  else
    Print("\nAll tests passed\n");
  fi;
end;

Assert_ := function(condition, test_args, msg_args, def_msg_args)
  local result;

  if IsEmpty(msg_args) then
    msg_args := def_msg_args;
  fi;

  if condition then
    result := [true];
  else
    result := [false, test_args, msg_args];
  fi;

  Add(UnitTestData.current_test.results, result);
  Print(".");
end;

AssertTrue := function(arg)
  Assert_(IsIdenticalObj(arg[1], true), [arg[1], arg[1], ], arg{[2..Length(arg)]},
          ["assertion '", targ, "' failed"]);
end;

AssertFalse := function(arg)
  Assert_(IsIdenticalObj(arg[1], false), [arg[1], arg[1], ], arg{[2..Length(arg)]},
          ["assertion 'not ", targ, "' failed"]);
end;

AssertFail := function(arg)
  Assert_(IsIdenticalObj(arg[1], fail), [arg[1], arg[1], ], arg{[2..Length(arg)]},
          ["assertion '", targ, " = fail' failed"]);
end;

AssertEqual := function(arg)
  Assert_(arg[1] = arg[2], [, arg[1], arg[2]], arg{[3..Length(arg)]},
          ["assertion '", targ1, " = ", targ2, "' failed"]);
end;

AssertNotEqual := function(arg)
  Assert_(arg[1] <> arg[2], [, arg[1], arg[2]], arg{[3..Length(arg)]},
          ["assertion '", targ1, " <> ", targ2, "' failed"]);
end;

AssertNotReached := function(arg)
  Assert_(false, [,,], arg,
          ["code should not have been reached"]);
end;
