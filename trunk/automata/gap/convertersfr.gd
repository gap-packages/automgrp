#############################################################################
##
#W  convertersfr.gd         automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.3
##
#Y  Copyright (C) 2003 - 2015 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#O  FR2AutomGrp
##
##  This operation is designed to convert data structures defined in FR
##  package written by Laurent Bartholdi to corresponding structures in
##  AutomGrp package.
##
DeclareOperation("FR2AutomGrp", [IsObject]);


#############################################################################
##
#O  AutomGrp2FR
##
##  This operation is designed to convert data structures defined in AutomGrp
##  to corresponding structures in AutomGrp package written by Laurent
##  Bartholdi.
##
##  gap> G:=AutomatonGroup("a=(b,a)(1,2),b=(a,b)");
##  < a, b >
##  gap> FG:=AutomGrp2FR(G);
##  <state-closed group over [ 1 .. 2 ] with 2 generators>
##  gap> DecompositionOfFRElement(FG.1);
##  [ [ <2|b>, <2|a> ], [ 2, 1 ] ]
##  gap> DecompositionOfFRElement(FG.2);
##  [ [ <2|a>, <2|b> ], [ 1, 2 ] ]

##  gap> G2:=AutomatonGroup("a=(a,a)(1,2),b=(1,1)(1,2)");
##  < a, b >
##  gap> FG2:=AutomGrp2FR(G2);
##  <state-closed group over [ 1 .. 2 ] with 2 generators>
##  gap> DecompositionOfFRElement(FG2.1);
##  [ [ <2|a>, <2|a> ], [ 2, 1 ] ]
##  gap> DecompositionOfFRElement(FG2.2);
##  [ [ <2|identity ...>, <2|identity ...> ], [ 2, 1 ] ]

##  gap> G:=AutomatonGroup("a=(b,a)(1,2),b=(a,b),c=(c,a)(1,2)");
##  < a, b, c >
##  gap> H:=Group([a*b,b*c^-2,a]);
##  < a*b, b*c^-2, a >
##  gap> FH:=AutomGrp2FR(H);
##  <recursive group over [ 1 .. 2 ] with 3 generators>
##  gap> DecompositionOfFRElement(FH.1);
##  [ [ <2|b^2>, <2|a^2> ], [ 2, 1 ] ]


##  gap> S:=AutomatonSemigroup("a=(a,a)[1,1],b=(c,1)(1,2),c=(b,c)[2,2]");
##  < 1, a, b, c >
##  gap> D:=Semigroup([a*b*c,c*a,b^2,c^3*a*b]);
##  < a*b*c, c*a, b^2, c^3*a*b >
##  gap> FD:=AutomGrp2FR(SS);
##  <recursive semigroup over [ 1 .. 2 ] with 4 generators>
##  gap> FD.1;
##  <2|a*b*c>
##  gap> FD.2;
##  <2|c*a>
##  gap> FD.3;
##  <2|b^2>
##  gap> FD.4;
##  <2|c^3*a*b>
##

##  gap> G:=AutomatonGroup("a=(b,a)(1,2),b=(a,b),c=(c,a)(1,2)");
##  < a, b, c >
##  gap> Decompose(a*b^-2);
##  (b^-1, a^-1)(1,2)
##  gap> x:=AutomGrp2FR(a*b^-2);
##  <2|a*b^-2>
##  gap> DecompositionOfFRElement(x);
##  [ [ <2|b^-1>, <2|a^-1> ], [ 2, 1 ] ]
##
DeclareOperation("AutomGrp2FR", [IsObject]);

#E
