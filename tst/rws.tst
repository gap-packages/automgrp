#############################################################################
##
#W  rws.tst                 automgrp package                   Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

#@local g

#
gap> g := SelfSimilarGroup("a=(1,a^-1)(1,2), b = (1, a^-1*b^2*a)");
< a, b >
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true
gap> AG_AddRelators(g, [g.2]);
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true
gap> AG_UseRewritingSystem(g);
gap> IsOne(g.2);
true
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true

#
gap> g := SelfSimilarGroup("a=(a^3,b^-1)(1,2), b = (b^3, a^-1)(1,2)");
< a, b >
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true
gap> AG_AddRelators(g, [g.1*g.2^-1]);
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true
gap> AG_UseRewritingSystem(g);
gap> IsOne(g.1*g.2^-1);
true
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true

#
gap> g := AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)");
< a, b, c, d >
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true
gap> g.3 = AG_ReducedForm(g.3);
true
gap> g.4 = AG_ReducedForm(g.4);
true
gap> AG_UseRewritingSystem(g);
gap> g = AG_ReducedForm(g);
true
gap> g.1 = AG_ReducedForm(g.1);
true
gap> g.2 = AG_ReducedForm(g.2);
true
gap> g.3 = AG_ReducedForm(g.3);
true
gap> g.4 = AG_ReducedForm(g.4);
true
gap> g.4 in Group(g.2, g.3);
true
gap> g.2 in Group(g.4, g.3);
true
gap> g.3 in Group(g.2, g.4);
true
