#############################################################################
##
#W  convertersfr.gd         automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#O  FR2AutomGrp( <G> )
##
##  <#GAPDoc Label="FR2AutomGrp">
##  <ManSection>
##  <Oper Name="FR2AutomGrp" Arg="G"/>
##  <Description>
##  This operation is designed to convert data structures defined in FR
##  package written by Laurent Bartholdi to corresponding structures in
##  AutomGrp package. Currently it is implemented for functionally recursive
##  groups, semigroups,  and their sub(semi)groups and elements.
##  <Example><![CDATA[
##  gap> ZZ := FRGroup("t=<,t>[2,1]");
##  <state-closed group over [ 1 .. 2 ] with 1 generator>
##  gap> AZZ := FR2AutomGrp(ZZ);
##  < t >
##  gap> Display(AZZ);
##  < t = (1, t)(1,2) >
##  ]]></Example>
##  <Example><![CDATA[
##  gap> i4 := FRMonoid("s=(1,2)","f=<s,f>[1,1]");
##  <state-closed monoid over [ 1 .. 2 ] with 2 generators>
##  gap> Ai4 := FR2AutomGrp(i4);
##  < 1, s, f >
##  gap> Display(Ai4);
##  < 1 = (1, 1), 
##    s = (1, 1)(1,2), 
##    f = (s, f)[1,1] >
##  ]]></Example>
##  <Example><![CDATA[
##  gap> S := FRGroup("a=<a*b^-2,b^3>(1,2)","b=<b^-1*a,1>");
##  <state-closed group over [ 1 .. 2 ] with 2 generators>
##  gap> AS := FR2AutomGrp(S);
##  < a, b >
##  gap> Display(AS);
##  < a = (a*b^-2, b^3)(1,2), 
##    b = (b^-1*a, 1) >
##  gap> AssignGeneratorVariables(S);
##  #I  Global variable `a' is already defined and will be overwritten
##  #I  Global variable `b' is already defined and will be overwritten
##  #I  Assigned the global variables [ "a", "b" ]
##  gap> x := a^3*b*a^-2;
##  <2|a^3*b*a^-2>
##  gap> DecompositionOfFRElement(x);
##  [ [ <2|a*b^-2>, <2|b^3*a^2*b^-1*a^-1> ], [ 2, 1 ] ]
##  gap> y := FR2AutomGrp(x);
##  a^3*b*a^-2
##  gap> Decompose(y);
##  (a*b^-2, b^3*a^2*b^-1*a^-1)(1,2)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("FR2AutomGrp", [IsObject]);


#############################################################################
##
#O  AutomGrp2FR( <G> )
##
##  <#GAPDoc Label="AutomGrp2FR">
##  <ManSection>
##  <Oper Name="AutomGrp2FR" Arg="G"/>
##  <Description>
##  This operation is designed to convert data structures defined in AutomGrp
##  to corresponding structures in the <C>FR</C> package written by Laurent
##  Bartholdi. Currently it is implemented for automaton and self-similar
##  (or, functionally recursive in L.Bartholdi's terminology) groups,
##  semigroups, their sub(semi)groups and elements.
##  <Example><![CDATA[
##  gap> G:=AutomatonGroup("a=(b,a)(1,2),b=(a,b)");
##  < a, b >
##  gap> FG := AutomGrp2FR(G);
##  <state-closed group over [ 1 .. 2 ] with 2 generators>
##  gap> DecompositionOfFRElement(FG.1);
##  [ [ <2|b>, <2|a> ], [ 2, 1 ] ]
##  gap> DecompositionOfFRElement(FG.2);
##  [ [ <2|a>, <2|b> ], [ 1, 2 ] ]
##  ]]></Example>
##  <Example><![CDATA[
##  gap> G := SelfSimilarGroup("a=(a*b^-2,b)(1,2),b=(b^2,a*b*a^-2)");
##  < a, b >
##  gap> F := AutomGrp2FR(G);
##  <state-closed group over [ 1 .. 2 ] with 2 generators>
##  gap> DecompositionOfFRElement(F.1);
##  [ [ <2|a*b^-2>, <2|b> ], [ 2, 1 ] ]
##  ]]></Example>
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(b,a)(1,2),b=(a,b),c=(c,a)(1,2)");
##  < a, b, c >
##  gap> H := Group([a*b,b*c^-2,a]);
##  < a*b, b*c^-2, a >
##  gap> FH := AutomGrp2FR(H);
##  <recursive group over [ 1 .. 2 ] with 3 generators>
##  gap> DecompositionOfFRElement(FH.1);
##  [ [ <2|b^2>, <2|a^2> ], [ 2, 1 ] ]
##  ]]></Example>
##  <Example><![CDATA[
##  gap> G := SelfSimilarSemigroup("a=(a*b^2,b*a)[1,1],b=(b,a*b*a)(1,2)");
##  < a, b >
##  gap> S := AutomGrp2FR(G);
##  <state-closed semigroup over [ 1 .. 2 ] with 2 generators>
##  gap> DecompositionOfFRElement(S.1);
##  [ [ <2|a*b^2>, <2|b*a> ], [ 1, 1 ] ]
##  ]]></Example>
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(b,a)(1,2),b=(a,b),c=(c,a)(1,2)");
##  < a, b, c >
##  gap> Decompose(a*b^-2);
##  (b^-1, a^-1)(1,2)
##  gap> x := AutomGrp2FR(a*b^-2);
##  <2|a*b^-2>
##  gap> DecompositionOfFRElement(x);
##  [ [ <2|b^-1>, <2|a^-1> ], [ 2, 1 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AutomGrp2FR", [IsObject]);

#E
