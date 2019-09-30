#############################################################################
##
#W  autom.tst                automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

#@local B, C, B_min, MDR;
gap> B := MealyAutomaton("a=(1,a)(1,2), b=(1,a)(1,2), c=(a,b), d=(a,b)");
<automaton>
gap> B_min := MinimizationOfAutomatonTrack(B);
[ <automaton>, [ 1, 3, 5 ], [ 1, 1, 2, 2, 3 ] ]
gap> AutomatonList(B_min[1]);
[ [ 3, 1, (1,2) ], [ 1, 1, () ], [ 3, 3, () ] ]
gap> B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
<automaton>
gap> IsOfPolynomialGrowth(B);
true
gap> IsBounded(B);
true
gap> PolynomialDegreeOfGrowth(B);
0

#
gap> IsOfPolynomialGrowth(MealyAutomaton("a=(a,b)(1,2), b=(b,a)"));
false

#
gap> C := MealyAutomaton("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
<automaton>
gap> IsBounded(C);
false
gap> PolynomialDegreeOfGrowth(C);
2

#
gap> B := MealyAutomaton("a=(b,a)(1,2), b=(b,a)");
<automaton>
gap> AutomatonList(DualAutomaton(B));
[ [ 2, 1, Transformation( [ 2, 2 ] ) ], [ 1, 2, Transformation( [ 1, 1 ] ) ] ]
gap> AutomatonList(InverseAutomaton(B));
[ [ 1, 2, (1,2) ], [ 2, 1, () ] ]

#
gap> IsBireversible(MealyAutomaton("a=(c,c)(1,2), b=(a,b), c=(b,a)"));
true
gap> IsIRAutomaton(MealyAutomaton("a=(b,a)(1,2), b=(a,b)"));
true

#
gap> IsTrivial(MealyAutomaton("a=(c,c), b=(a,b), c=(b,a)"));
true

#
gap> B:=MealyAutomaton("a=(d,d,d,d)(1,2)(3,4),b=(b,b,b,b)(1,4)(2,3),c=(a,c,a,c),d=(c,a,c,a)");
<automaton>
gap> NumberOfStates(MinimizationOfAutomaton(B^6));
1093
gap> MDR:=MDReduction(B);
[ <automaton>, <automaton> ]
gap> List([1..2],i->AutomatonList(MDR[i]));
[ [ [ 2, 2, 1, 1, (1,4,3) ], [ 1, 1, 2, 2, (1,4) ] ], 
  [ [ 4, 4, (1,2) ], [ 2, 2, (1,2) ], [ 1, 3, () ], [ 3, 1, () ] ] ]

#
gap> AutomatonList(DisjointUnion(MealyAutomaton("a=(a,b)(1,2), b=(a,b)"),MealyAutomaton("c=(d,c), d=(c,e)(1,2), e=(e,d)")));
[ [ 1, 2, (1,2) ], [ 1, 2, () ], [ 4, 3, () ], [ 3, 5, (1,2) ], [ 5, 4, () ] ]

#
gap> AreEquivalentAutomata(MealyAutomaton("a=(b,a)(1,2), b=(a,c), c=(b,c)(1,2)"),
>                          MealyAutomaton("b=(a,c), c=(b,c)(1,2), a=(b,a)(1,2), d=(b,c)(1,2)"));
true

#
gap> AutomatonList(SubautomatonWithStates(MealyAutomaton("a=(e,d)(1,2),b=(c,c),c=(b,c)(1,2),d=(a,e)(1,2),e=(e,d)"), [1, 4]));
[ [ 3, 2, (1,2) ], [ 1, 3, (1,2) ], [ 3, 2, () ] ]

#
gap> AutomatonList(AutomatonNucleus(MealyAutomaton("a=(b,c)(1,2),b=(d,d),c=(d,b)(1,2),d=(d,b)(1,2),e=(a,d)")));
[ [ 2, 2, () ], [ 2, 1, (1,2) ] ]

#
gap> AdjacencyMatrix(MealyAutomaton("a=(a,a,b)(1,2,3),b=(a,c,b)(1,2),c=(a,a,a)"));
[ [ 2, 1, 0 ], [ 1, 1, 1 ], [ 3, 0, 0 ] ]

#
gap> IsAcyclic(MealyAutomaton("a=(a,a,b)(1,2,3),b=(c,c,b)(1,2),c=(d,c,1),d=(d,1,d)"));
true

#
gap> not IsAcyclic(MealyAutomaton("a=(a,a,b)(1,2,3),b=(c,c,d)(1,2),c=(d,c,1),d=(b,1,d)"));
true
