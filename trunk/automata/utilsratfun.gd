#############################################################################
##
#W  utilsratfun.gd             automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##
##  Here are utility functions dealing with factor of AutT by its commutator
##  subgroup, i.e. with the additive group of rational functions over Z_2.
##

Revision.utilsratfun_gd :=
  "@(#)$Id$";


BindGlobal("AutomataAbelImageIndeterminate", Indeterminate(GF(2), "x"));
BindGlobal("AutomataAbelImageSpherTrans",
  One(AutomataAbelImageIndeterminate)/
    (One(AutomataAbelImageIndeterminate)+AutomataAbelImageIndeterminate));
DeclareGlobalFunction("AbelImageAutomatonInList");


#E
