UnitTest("RWS 1", function()
  local g;
  g := SelfSimilarGroup("a=(1,a^-1)(1,2), b = (1, a^-1*b^2*a)");
  AG_AddRelators(g, [g.2]);
  AG_UseRewritingSystem(g);
  AssertTrue(IsOne(g.2));
end);
