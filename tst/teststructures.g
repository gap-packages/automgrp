UnitTest("Structures", function()
  local fam, group, lists, l;

  lists := [
    [[1, 1, ()]],
    [[1, 1, ()], [1, 2, (1,2)]],
    [[1, 1, ()], [1, 1, (1,2)], [2, 4, ()], [2, 5, ()], [1, 3, ()]],
  ];

  for l in lists do
    AssertTrue(IsAutomGroup(AutomGroup(l)));
  od;
end);


UnitTest("Multiplication", function()
  local l, lists, group, fam, w, a, count;

  lists := [
    [[1, 1, ()], [1, 2, (1,2)]],
    [[1, 1, ()], [1, 1, (1,2)], [2, 4, ()], [2, 5, ()], [1, 3, ()]],
  ];

  for l in lists do
    count := 0;
    group := AutomGroup(l);
    fam := UnderlyingAutomFamily(group);
    for w in fam!.freegroup do
      a := Autom(w, fam);
      AssertTrue(IsAutom(a));
      AssertEqual(a*a^-1, a^-1*a);
      AssertTrue(IsOne(a*a^-1));
      AssertEqual(a*a^-1, One(a));
      if AutomataParameters.run_tests_forever then
        AssertEqual(a*a, a^2);
      fi;
      count := count + 1;
      if count > 1000 then
        break;
      fi;
    od;
  od;
end);
