#############################################################################
##
#W  manual.tst                 automata package                Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

#@local L, T, a, b, t
# from selfs.gd
gap> T := AutomatonGroup("t=(1,t)(1,2)");
< t >
gap> L := AutomatonGroup("a=(a,b)(1,2), b=(a,b)");
< a, b >

#
gap> OrbitOfVertex([1,1,1], T.1);
[ [ 1, 1, 1 ], [ 2, 1, 1 ], [ 1, 2, 1 ], [ 2, 2, 1 ], [ 1, 1, 2 ], 
  [ 2, 1, 2 ], [ 1, 2, 2 ], [ 2, 2, 2 ] ]

#
gap> NumberOfVertex([1,2,1,2], 2);
6
gap> NumberOfVertex("333", 3);
27

#
gap> VertexNumber(1,3,2);
[ 1, 1, 1 ]
gap> VertexNumber(4,4,3);
[ 1, 1, 2, 1 ]

#
gap> PermActionOnLevel((1,4,2,3), 2, 1, 2);
(1,2)
gap> PermActionOnLevel((1,13,5,9,3,15,7,11)(2,14,6,10,4,16,8,12), 4, 2, 2);
(1,4,2,3)

#
gap> PermOnLevelAsMatrix(L.1*L.2, 2);
[ [ 0, 0, 0, 1 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], [ 1, 0, 0, 0 ] ]

#
gap> MarkovOperator(AutomatonGroup("p=(p,q)(1,2), q=(p,q)"), 3);
[ [ 0, 0, 1/4, 1/4, 0, 1/4, 0, 1/4 ], [ 0, 0, 1/4, 1/4, 1/4, 0, 1/4, 0 ], 
  [ 1/4, 1/4, 0, 0, 1/4, 0, 1/4, 0 ], [ 1/4, 1/4, 0, 0, 0, 1/4, 0, 1/4 ], 
  [ 0, 1/4, 1/4, 0, 0, 1/2, 0, 0 ], [ 1/4, 0, 0, 1/4, 1/2, 0, 0, 0 ], 
  [ 0, 1/4, 1/4, 0, 0, 0, 1/2, 0 ], [ 1/4, 0, 0, 1/4, 0, 0, 0, 1/2 ] ]

#
gap> MarkovOperator(AutomatonSemigroup("c=(c,d)[1,1],d=(c,c)(1,2)"),3,[1/3,2/3]);
[ [ 1/3, 0, 0, 0, 2/3, 0, 0, 0 ], [ 1/3, 0, 0, 0, 2/3, 0, 0, 0 ], 
  [ 0, 1/3, 0, 0, 0, 2/3, 0, 0 ], [ 1/3, 0, 0, 0, 2/3, 0, 0, 0 ], 
  [ 2/3, 0, 1/3, 0, 0, 0, 0, 0 ], [ 2/3, 0, 1/3, 0, 0, 0, 0, 0 ], 
  [ 1/3, 2/3, 0, 0, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0, 0, 0 ] ]
