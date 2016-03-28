#############################################################################
##
#W  testautom.g               automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##  automgrp v 1.3
##
#Y  Copyright (C) 2003 - 2016 Dmytro Savchuk, Yevgen Muntyan
##

UnitTest("Automaton", function()
  local B, C, B_min, MDR;
  B := MealyAutomaton("a=(1,a)(1,2), b=(1,a)(1,2), c=(a,b), d=(a,b)");
  B_min := MinimizationOfAutomatonTrack(B);
  AssertEqual(AutomatonList(B_min[1]), [ [ 3, 1, (1,2) ], [ 1, 1, () ], [ 3, 3, () ] ]);
  B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
  AssertTrue(IsOfPolynomialGrowth(B));
  AssertTrue(IsBounded(B));
  AssertEqual(PolynomialDegreeOfGrowth(B),0);

  AssertTrue(not IsOfPolynomialGrowth(MealyAutomaton("a=(a,b)(1,2), b=(b,a)")));

  C := MealyAutomaton("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
  AssertTrue(not IsBounded(C));
  AssertEqual(PolynomialDegreeOfGrowth(C),2);

  B := MealyAutomaton("a=(b,a)(1,2), b=(b,a)");
  AssertEqual(AutomatonList(DualAutomaton(B)), [ [ 2, 1, Transformation( [ 2, 2 ] ) ], [ 1, 2, Transformation( [ 1, 1 ] ) ] ]);
  AssertEqual(AutomatonList(InverseAutomaton(B)), [ [ 1, 2, (1,2) ], [ 2, 1, () ] ] );

  AssertTrue(IsBireversible(MealyAutomaton("a=(c,c)(1,2), b=(a,b), c=(b,a)")));
  AssertTrue(IsIRAutomaton(MealyAutomaton("a=(b,a)(1,2), b=(a,b)")));

  AssertTrue(IsTrivial(MealyAutomaton("a=(c,c), b=(a,b), c=(b,a)")));

  B:=MealyAutomaton("a=(d,d,d,d)(1,2)(3,4),b=(b,b,b,b)(1,4)(2,3),c=(a,c,a,c),d=(c,a,c,a)");
  AssertEqual(NumberOfStates(MinimizationOfAutomaton(B^6)),1093);
  MDR:=MDReduction(B);
  AssertEqual(List([1..2],i->AutomatonList(MDR[i])), [ [ [ 2, 2, 1, 1, (1,4,3) ], [ 1, 1, 2, 2, (1,4) ] ], [ [ 4, 4, (1,2) ], [ 2, 2, (1,2) ], [ 1, 3, () ], [ 3, 1, () ] ] ]);

  AssertEqual(AutomatonList(DisjointUnion(MealyAutomaton("a=(a,b)(1,2), b=(a,b)"),MealyAutomaton("c=(d,c), d=(c,e)(1,2), e=(e,d)"))),
              [ [ 1, 2, (1,2) ], [ 1, 2, () ], [ 4, 3, () ], [ 3, 5, (1,2) ], [ 5, 4, () ] ]);

  AssertTrue(AreEquivalentAutomata(MealyAutomaton("a=(b,a)(1,2), b=(a,c), c=(b,c)(1,2)"), MealyAutomaton("b=(a,c), c=(b,c)(1,2), a=(b,a)(1,2), d=(b,c)(1,2)")));

  AssertEqual(AutomatonList(SubautomatonWithStates(MealyAutomaton("a=(e,d)(1,2),b=(c,c),c=(b,c)(1,2),d=(a,e)(1,2),e=(e,d)"), [1, 4])), [ [ 3, 2, (1,2) ], [ 1, 3, (1,2) ], [ 3, 2, () ] ]);

  AssertEqual(AutomatonList(AutomatonNucleus(MealyAutomaton("a=(b,c)(1,2),b=(d,d),c=(d,b)(1,2),d=(d,b)(1,2),e=(a,d)"))), [ [ 2, 2, () ], [ 2, 1, (1,2) ] ]);


  AssertEqual(AdjacencyMatrix(MealyAutomaton("a=(a,a,b)(1,2,3),b=(a,c,b)(1,2),c=(a,a,a)")), [ [ 2, 1, 0 ], [ 1, 1, 1 ], [ 3, 0, 0 ] ]);

  AssertTrue(IsAcyclic(MealyAutomaton("a=(a,a,b)(1,2,3),b=(c,c,b)(1,2),c=(d,c,1),d=(d,1,d)")));

  AssertTrue(not IsAcyclic(MealyAutomaton("a=(a,a,b)(1,2,3),b=(c,c,d)(1,2),c=(d,c,1),d=(b,1,d)")));

end);
