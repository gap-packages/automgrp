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
##  Tells whether computations in the group <G> should use a rewriting system.
##  <setting> defaults to `true' if omitted.
##
##  \beginexample
##  gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> Comm(a*b, b*a);
##  b^-1*a^-2*b^-1*a*b^2*a
##  gap> AG_UseRewritingSystem(G);
##  true
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
##  Adds relators.
##
DeclareOperation("AG_AddRelators", [IsObject, IsList]);


#############################################################################
##
#O  AG_UpdateRewritingSystem( <G> )
##
##  Tries to find new relators.
##
DeclareOperation("AG_UpdateRewritingSystem", [IsObject]);
DeclareOperation("AG_UpdateRewritingSystem", [IsObject, IsPosInt]);


#############################################################################
##
#O  AG_RewritingSystem( <G> )
##
##  Returns the rewriting system object.
##
DeclareOperation("AG_RewritingSystem", [IsObject]);


#############################################################################
##
#O  AG_RewritingSystemRules( <G> )
##
##  Returns the list of rules used in the rewriting system.
##
DeclareOperation("AG_RewritingSystemRules", [IsObject]);


DeclareOperation("AG_ReducedForm", [IsObject, IsObject]);


#E
