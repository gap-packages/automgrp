#############################################################################
##
#W  testrws.g               automgrp package                   Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.1.2
##
#Y  Copyright (C) 2003 - 2008 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("RWS 1", function()
  local g;

  g := SelfSimilarGroup("a=(1,a^-1)(1,2), b = (1, a^-1*b^2*a)");
  AG_AddRelators(g, [g.2]);
  AG_UseRewritingSystem(g);
  AssertTrue(IsOne(g.2));

  g :=  SelfSimilarGroup("a=(a^3,b^-1)(1,2), b = (b^3, a^-1)(1,2)");
  AG_AddRelators(g, [g.1*g.2^-1]);
  AG_UseRewritingSystem(g);
  AssertTrue(IsOne(g.1*g.2^-1));


end);
