#############################################################################
##
#W  testmanual.g               automata package                Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("Examples from manual", function()
  local L, T, a, b, t;

# from selfs.gd

  T := AutomatonGroup("t=(1,t)(1,2)");
  L := AutomatonGroup("a=(a,b)(1,2), b=(a,b)");

  AssertEqual( OrbitOfVertex([1,1,1], T.1), [[1,1,1],[2,1,1],[1,2,1],[2,2,1],[1,1,2],[2,1,2],[1,2,2],[2,2,2]]);

  AssertEqual(NumberOfVertex([1,2,1,2], 2), 6);
  AssertEqual(NumberOfVertex("333", 3), 27);

  AssertEqual(VertexNumber(1,3,2), [1, 1, 1]);
  AssertEqual(VertexNumber(4,4,3), [ 1, 1, 2, 1 ]);

  AssertEqual(PermActionOnLevel((1,4,2,3), 2, 1, 2), (1,2) );
  AssertEqual(PermActionOnLevel((1,13,5,9,3,15,7,11)(2,14,6,10,4,16,8,12), 4, 2, 2), (1,4,2,3) );

  AssertEqual(PermOnLevelAsMatrix(L.1*L.2, 2), [[0,0,0,1],[0,0,1,0],[0,1,0,0],[1,0,0,0]]);



end);
