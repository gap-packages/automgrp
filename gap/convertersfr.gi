#############################################################################
##
#W  convertersfr.gi         automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.3
##
#Y  Copyright (C) 2003 - 2015 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#M  AutomGrpToFR (<G>)
##
InstallMethod(AutomGrpToFR, "for [IsAutomatonGroup]", [IsAutomatonGroup],
function(G)
  local fam;
  fam:=UnderlyingAutomFamily(G);
  return MealyMachine(fam!.names, [[2,1],[2,2]],[(1,2),()]);
end);


#############################################################################
##
#M  AutomGrpToFR (<G>)
##
InstallMethod(AutomGrpToFR, "for [IsSelfSimilarGroup]", [IsSelfSimilarGroup],
function(G)
  local fam,ngens;
  fam:=UnderlyingSelfSimFamily(G);
  ngens:=Length(fam!.names);
  return SCGroup(FRMachine(fam!.names, List(fam!.recurlist{[1..ngens]},x->x{[1..fam!.deg]}),
                                  List(fam!.recurlist{[1..ngens]},x->x[fam!.deg+1])));
end);


#############################################################################
##
#M  AutomGrpToFR (<G>)
##
InstallMethod(AutomGrpToFR, "for [IsSelfSimGroup]", [IsSelfSimGroup],
function(G)
  local fam,gens_letter_reps,ngens,M;
  gens_letter_reps:=List(GeneratorsOfGroup(G),w->LetterRepAssocWord(w!.word));
  fam:=UnderlyingSelfSimFamily(G);
  ngens:=Length(fam!.names);
  M:=FRMachine(fam!.names, List(fam!.recurlist{[1..ngens]},x->x{[1..fam!.deg]}),
                                  List(fam!.recurlist{[1..ngens]},x->x[fam!.deg+1]));
  return Group(List(gens_letter_reps,w->FRElement(M,w)));
end);


#############################################################################
##
#M  AutomGrpToFR (<G>)
##
InstallMethod(AutomGrpToFR, "for [IsSelfSimilarSemigroup]", [IsSelfSimilarSemigroup],
function(G)
  local fam,ngens;
  fam:=UnderlyingSelfSimFamily(G);
  ngens:=Length(fam!.names);
  return SCSemigroup(FRMachine(fam!.names, List(fam!.recurlist{[1..ngens]},x->x{[1..fam!.deg]}),
                                  List(fam!.recurlist{[1..ngens]},x->x[fam!.deg+1])));
end);

#############################################################################
##
#M  AutomGrpToFR (<G>)
##
InstallMethod(AutomGrpToFR, "for [IsSelfSimSemigroup]", [IsSelfSimSemigroup],
function(G)
  local fam,gens_letter_reps,ngens,M;
  gens_letter_reps:=List(GeneratorsOfSemigroup(G),w->LetterRepAssocWord(w!.word));
  fam:=UnderlyingSelfSimFamily(G);
  ngens:=Length(fam!.names);
  M:=FRMachine(fam!.names, List(fam!.recurlist{[1..ngens]},x->x{[1..fam!.deg]}),
                                  List(fam!.recurlist{[1..ngens]},x->x[fam!.deg+1]));
  return Semigroup(List(gens_letter_reps,w->FRElement(M,w)));
end);


#############################################################################
##
#M  FRToAutom (<G>)
##
InstallMethod(FRToAutomGrp, "for [IsFRGroup]", [IsFRGroup],
function(G)
  local M, names, recurlist, i;
  M := UnderlyingFRMachine(G);
  names := List(GeneratorsOfGroup(M!.free),x->String(x));
  recurlist := List(M!.transitions,x->List(x,w->LetterRepAssocWord(w)));
  for i in [1..Length(recurlist)] do
    Add(recurlist[i],PermList(M!.output[i]));
  od;
  return SelfSimilarGroup(recurlist,names);
end);


#############################################################################
##
#M  FRToAutomGrp (<G>)
##
InstallMethod(FRToAutomGrp, "for [IsFRSemigroup]", [IsFRSemigroup],
function(G)
  local M, names, recurlist, i;
  M := UnderlyingFRMachine(G);
  names := List(GeneratorsOfMonoid(M!.free),x->String(x));
  recurlist := List(M!.transitions,x->List(x,w->LetterRepAssocWord(w)));
  for i in [1..Length(recurlist)] do
    Add(recurlist[i],Transformation(M!.output[i]));
  od;
  return SelfSimilarSemigroup(recurlist,names);
end);


#FRMachineFRGroup

#E
