#############################################################################
##
#W  rws.gd                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


DeclareCategory("IsAGRewritingSystem", IsRewritingSystem and IsBuiltFromGroup);

DeclareOperation("AGRewritingSystem", [IsPosInt]);
DeclareOperation("AGRewritingSystem", [IsPosInt, IsObject]);

DeclareOperation("AddRule", [IsAGRewritingSystem, IsObject]);
DeclareOperation("AddRule", [IsAGRewritingSystem, IsObject, IsBool]);
DeclareOperation("AddRules", [IsAGRewritingSystem, IsObject]);
DeclareOperation("AddRules", [IsAGRewritingSystem, IsObject, IsBool]);
DeclareOperation("SetRwRules", [IsAGRewritingSystem, IsObject]);

DeclareOperation("AGRewritingSystem", [IsAutomFamily]);

#############################################################################
##
#O  UseAGRewritingSystem( <G>[, <setting>] )
##
##  Tells whether computations in the group <G> should use a rewriting system.
##  Namely, the rewriting system will be used if and only if the boolean argument <setting>
##  (the defaults value is `true' if omitted) is `true'.
##
##  \beginexample
##  gap> GrigorchukGroup := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> Comm(a*b, b*a);
##  b^-1*a^-2*b^-1*a*b^2*a
##  gap> UseAGRewritingSystem(G);
##  true
##  gap> Comm(a*b, b*a);
##  1
##  gap> UseAGRewritingSystem(G, false);
##  false
##  gap> Comm(a*b, b*a);
##  b^-1*a^-2*b^-1*a*b^2*a
##  \endexample
##
DeclareOperation("UseAGRewritingSystem", [IsAutomFamily, IsBool]);

DeclareGlobalFunction("BuildAGRewritingSystem");


#E
