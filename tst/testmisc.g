UnitTest("Miscellaneous", function()
  local g;

  g := AutomGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false);
  # if it doesn't see that the words are equal then this equality will
  # recurse too deep
  AssertTrue(g.1^56 = g.1^56);
end);
