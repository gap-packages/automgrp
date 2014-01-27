#############################################################################
##
#W  testrws.g               automgrp package                   Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.2.4
##
#Y  Copyright (C) 2003 - 2014 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("RWS 1", function()
  local g;

  g := SelfSimilarGroup("a=(1,a^-1)(1,2), b = (1, a^-1*b^2*a)");
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));
  AG_AddRelators(g, [g.2]);
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));
  AG_UseRewritingSystem(g);
  AssertTrue(IsOne(g.2));
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));

  g := SelfSimilarGroup("a=(a^3,b^-1)(1,2), b = (b^3, a^-1)(1,2)");
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));
  AG_AddRelators(g, [g.1*g.2^-1]);
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));
  AG_UseRewritingSystem(g);
  AssertTrue(IsOne(g.1*g.2^-1));
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));

  g := AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)");
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));
  AssertTrue(g.3 = AG_ReducedForm(g.3));
  AssertTrue(g.4 = AG_ReducedForm(g.4));
  AG_UseRewritingSystem(g);
  AssertTrue(g = AG_ReducedForm(g));
  AssertTrue(g.1 = AG_ReducedForm(g.1));
  AssertTrue(g.2 = AG_ReducedForm(g.2));
  AssertTrue(g.3 = AG_ReducedForm(g.3));
  AssertTrue(g.4 = AG_ReducedForm(g.4));
  AssertTrue(g.4 in Group(g.2, g.3));
  AssertTrue(g.2 in Group(g.4, g.3));
  AssertTrue(g.3 in Group(g.2, g.4));
end);
