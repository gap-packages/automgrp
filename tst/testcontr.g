# XXX
UnitTest("Contracting groups", function()
  local l, ContractingGroups, NoncontractingGroups, CantDecideGroups;

  ContractingGroups := [
    [[1,1,()]],
    "a=(1,a)(1,2)",
    "a=(1,b)(1,2), b=(1,a)",
    "a=(1,1)(1,2), b=(a,c), c=(a,d), d=(1,b)",
    "a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)",
  ];

  NoncontractingGroups := [
  ];

  CantDecideGroups := [
    "a=(c,b), b=(b,c), c=(a,a)(1,2)",
    "a=(c,b)(1,2), b=(b,c)(1,2), c=(a,a)",
  ];

  for l in ContractingGroups do
    AssertTrue(IsContracting(AutomatonGroup(l)));
  od;
  for l in NoncontractingGroups do
    AssertFalse(IsContracting(AutomatonGroup(l)));
  od;
end);
