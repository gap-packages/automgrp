#############################################################################
##
#W  testiter.g               automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("Iterator", function()
  local G, g, elms, groups, inf_groups;

  groups := [
    Group(()),
    Group((1,2),(2,3)),
    Group((1,2),(1,2,3)),
    Group((1,2),(2,3),(3,4),(4,5)),
    Group((1,2),(1,2,3,4,5)),
  ];

  inf_groups := [
    [AutomatonGroup("a=(1,a)(1,2)", false), 50, 101],
    [AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false), 4, 40],
    [AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false), 5, 68],
    [AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false), 6, 108],
  ];

  for G in groups do
    elms := [];
    for g in AG_SemigroupIterator(G, infinity) do
      Add(elms, g);
    od;
    AssertEqual(Length(elms), Size(G));
    AssertEqual(Length(elms), Length(AsSet(elms)));
  od;

  for G in inf_groups do
    elms := [];
    for g in AG_SemigroupIterator(G[1], G[2]) do
      Add(elms, g);
    od;
    AssertEqual(Length(elms), G[3]);
    AssertEqual(Length(elms), Length(AsSet(elms)));
  od;
end);
