#############################################################################
##
#W  contracting.tst           automgrp package                 Dmytro Savchuk
#W                                                             Yevgen Muntyan
##
#Y  Copyright (C) 2003 - 2018 Dmytro Savchuk, Yevgen Muntyan
##

#@local l, ContractingGroups,     NoncontractingGroups,     CantDecideGroups
#@local    ContractingGroupsDefs, NoncontractingGroupsDefs, CantDecideGroupsDefs
#@local    SelfSimilarGroupsDefs, SelfSimilarGroups

#
gap> ContractingGroupsDefs := [
>   [[1,1,()]],
>   "a=(1,a)(1,2)",
>   "a=(1,b)(1,2), b=(1,a)",
>   "a=(1,1)(1,2), b=(a,c), c=(a,d), d=(1,b)",
>   "a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)",
>   "a=(1,2)(3,4), b=(a,c,a,c),c=(b,1,1,b)",
>   "a=(b,b)(1,2), b=(c,b), c=(c,a)"
> ];;

#
gap> NoncontractingGroupsDefs := [
>   "a=(b,a)(1,2),b=(c,b)(),c=(c,a)",
>   "a=(c,b)(1,2),b=(c,b)(),c=(a,a)",
> ];;

#
gap> CantDecideGroupsDefs := [
>   "a=(c,b), b=(b,c), c=(a,a)(1,2)",
>   "a=(c,b)(1,2), b=(b,c)(1,2), c=(a,a)",
> ];;

#
gap> SelfSimilarGroupsDefs := [
>   "x=(1,y)(1,2),y=(z^-1,1)(1,2),z=(1,x*y)",
> ];;

#
gap> ContractingGroups := List( ContractingGroupsDefs, AutomatonGroup );;
gap> NoncontractingGroups := List( NoncontractingGroupsDefs, AutomatonGroup );;
gap> CantDecideGroups := List( CantDecideGroupsDefs, AutomatonGroup );;
gap> SelfSimilarGroups := List( SelfSimilarGroupsDefs, SelfSimilarGroup);;

#
gap> ForAll(ContractingGroups, IsContracting);
true
gap> ForAll(NoncontractingGroups, l -> IsNoncontracting(l,10,10));
true

#
gap> Length(GroupNucleus(ContractingGroups[3]));
7
gap> Length(GroupNucleus(ContractingGroups[4]));
5
gap> Length(GroupNucleus(ContractingGroups[5]));
5
gap> Length(GroupNucleus(ContractingGroups[6]));
35
gap> Length(GroupNucleus(SelfSimilarGroups[1]));
7
gap> Length(GroupNucleus(ContractingGroups[7]));
8
gap> ContractingLevel(ContractingGroups[6]);
3
gap> ContractingLevel(ContractingGroups[7]);
4
