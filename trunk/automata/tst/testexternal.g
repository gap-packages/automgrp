test_perm_power := function()
  local l, p;
  for l in [[1, 2, 3, 4], [1, 1, 1, 1], [-1, 3, 5, -1], [0, 1, 0, 1]] do
    for p in SymmetricGroup(4) do
      AssertEqual(Permuted(l, p), l^p);
    od;
  od;
end);

UnitTest("External", function()
  test_perm_power();
end);
