$Groups := [
  [[[1,1,()]], false],
  ["a=(1,a)(1,2)", true],
  ["a=(1,b)(1,2), b=(1,a)", true],
  ["a=(1,1)(1,2), b=(a,c), c=(a,d), d=(1,b)", true],
  ["a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)", true],
  ["a=(c,b), b=(b,c), c=(a,a)(1,2)", false],
  ["a=(c,b)(1,2), b=(b,c)(1,2), c=(a,a)", false],
];


UnitTest("Structures", function()
  local l;
  for l in $Groups do
    AssertTrue(IsAutomGroup(AutomGroup(l[1])));
    if l[2] then
      AssertTrue(IsContracting(AutomGroup(l[1])));
    fi;
  od;
end);


$MultWord := function(word, family)
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

$TestMultiplication1 := function(table, contracting, use_rws)
  local group, fam, w, a, count;

  count := 0;
  group := AutomGroup(table);
  fam := UnderlyingAutomFamily(group);

  if contracting then
    IsContracting(group);
  fi;

  if use_rws then
    fam!.rws := BuildFARewritingSystem(fam);
    fam!.use_rws := true;
    if IsEmpty(Rules(fam!.rws)) then
      return;
    fi;
  fi;

  for w in fam!.freegroup do
    a := Autom(w, fam);
    AssertTrue(IsAutom(a));
    AssertEqual(a, $MultWord(w, fam));
    AssertEqual(a*a^-1, a^-1*a);
    AssertTrue(IsOne(a*a^-1));
    AssertEqual(a*a^-1, One(a));
    if AutomataParameters.run_tests_forever then
      AssertEqual(a*a, a^2);
    fi;
    count := count + 1;
    if count > 50 then
      break;
    fi;
  od;
end;

UnitTest("Multiplication", function()
  local g;
  for g in $Groups do
    $TestMultiplication1(g[1], false, false);
    if g[2] then
      $TestMultiplication1(g[1], true, false);
    fi;
  od;
end);


UnitTest("Rewriting systems", function()
  local l;
  for l in $Groups do
    if Length(l[1]) > 1 then
      $TestMultiplication1(l[1], false, true);
      if l[2] then
        $TestMultiplication1(l[1], true, true);
      fi;
    fi;
  od;
end);
