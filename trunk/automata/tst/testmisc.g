#############################################################################
##
#W  testmisc.g               automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.3
##
#Y  Copyright (C) 2003 - 2016 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("Miscellaneous", function()
  local g;

  g := AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false);
  # if it doesn't see that the words are equal then this equality will
  # recurse too deep
  AssertTrue(g.1^56 = g.1^56);
end);
