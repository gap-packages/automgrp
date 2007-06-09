$ST_Groups := [
  [[[1,1,()]], false],
  ["a=(1,a)(1,2)", true],
  ["a=(1,b)(1,2), b=(1,a)", true],
  ["a=(1,1)(1,2), b=(a,c), c=(a,d), d=(1,b)", true],
  ["a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)", true],
  ["a=(c,b), b=(b,c), c=(a,a)(1,2)", false],
  ["a=(c,b)(1,2), b=(b,c)(1,2), c=(a,a)", false],
];

$ST_Semigroups := Concatenation($ST_Groups, [
  [[[1,1,Transformation([1,2])]]],
  [[[1,1,Transformation([1,1])]]],
  [[[1,1,Transformation([1,1])], [1,1,Transformation([1,1])]]],
  [[[1,2,Transformation([1,1])], [1,1,Transformation([1,2])]]],
]);


UnitTest("Groups", function()
  local l;
  for l in $ST_Groups do
    AssertTrue(IsAutomGroup(AutomGroup(l[1])));
    if l[2] then
      AssertTrue(IsContracting(AutomGroup(l[1])));
    fi;
  od;
end);

UnitTest("Semigroups", function()
  local l, g, a;
  for l in $ST_Semigroups do
    g := AutomSemigroup(l[1]);
    AssertTrue(IsAutomSemigroup(g));
    if l in $ST_Groups then
      AssertTrue(ForAll(GeneratorsOfSemigroup(g), IsInvertibleAutom));
      AssertTrue(IsAutomGroup(GroupOfAutomFamily(UnderlyingAutomFamily(g))));
    fi;
  od;
end);


$ST_MultWord := function(word, family)
  local rep, product, gen, i;

  rep := LetterRepAssocWord(word);
  product := One(family);

  for i in rep do
    if i > 0 then
      gen := family!.automgens[i];
    else
      gen := family!.automgens[-i]^-1;
    fi;
    product := product * gen;
  od;

  return product;
end;

$ST_TestMultiplication1 := function(table, isgroup, contracting, use_rws)
  local group, fam, w, a, b, c, count;

  if isgroup then
    group := AutomGroup(table, false);
  else
    group := AutomSemigroup(table, false);
  fi;

  fam := UnderlyingAutomFamily(group);

  if contracting then
    IsContracting(group);
  fi;

  if use_rws then
    fam!.rws := BuildAGRewritingSystem(fam);
    fam!.use_rws := true;
    if IsEmpty(Rules(fam!.rws)) then
      return;
    fi;
  fi;

  for count in [1..50] do
    a := Random(group);
    b := Random(group);
    c := Random(group);
    AssertTrue((a*b)*c = a*(b*c));
  od;

  count := 0;
  for w in fam!.freegroup do
    if isgroup or ForAll(LetterRepAssocWord(w), x -> x > 0) then
      a := Autom(w, fam);
      AssertTrue(IsAutom(a));
      AssertEqual(a, $ST_MultWord(w, fam));

      if isgroup then
        AssertEqual(a*a^-1, a^-1*a);
        AssertTrue(IsOne(a*a^-1));
        AssertEqual(a*a^-1, One(a));
      fi;

      if AutomataParameters.run_tests_forever then
        AssertEqual(a*a, a^2);
      fi;

      count := count + 1;
      if count > 50 then
        break;
      fi;
    fi;
  od;
end;

UnitTest("Multiplication in groups", function()
  local g;
  for g in $ST_Groups do
    $ST_TestMultiplication1(g[1], true, false, false);
    if g[2] then
      $ST_TestMultiplication1(g[1], true, true, false);
    fi;
  od;
end);

UnitTest("Multiplication in semigroups", function()
  local g;
  for g in $ST_Semigroups do
    $ST_TestMultiplication1(g[1], false, false, false);
  od;
end);


UnitTest("Rewriting systems", function()
  local l;
  for l in $ST_Groups do
    if Length(l[1]) > 1 then
      $ST_TestMultiplication1(l[1], true, false, true);
      if l[2] then
        $ST_TestMultiplication1(l[1], true, true, true);
      fi;
    fi;
  od;
end);
