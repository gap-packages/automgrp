#############################################################################
##
#W  rws.gd                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#O  AG_UseRewritingSystem( <G>[, <setting>] )
##
##  <#GAPDoc Label="AG_UseRewritingSystem">
##  <ManSection>
##  <Oper Name="AG_UseRewritingSystem" Arg="G[, setting]"/>
##  <Description>
##  Tells whether computations in the group <A>G</A> should use a rewriting system.
##  <A>setting</A> defaults to <K>true</K> if omitted. This function initially only
##  tries to find involutions in <A>G</A>. See <Ref Func="AG_AddRelators"/>
##  and <Ref Func="AG_UpdateRewritingSystem"/> for the ways
##  to add more relators.
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> Comm(a*b, b*a);
##  b^-1*a^-2*b^-1*a*b^2*a
##  gap> AG_UseRewritingSystem(G);
##  gap> Comm(a*b, b*a);
##  1
##  gap> AG_UseRewritingSystem(G, false);
##  gap> Comm(a*b, b*a);
##  b^-1*a^-2*b^-1*a*b^2*a
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AG_UseRewritingSystem", [IsObject]);
DeclareOperation("AG_UseRewritingSystem", [IsObject, IsBool]);


#############################################################################
##
#O  AG_AddRelators( <G>, <relators> )
##
##  <#GAPDoc Label="AG_AddRelators">
##  <ManSection>
##  <Oper Name="AG_AddRelators" Arg="G, relators"/>
##  <Description>
##  Adds relators from the list <A>relators</A> to the rewriting system used in
##  <A>G</A>.
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> AG_UseRewritingSystem(G);
##  gap> b*c;
##  b*c
##  gap> AG_AddRelators(G, [b*c*d]);
##  gap> b*c;
##  d
##  ]]></Example>
##  In some cases it's hard to find relations directly from the wreath
##  recursion of a self-similar group (at least, there is no general agorithm).
##  This function provides possibility to add relators manually. After that
##  one can use <Ref Func="AG_UpdateRewritingSystem"/>
##  and <Ref Func="AG_UseRewritingSystem"/> to use these
##  relators in computations. In the example below we consider a finite group
##  <M>H</M>, in which <M>a=b</M>, but the standard algorithm is unable to solve the
##  word problem. There are two solutions for that. One can manually add a
##  relator, or one can ask if the group is finite (which does not stop
##  generally if the group is infinite).
##  <Example><![CDATA[
##  gap> H := SelfSimilarGroup("a=(a*b,1)(1,2), b=(1,b*a^-1)(1,2), c=(b, a*b)");
##  < a, b, c >
##  gap> AG_AddRelators(H, [a*b^-1]);
##  gap> AG_UseRewritingSystem(H);
##  gap> Order(a*c);
##  4
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AG_AddRelators", [IsObject, IsList]);


#############################################################################
##
#O  AG_UpdateRewritingSystem( <G>, <maxlen> )
##
##  <#GAPDoc Label="AG_UpdateRewritingSystem">
##  <ManSection>
##  <Oper Name="AG_UpdateRewritingSystem" Arg="G, maxlen"/>
##  <Description>
##  Tries to find new relators of length up to <A>maxlen</A> and adds them into
##  the rewriting system. It can also be used after introducing new relators
##  via <Ref Func="AG_AddRelators"/>.
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> AG_UseRewritingSystem(G);
##  gap> b*c;
##  b*c
##  gap> AG_UpdateRewritingSystem(G, 3);
##  gap> b*c;
##  d
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AG_UpdateRewritingSystem", [IsObject]);
DeclareOperation("AG_UpdateRewritingSystem", [IsObject, IsPosInt]);


#############################################################################
##
#O  AG_RewritingSystem( <G> )
##
##  <#GAPDoc Label="AG_RewritingSystem">
##  <ManSection>
##  <Oper Name="AG_RewritingSystem" Arg="G"/>
##  <Description>
##  Returns the rewriting system object. See also <C>AG_UseRewritingSystem</C>
##  (<Ref Func="AG_UseRewritingSystem"/>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AG_RewritingSystem", [IsObject]);


#############################################################################
##
#O  AG_RewritingSystemRules( <G> )
##
##  <#GAPDoc Label="AG_RewritingSystemRules">
##  <ManSection>
##  <Oper Name="AG_RewritingSystemRules" Arg="G"/>
##  <Description>
##  Returns the list of rules used in the rewriting system of group <A>G</A>.
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> AG_UseRewritingSystem(G);
##  gap> AG_RewritingSystemRules(G);
##  [ [ a^2, <identity ...> ], [ b^2, <identity ...> ], [ c^2, <identity ...> ], 
##    [ d^2, <identity ...> ], [ A, a ], [ B, b ], [ C, c ], [ D, d ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AG_RewritingSystemRules", [IsObject]);

DeclareOperation("AG_ReducedForm", [IsObject]);
DeclareOperation("AG_ReducedForm", [IsObject, IsObject]);


#E
