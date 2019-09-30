#############################################################################
##
#W  iterator.tst             automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

#@local G, elms

#
# permutation groups
#
gap> G := Group(());;
gap> elms := List(AG_SemigroupIterator(G, infinity));;
gap> [ Size(G), Length(elms),  Length(AsSet(elms)) ];
[ 1, 1, 1 ]

#
gap> G := Group((1,2),(2,3));;
gap> elms := List(AG_SemigroupIterator(G, infinity));;
gap> [ Size(G), Length(elms),  Length(AsSet(elms)) ];
[ 6, 6, 6 ]

#
gap> G := Group((1,2),(1,2,3));;
gap> elms := List(AG_SemigroupIterator(G, infinity));;
gap> [ Size(G), Length(elms),  Length(AsSet(elms)) ];
[ 6, 6, 6 ]

#
gap> G := Group((1,2),(2,3),(3,4),(4,5));;
gap> elms := List(AG_SemigroupIterator(G, infinity));;
gap> [ Size(G), Length(elms),  Length(AsSet(elms)) ];
[ 120, 120, 120 ]

#
gap> G := Group((1,2),(1,2,3,4,5));;
gap> elms := List(AG_SemigroupIterator(G, infinity));;
gap> [ Size(G), Length(elms),  Length(AsSet(elms)) ];
[ 120, 120, 120 ]

#
# infinite groups
#

#
gap> G := AutomatonGroup("a=(1,a)(1,2)", false);;
gap> elms := List(AG_SemigroupIterator(G, 50));;
gap> Length(elms);
101
gap> Length(AsSet(elms));
101

#
gap> G := AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false);;
gap> elms := List(AG_SemigroupIterator(G, 4));;
gap> Length(elms);
40
gap> Length(AsSet(elms));
40

#
gap> G := AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false);;
gap> elms := List(AG_SemigroupIterator(G, 5));;
gap> Length(elms);
68
gap> Length(AsSet(elms));
68

#
gap> G := AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false);;
gap> elms := List(AG_SemigroupIterator(G, 6));;
gap> Length(elms);
108
gap> Length(AsSet(elms));
108
