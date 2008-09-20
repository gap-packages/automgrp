#############################################################################
##
#W  testexternal.g             automgrp package                Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("list^perm", function()
  local l, p;
  for l in [[1, 2, 3, 4], [1, 1, 1, 1], [-1, 3, 5, -1], [0, 1, 0, 1]] do
    for p in SymmetricGroup(4) do
      AssertEqual(Permuted(l, p), l^p);
    od;
  od;
end);
