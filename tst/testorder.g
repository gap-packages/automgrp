#############################################################################
##
#W  testorder.g              automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("Order", function()
  local fam, group, lists, l, i;

  group := AutomatonGroup([[1,1,()]], false);
  AssertEqual(Order(group.1), 1);

  group := AutomatonGroup("a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)", false);
  for i in [1..2] do
    if i = 2 then IsContracting(group); fi;
    AssertEqual(Order(group.1), 2);
    AssertEqual(Order(group.2), 2);
    AssertEqual(Order(group.3), 2);
    AssertEqual(Order(group.4), 2);
    AssertEqual(Order(group.1 * group.2), infinity);
    AssertEqual(Order(group.1 * group.3), infinity);
    AssertEqual(Order(group.1 * group.4), infinity);
  od;

  group := AutomatonGroup("a=(1,1)(1,2), b=(a,c), c=(a,d), d=(1,b)", false);
  for i in [1..2] do
    if i = 2 then IsContracting(group); fi;
    AssertEqual(Order(group.1 * group.2), 16);
    AssertEqual(Order(group.1 * group.3), 8);
    AssertEqual(Order(group.1 * group.4), 4);
    AssertNotEqual(Order(group.1 * group.2 * group.1), infinity);
    AssertNotEqual(Order(group.1 * group.3 * group.1), infinity);
    AssertNotEqual(Order(group.1 * group.4 * group.1), infinity);
  od;

  group := AutomatonGroup("a=(1,b)(1,2), b=(1,a)", false);
  for i in [1..2] do
    if i = 2 then IsContracting(group); fi;
    AssertEqual(Order(group.1), infinity);
    AssertEqual(Order(group.2), infinity);
    AssertEqual(Order(group.1 * group.2), infinity);
  od;

  group := AutomatonGroup([[1,1,1,1,()],[1,1,1,1,(1,3)(2,4)],[1,2,4,4,()],[1,1,3,3,()]], ["e", "a", "b", "c"], false);
  AssertEqual(Order(group.1 * group.2 * group.3), infinity);

  group := AutomatonGroup([[1,1,1,1,()],[1,1,1,1,(1,3)(2,4)],[1,2,4,4,()],[2,1,3,3,()]], ["e", "a", "b", "c"], false);
  AssertEqual(Order(group.1 * group.2), infinity);

  group := SelfSimilarGroup("a=(c*b^-1,b)(1,2), b=(a*c,b), c=(b,a*b^-2)");
  AssertEqual(Order(group.1), infinity);
  AssertEqual(Order(group.2), infinity);
  AssertEqual(Order(group.3), infinity);

  group := AutomatonGroup("a=(c,a)(1,2), b=(b,c), c=(b,a)");
  AssertEqual(Order(group.1), infinity);
  AssertEqual(Order(group.2), infinity);
  AssertEqual(Order(group.3), infinity);
  AssertEqual(Order(group.1 * group.1 * group.3), infinity);

end);
