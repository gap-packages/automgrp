UnitTest("Order", function()
  local fam, group, lists, l;

  group := AutomGroup([[1,1,1,1,()],[1,1,1,1,(1,3)(2,4)],[1,2,4,4,()],[1,1,3,3,()]], ["e", "a", "b", "c"]);
  AssertEqual(Order(group.1 * group.2 * group.3), infinity);

  group := AutomGroup([[1,1,1,1,()],[1,1,1,1,(1,3)(2,4)],[1,2,4,4,()],[2,1,3,3,()]], ["e", "a", "b", "c"]);
  AssertEqual(Order(group.1 * group.2), infinity);
end);
