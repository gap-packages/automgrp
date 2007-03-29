UnitTest("Order", function()
  local fam, group, lists, l, i;

  group := AutomGroup([[1,1,()]]);
  AssertEqual(Order(group.1), 1);

  group := AutomGroup("a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)");
  for i in [1..2] do
    if i = 2 then IsContracting(group); fi;
    AssertEqual(Order(group.1), 2);
    AssertEqual(Order(group.2), 2);
    AssertEqual(Order(group.3), 2);
    AssertEqual(Order(group.4), 2);
    AssertEqual(Order(group.1 * group.2), infinity);
    AssertEqual(Order(group.1 * group.3), infinity);
    AssertEqual(Order(group.1 * group.4), infinity);
  od;

  group := AutomGroup("a=(1,1)(1,2), b=(a,c), c=(a,d), d=(1,b)");
  for i in [1..2] do
    if i = 2 then IsContracting(group); fi;
    AssertEqual(Order(group.1 * group.2), 16);
    AssertEqual(Order(group.1 * group.3), 8);
    AssertEqual(Order(group.1 * group.4), 4);
  od;

  group := AutomGroup("a=(1,b)(1,2), b=(1,a)");
  for i in [1..2] do
    if i = 2 then IsContracting(group); fi;
    AssertEqual(Order(group.1), infinity);
    AssertEqual(Order(group.2), infinity);
    AssertEqual(Order(group.1 * group.2), infinity);
  od;

  group := AutomGroup([[1,1,1,1,()],[1,1,1,1,(1,3)(2,4)],[1,2,4,4,()],[1,1,3,3,()]], ["e", "a", "b", "c"]);
  AssertEqual(Order(group.1 * group.2 * group.3), infinity);

  group := AutomGroup([[1,1,1,1,()],[1,1,1,1,(1,3)(2,4)],[1,2,4,4,()],[2,1,3,3,()]], ["e", "a", "b", "c"]);
  AssertEqual(Order(group.1 * group.2), infinity);
end);
