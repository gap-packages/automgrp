#############################################################################
##
#W  testutil.g               automata package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
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
##  actual unit test functionality is in Assert* calls, for instance
##
##  UnitTest("Testing some stuff", function()
##    AssertEqual(1+1, 2);
##    AssertEqual(1+2, 3);
##    AssertTrue(1 = 1);
##    AssertFalse(1 = 2, "1 is equal to 2, OOPS!");
##  end);

UnitTestData := rec();
_ut_arg := "UnitTestSpecialArgument";
_ut_arg1 := "UnitTestSpecialArgument1";
_ut_arg2 := "UnitTestSpecialArgument2";

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
    if AG_Globals.unit_test_dots then
      Print(".\c");
    fi;
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
        if m = _ut_arg then
          Print(r[2][1]);
        elif m = _ut_arg1 then
          Print(r[2][2]);
        elif m = _ut_arg2 then
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
    Print("\nAll ", total, " tests passed\n");
  fi;
end;

Assert_ := function(condition, test_args, msg_args, def_msg_args)
  local result;

  if IsEmpty(msg_args) then
    msg_args := def_msg_args;
  fi;

  if condition then
    result := [true];
    if AG_Globals.unit_test_dots then
      Print(".\c");
    fi;
  else
    result := [false, test_args, msg_args];
    if AG_Globals.unit_test_dots then
      Print("F\c");
    fi;
  fi;

  Add(UnitTestData.current_test.results, result);
end;

AssertTrue := function(arg)
  Assert_(IsIdenticalObj(arg[1], true), [arg[1], arg[1], ], arg{[2..Length(arg)]},
          ["assertion '", _ut_arg, "' failed"]);
end;

AssertFalse := function(arg)
  Assert_(IsIdenticalObj(arg[1], false), [arg[1], arg[1], ], arg{[2..Length(arg)]},
          ["assertion 'not ", _ut_arg, "' failed"]);
end;

AssertFail := function(arg)
  Assert_(IsIdenticalObj(arg[1], fail), [arg[1], arg[1], ], arg{[2..Length(arg)]},
          ["assertion '", _ut_arg, " = fail' failed"]);
end;

AssertEqual := function(arg)
  Assert_(arg[1] = arg[2], [, arg[1], arg[2]], arg{[3..Length(arg)]},
          ["assertion '", _ut_arg1, " = ", _ut_arg2, "' failed"]);
end;

AssertLess := function(arg)
  Assert_(arg[1] < arg[2], [, arg[1], arg[2]], arg{[3..Length(arg)]},
          ["assertion '", _ut_arg1, " < ", _ut_arg2, "' failed"]);
end;

AssertLessOrEqualThan := function(arg)
  Assert_(arg[1] <= arg[2], [, arg[1], arg[2]], arg{[3..Length(arg)]},
          ["assertion '", _ut_arg1, " <= ", _ut_arg2, "' failed"]);
end;

AssertNotEqual := function(arg)
  Assert_(arg[1] <> arg[2], [, arg[1], arg[2]], arg{[3..Length(arg)]},
          ["assertion '", _ut_arg1, " <> ", _ut_arg2, "' failed"]);
end;

AssertIn := function(arg)
  Assert_(arg[1] in arg[2], [, arg[1], arg[2]], arg{[3..Length(arg)]},
          ["assertion '", _ut_arg1, " in ", _ut_arg2, "' failed"]);
end;

AssertNotReached := function(arg)
  Assert_(false, [,,], arg,
          ["code should not have been reached"]);
end;
