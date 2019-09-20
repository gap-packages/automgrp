#############################################################################
##
#W  convertersfr.gi         automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##

#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsSelfSimilarGroup]", [IsSelfSimilarGroup],
function(G)
  local fam,ngens;
  fam:=UnderlyingSelfSimFamily(G);
  ngens:=Length(fam!.names);
  return SCGroup(FRMachine(fam!.names, List(fam!.recurlist{[1..ngens]},x->x{[1..fam!.deg]}),
                                  List(fam!.recurlist{[1..ngens]},x->x[fam!.deg+1])));
end);


#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsSelfSimGroup]", [IsSelfSimGroup],
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
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsSelfSimilarSemigroup]", [IsSelfSimilarSemigroup],
function(G)
  local fam,ngens;
  fam:=UnderlyingSelfSimFamily(G);
  ngens:=Length(fam!.names);
  return SCSemigroup(FRMachine(fam!.names, List(fam!.recurlist{[1..ngens]},x->x{[1..fam!.deg]}),
                                  List(fam!.recurlist{[1..ngens]},x->x[fam!.deg+1])));
end);

#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsSelfSimSemigroup]", [IsSelfSimSemigroup],
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
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsAutomatonGroup]", [IsAutomatonGroup],
function(G)
  local recur_list, fam, names, d, i, s;
  fam := UnderlyingAutomFamily(G);
  names := fam!.names;
  d:=DegreeOfTree(fam);
  recur_list := StructuralCopy(fam!.automatonlist{[1..Length(names)]});

  # if identity is not one of the states
  if Length(fam!.automatonlist)=2*Length(names) then
    for s in recur_list do
      for i in [1..d] do s[i]:=[s[i]]; od;
    od;
  # if identity is one of the states, it should be the last one, so
  # when converting to the recurlist, we replace corresponding entries
  # with empty lists
  else
    for s in recur_list do
      for i in [1..d] do
        if s[i]<=Length(names) then
          s[i]:=[s[i]];
        else
          s[i]:=[];
        fi;
      od;
    od;
  fi;
  return AutomGrp2FR(SelfSimilarGroup(recur_list{[1..Length(names)]},names));
end);



#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsAutomGroup]", [IsAutomGroup],
function(G)
  local recur_list, fam, names, d, i, s, gens_letter_reps, M;
  fam := UnderlyingAutomFamily(G);
  names := fam!.names;
  d:=DegreeOfTree(fam);
  recur_list := StructuralCopy(fam!.automatonlist{[1..Length(names)]});

  # if identity is not one of the states
  if Length(fam!.automatonlist)=2*Length(names) then
    for s in recur_list do
      for i in [1..d] do s[i]:=[s[i]]; od;
    od;
  # if identity is one of the states, it should be the last one, so
  # when converting to the recurlist, we replace corresponding entries
  # with empty lists
  else
    for s in recur_list do
      for i in [1..d] do
        if s[i]<=Length(names) then
          s[i]:=[s[i]];
        else
          s[i]:=[];
        fi;
      od;
    od;
  fi;

  gens_letter_reps:=List(GeneratorsOfGroup(G),w->LetterRepAssocWord(w!.word));

  M:=FRMachine(fam!.names, List(recur_list,x->x{[1..fam!.deg]}),
                                  List(recur_list,x->x[fam!.deg+1]));

  return Group(List(gens_letter_reps,w->FRElement(M,w)));
end);



#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsAutomatonSemigroup]", [IsAutomatonSemigroup],
function(G)
  local recur_list, fam, names, d, i, s;
  fam := UnderlyingAutomFamily(G);
  names := fam!.names;
  d:=DegreeOfTree(fam);
  recur_list := StructuralCopy(fam!.automatonlist{[1..Length(names)]});

  # if identity is not one of the states
  if Length(fam!.automatonlist)=2*Length(names) then
    for s in recur_list do
      for i in [1..d] do s[i]:=[s[i]]; od;
    od;
  # if identity is one of the states, it should be the last one, so
  # when converting to the recurlist, we replace corresponding entries
  # with empty lists
  else
    for s in recur_list do
      for i in [1..d] do
        if s[i]<=Length(names) then
          s[i]:=[s[i]];
        else
          s[i]:=[];
        fi;
      od;
    od;
  fi;
  return AutomGrp2FR(SelfSimilarSemigroup(recur_list{[1..Length(names)]},names));
end);




#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsAutomSemigroup]", [IsAutomSemigroup],
function(G)
  local recur_list, fam, names, d, i, s, gens_letter_reps, M;
  fam := UnderlyingAutomFamily(G);
  names := fam!.names;
  d:=DegreeOfTree(fam);
  recur_list := StructuralCopy(fam!.automatonlist{[1..Length(names)]});

  # if identity is not one of the states
  if Length(fam!.automatonlist)=2*Length(names) then
    for s in recur_list do
      for i in [1..d] do s[i]:=[s[i]]; od;
    od;
  # if identity is one of the states, it should be the last one, so
  # when converting to the recurlist, we replace corresponding entries
  # with empty lists
  else
    for s in recur_list do
      for i in [1..d] do
        if s[i]<=Length(names) then
          s[i]:=[s[i]];
        else
          s[i]:=[];
        fi;
      od;
    od;
  fi;

  gens_letter_reps:=List(GeneratorsOfSemigroup(G),w->LetterRepAssocWord(w!.word));

  M:=FRMachine(fam!.names, List(recur_list,x->x{[1..fam!.deg]}),
                                  List(recur_list,x->x[fam!.deg+1]));

  return Semigroup(List(gens_letter_reps,w->FRElement(M,w)));
end);


#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsAutom or IsSelfSim]", [IsAutom],
function(a)
  local fam,G;
  fam:=FamilyObj(a);
  if fam!.isgroup then
    G:=AutomGrp2FR(Group(a));
  else
    G:=AutomGrp2FR(Semigroup(a));
  fi;
  return G.1;
end);


#############################################################################
##
#M  AutomGrp2FR (<G>)
##
InstallMethod(AutomGrp2FR, "for [IsAutom or IsSelfSim]", [IsSelfSim],
function(a)
  local fam,G;
  fam:=FamilyObj(a);
  if fam!.isgroup then
    G:=AutomGrp2FR(Group(a));
  else
    G:=AutomGrp2FR(Semigroup(a));
  fi;
  return G.1;
end);



#############################################################################
##
#M  FR2AutomGrp (<G>)
##
InstallMethod(FR2AutomGrp, "for [IsFRGroup and HasUnderlyingFRMachine]", [IsFRGroup and HasUnderlyingFRMachine],
function(G)
  local M, names, recurlist, i;
  M := UnderlyingFRMachine(G);
  names := List(GeneratorsOfGroup(M!.free),x->String(x));
  recurlist := List(M!.transitions,x->List(x,w->LetterRepAssocWord(w)));
  for i in [1..Length(recurlist)] do
    Add(recurlist[i],PermList(M!.output[i]));
  od;
  return SelfSimilarGroup(recurlist,names,false);
end);


#############################################################################
##
#M  FR2AutomGrp (<G>)
##
InstallMethod(FR2AutomGrp, "for [IsFRGroup]", [IsFRGroup],
function(G)
  local UG;
  UG := FR2AutomGrp(SCGroup(UnderlyingFRMachine(Representative(G))));
  return Group(List(GeneratorsOfGroup(G),x->SelfSim(AssocWordByLetterRep(FamilyObj(One(UnderlyingFreeGroup(UG))),
                                                    LetterRepAssocWord(InitialState(x))), UnderlyingSelfSimFamily(UG))));
end);


#############################################################################
##
#M  FR2AutomGrp (<G>)
##
InstallMethod(FR2AutomGrp, "for [IsFRSemigroup and HasUnderlyingFRMachine]", [IsFRSemigroup and HasUnderlyingFRMachine],
function(G)
  local M, names, recurlist, i;
  M := UnderlyingFRMachine(G);
  names := List(GeneratorsOfSemigroup(M!.free),x->String(x));
  recurlist := List(M!.transitions,x->List(x,w->LetterRepAssocWord(w)));
  for i in [1..Length(recurlist)] do
    Add(recurlist[i],Transformation(M!.output[i]));
  od;
  return SelfSimilarSemigroup(recurlist,names,false);
end);


#############################################################################
##
#M  FR2AutomGrp (<G>)
InstallMethod(FR2AutomGrp, "for [IsFRSemigroup]", [IsFRSemigroup],
function(G)
  local UG;
  UG := FR2AutomGrp(SCSemigroup(UnderlyingFRMachine(Representative(G))));
  return Semigroup(List(GeneratorsOfSemigroup(G),x->SelfSim(AssocWordByLetterRep(FamilyObj(One(UnderlyingFreeGroup(UG))),
                                                           LetterRepAssocWord(InitialState(x))), UnderlyingSelfSimFamily(UG))));
end);


#############################################################################
##
#M  FR2AutomGrp (<G>)
##
InstallMethod(FR2AutomGrp, "for [IsFRMonoid and HasUnderlyingFRMachine]", [IsFRMonoid and HasUnderlyingFRMachine],
function(G)
  local M, names, recurlist, i;
  M := UnderlyingFRMachine(G);
  names := List(GeneratorsOfMonoid(M!.free),x->String(x));
  recurlist := List(M!.transitions,x->List(x,w->LetterRepAssocWord(w)));
  for i in [1..Length(recurlist)] do
    Add(recurlist[i],Transformation(M!.output[i]));
  od;
  return Monoid(GeneratorsOfSemigroup(SelfSimilarSemigroup(recurlist,names,false)));
end);

#############################################################################
##
#M  FR2AutomGrp (<G>)
InstallMethod(FR2AutomGrp, "for [IsFRMonoid]", [IsFRMonoid],
function(G)
  local UG;
  UG := FR2AutomGrp(SCSemigroup(UnderlyingFRMachine(Representative(G))));
  return Monoid(List(GeneratorsOfMonoid(G),x->SelfSim(AssocWordByLetterRep(FamilyObj(One(UnderlyingFreeGroup(UG))),
                                                           LetterRepAssocWord(InitialState(x))), UnderlyingSelfSimFamily(UG))));
end);


#############################################################################
##
#M  FR2AutomGrp (<G>)
##
InstallMethod(FR2AutomGrp, "for [IsFRElement]", [IsFRElement],
function(a)
  local G, M;
  M:=UnderlyingFRMachine(a);
  # Group case
  if ForAll(M!.output,l->Set(l)=[1..Length(l)]) then
    G:=FR2AutomGrp(SCGroup(M));
  # Semigroup case
  else
    G:=FR2AutomGrp(SCSemigroup(M));
  fi;
  return SelfSim(AssocWordByLetterRep(FamilyObj(One(UnderlyingFreeGroup(G))),
                 LetterRepAssocWord(InitialState(a))), UnderlyingSelfSimFamily(G));
end);

#E
