#############################################################################
##
#W  rws.gd                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#O  AG_UseRewritingSystem( <G>[, <setting>] )
##
##  Tells whether computations in the group <G> should use a rewriting system
##  (depending on the value of <setting>). The default value of
##  <setting> is `true'. See also `AG_AddRelators' ("AG_AddRelators"),
##  `AG_UpdateRewritingSystem' ("AG_UpdateRewritingSystem") and `AG_RewritingSystemRules'
##  ("AG_RewritingSystemRules")
##
##  \beginexample
##  gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> Comm(a*b, b*a);
##  b^-1*a^-2*b^-1*a*b^2*a
##  gap> AG_UseRewritingSystem(G);
##  gap> Comm(a*b, b*a);
##  1
##  gap> AG_UseRewritingSystem(G, false);
##  false
##  gap> Comm(a*b, b*a);
##  b^-1*a^-2*b^-1*a*b^2*a
##  \endexample
##
DeclareOperation("AG_UseRewritingSystem", [IsObject, IsBool]);


#############################################################################
##
#O  AG_AddRelators( <G>, <relators> )
##
##  Adds relators to rewring system. In some cases it's hard to find relations
##  directly from the wreath recursion of a self-similar group (at least, there is
##  no general agorithm). This function provides possibility to add relators manually.
##  After that one can use `AG_UpdateRewritingSystem' (see "AG_UpdateRewritingSystem")
##  and `AG_UseRewritingSystem' (see "AG_UseRewritingSystem") to use these relators
##  in computations. In the example below we consider a finite group $H$, in which $a=b$, but the
##  standard algorithm is unable to solve the word problem. There are two solutions of
##  that. One can manually add a relator, or one can ask if the group is finite (which
##  does not stop generally if the group is infinite).
##  \beginexample
##  H := SelfSimilarGroup("a=(a*b,1)(1,2), b=(1,b*a^-1)(1,2), c=(b, a*b)");
##  < a, b, c >
##  gap> AG_AddRelators(H, [a*b^-1]);
##  gap> AG_UseRewritingSystem(H);
##  gap> Order(a*c);
##  4
##  \endexample

##
DeclareOperation("AG_AddRelators", [IsObject, IsList]);


#############################################################################
##
#O  AG_UpdateRewritingSystem( <G> )
##
##  Tries to find new relators based on the current information about <G>.
##  For example, one may use this command after introducing new relators via
##  `AG_AddRelators' (see "AG_AddRelators").
##
DeclareOperation("AG_UpdateRewritingSystem", [IsObject]);
DeclareOperation("AG_UpdateRewritingSystem", [IsObject, IsPosInt]);


#############################################################################
##
#O  AG_RewritingSystem( <G> )
##
##  Returns the rewriting system object. See also `AG_UseRewritingSystem' ("AG_UseRewritingSystem").
##
DeclareOperation("AG_RewritingSystem", [IsObject]);


#############################################################################
##
#O  AG_RewritingSystemRules( <G> )
##
##  Returns the list of rules used in the rewriting system of group <G>.
##  \beginexample
##  gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> AG_UseRewritingSystem(G);
##  gap> AG_RewritingSystemRules(G);
##  [ [ a^2, <identity ...> ], [ b^2, <identity ...> ], [ c^2, <identity ...> ],
##    [ d^2, <identity ...> ], [ a^-1, a ], [ b^-1, b ], [ c^-1, c ], [ d^-1, d ]
##   ]
##  \endexample
##
DeclareOperation("AG_RewritingSystemRules", [IsObject]);


DeclareOperation("AG_ReducedForm", [IsObject, IsObject]);


#E
