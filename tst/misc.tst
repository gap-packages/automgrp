#############################################################################
##
#W  misc.tst                 automgrp package                  Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

#@local g
gap> g := AutomatonGroup("a=(1,2), b=(a,c), c=(a,d), d=(1,b)", false);
< a, b, c, d >

# if it doesn't see that the words are equal then this equality will
# recurse too deep
gap> g.1^56 = g.1^56;
true
