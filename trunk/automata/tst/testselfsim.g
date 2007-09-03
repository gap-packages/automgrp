UnitTest("SelfSim", function()
  local fam, group, lists, l, i;

  group := SelfSimilarGroup([[[-1,2],[-2,1],(1,2)],[[-1],[-2],()]],["t","v"]);
  AssertTrue(IsFiniteState(group));
  
end);
