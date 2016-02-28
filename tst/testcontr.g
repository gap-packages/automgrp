#############################################################################
##
#W  testcontr.g               automgrp package                 Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.3
##
#Y  Copyright (C) 2003 - 2016 Dmytro Savchuk, Yevgen Muntyan
##

# XXX
UnitTest("Contracting groups", function()
  local l, ContractingGroups,     NoncontractingGroups,     CantDecideGroups,\
           ContractingGroupsDefs, NoncontractingGroupsDefs, CantDecideGroupsDefs,\
           SelfSimilarGroupsDefs, SelfSimilarGroups;

  ContractingGroupsDefs := [
    [[1,1,()]],
    "a=(1,a)(1,2)",
    "a=(1,b)(1,2), b=(1,a)",
    "a=(1,1)(1,2), b=(a,c), c=(a,d), d=(1,b)",
    "a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)",
    "a=(1,2)(3,4), b=(a,c,a,c),c=(b,1,1,b)",
    "a=(b,b)(1,2), b=(c,b), c=(c,a)"
  ];

  NoncontractingGroupsDefs := [
    "a=(b,a)(1,2),b=(c,b)(),c=(c,a)",
    "a=(c,b)(1,2),b=(c,b)(),c=(a,a)",
  ];

  CantDecideGroupsDefs := [
    "a=(c,b), b=(b,c), c=(a,a)(1,2)",
    "a=(c,b)(1,2), b=(b,c)(1,2), c=(a,a)",
  ];

  SelfSimilarGroupsDefs := [
    "x=(1,y)(1,2),y=(z^-1,1)(1,2),z=(1,x*y)",
  ];

  ContractingGroups := List( ContractingGroupsDefs, AutomatonGroup );
  NoncontractingGroups := List( NoncontractingGroupsDefs, AutomatonGroup );
  CantDecideGroups := List( CantDecideGroupsDefs, AutomatonGroup );
  SelfSimilarGroups := List( SelfSimilarGroupsDefs, SelfSimilarGroup);

  for l in ContractingGroups do
    AssertTrue(IsContracting(l));
  od;
  for l in NoncontractingGroups do
    AssertTrue(IsNoncontracting(l,10,10));
  od;

  AssertEqual(Length(GroupNucleus(ContractingGroups[3])),7);
  AssertEqual(Length(GroupNucleus(ContractingGroups[4])),5);
  AssertEqual(Length(GroupNucleus(ContractingGroups[5])),5);
  AssertEqual(Length(GroupNucleus(ContractingGroups[6])),35);
  AssertEqual(Length(GroupNucleus(SelfSimilarGroups[1])),7);
  AssertEqual(Length(GroupNucleus(ContractingGroups[7])),8);
  AssertEqual(ContractingLevel(ContractingGroups[6]),3);
  AssertEqual(ContractingLevel(ContractingGroups[7]),4);

end);
