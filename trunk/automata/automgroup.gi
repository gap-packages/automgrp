#############################################################################
##
#W  automgroup.gi             automata package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##

Revision.automgroup_gi :=
  "@(#)$Id$";


###############################################################################
##
#M  AutomGroup(<list>)
##
InstallMethod(AutomGroup, "AutomGroup(IsList)", [IsList],
function (list)
  local fam, g;

  if not IsCorrectAutomatonList(list) then
    Print("error in AutomGroup(IsList):\n");
    Print("  given list is not a correct list representing automaton\n");
    return fail;
  fi;

  fam := AutomFamily(list);
  if fam = fail then return fail; fi;
  return GroupOfAutomFamily(fam);
end);


###############################################################################
##
#M  AutomGroupNoBindGlobal(<list>)
##
InstallMethod(AutomGroupNoBindGlobal, "AutomGroupNoBindGlobal(IsList)", [IsList],
function (list)
  local fam, g;

  if not IsCorrectAutomatonList(list) then
    Print("error in AutomGroupNoBindGlobal(IsList):\n");
    Print("  given list is not a correct list representing automaton\n");
    return fail;
  fi;

  fam := AutomFamilyNoBindGlobal(list);
  if fam = fail then return fail; fi;
  return GroupOfAutomFamily(fam);
end);


###############################################################################
##
#M  AutomGroup(<list>, <names>)
##
InstallOtherMethod(AutomGroup, "AutomGroup(IsList, IsList)", [IsList, IsList],
function (list, names)
  local fam, g;

  if not IsCorrectAutomatonList(list) then
    Print("error in AutomGroup(IsList):\n");
    Print("  given list is not a correct list representing automaton\n");
    return fail;
  fi;

  fam := AutomFamily(list, names);
  if fam = fail then return fail; fi;
  return GroupOfAutomFamily(fam);
end);


###############################################################################
##
#M  AutomGroupNoBindGlobal(<list>, <names>)
##
InstallOtherMethod(AutomGroupNoBindGlobal,
                   "AutomGroupNoBindGlobal(IsList, IsList)", [IsList, IsList],
function (list, names)
  local fam, g;

  if not IsCorrectAutomatonList(list) then
    Print("error in AutomGroup(IsList):\n");
    Print("  given list is not a correct list representing automaton\n");
    return fail;
  fi;

  fam := AutomFamily(list, names, false);
  if fam = fail then return fail; fi;
  return GroupOfAutomFamily(fam);
end);


###############################################################################
##
#M  UnderlyingAutomFamily(<G>)
##
InstallMethod(UnderlyingAutomFamily, "UnderlyingAutomFamily(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  return FamilyObj(GeneratorsOfGroup(G)[1]);
end);


###############################################################################
##
#M  GroupOfAutomFamily(<fam>)
##
InstallMethod(GroupOfAutomFamily, "GroupOfAutomFamily(IsAutomFamily)",
              [IsAutomFamily],
function(fam)
  local g;
  g := GroupWithGenerators(fam!.automgens{[1..fam!.numstates]});
  SetUnderlyingAutomFamily(g, fam);
  SetIsGroupOfAutomFamily(g, true);
  SetGeneratingAutomatonList(g, fam!.automatonlist);
  SetAutomatonList(g, fam!.automatonlist);
  SetAutomatonListInitialStatesGenerators(g, [1..fam!.numstates]);
  SetDegreeOfTree(g, fam!.deg);
  SetIsActingOnBinaryTree(g, fam!.deg = 2);
  return g;
end);


###############################################################################
##
#M  GroupOfAutomFamily(<G>)
##
InstallOtherMethod(GroupOfAutomFamily, "GroupOfAutomFamily(IsAutomGroup)",
                   [IsAutomGroup],
function(G)
  return GroupOfAutomFamily(UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  IsGroupOfAutomFamily(<G>)
##
InstallMethod(IsGroupOfAutomFamily, "IsGroupOfAutomFamily(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  return G = GroupOfAutomFamily(G);
end);


###############################################################################
##
#M  UseSubsetRelation(<G>)
##
InstallMethod(UseSubsetRelation,
              "UseSubsetRelation(IsAutomGroup, IsAutomGroup)",
              [IsAutomGroup, IsAutomGroup],
function(super, sub)
  ## the full group is self similar, so if <super> is smaller than the full
  ##  group then sub is smaller either
  if HasIsGroupOfAutomFamily(super) then
    if not IsGroupOfAutomFamily(super) then
      SetIsGroupOfAutomFamily(sub, false); fi; fi;
InstallTrueMethod(IsFractal, IsFractalByWords);
  TryNextMethod();
end);


###############################################################################
##
#M  DegreeOfTree(<G>)
##
InstallMethod(DegreeOfTree, "DegreeOfTree(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  return DegreeOfTree(UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, "PrintObj(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  local i, gens;
  gens := GeneratorsOfGroup(G);
  if gens = [] then Print("< >"); fi;
  if Length(gens) = 1 then
    Print("< ", gens[1], " >\n");
  else
    Print("< ", gens[1], ", \n");
    for i in [2..Length(gens)-1] do
      Print("  ", gens[i], ", \n");
    od;
    Print("  ", gens[Length(gens)], " >\n");
  fi;
end);


###############################################################################
##
#M  ViewObj(<G>)
##
InstallMethod(ViewObj, "ViewObj(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  local i, gens;
  gens := List(GeneratorsOfGroup(G), g -> Word(g));
  if gens = [] then Print("< >"); fi;
  Print("< ");
  for i in [1..Length(gens)-1] do
    if IsOne(gens[i]) then
      Print(AutomataParameters.identity_symbol, ", ");
    else
      Print(gens[i], ", ");
    fi;
  od;
  if IsOne(gens[Length(gens)]) then
    Print(AutomataParameters.identity_symbol, " >");
  else
    Print(gens[Length(gens)], " >");
  fi;
end);


###############################################################################
##
#M  MihaylovSystem(G)
##
## TODO
InstallMethod(MihaylovSystem, "MihaylovSystem(IsAutomGroup)", [IsAutomGroup],
function (G)
  local gens, mih, mih_gens, i;

  if not IsActingOnBinaryTree(G) then
    Error("MihaylovSystem(IsAutomGroup):\n  sorry, group is not acting on binary tree\n");
  fi;
  if not IsFractalByWords(G) then
    Info(InfoAutomata, 1, "given group is not IsFractalByWords");
    return fail;
  fi;

  gens := GeneratorsOfGroup(StabilizerOfFirstLevel(G));
  mih := ComputeMihaylovSystemPairs(List(gens, a -> StatesWords(a)));
  if not mih[3] then return gens; fi;

  mih_gens := [];
  for i in [1..Length(gens)] do
    mih_gens[i] := CalculateWord(mih[2][i], gens);
  od;
  return mih_gens;
end);


###############################################################################
##
#M  IsFractalByWords(G)
##
InstallMethod(IsFractalByWords, "IsFractalByWords(IsAutomGroup)",
              [IsAutomGroup],
function (G)
  local freegens, stab, i, sym, f;

  sym := GroupWithGenerators(List(GeneratorsOfGroup(G), g -> Perm(g)));
  if not IsTransitive(sym, [1..DegreeOfTree(G)]) then
    Info(InfoAutomata, 1, "group is not transitive on first level");
    return false;
  fi;

  f := GroupWithGenerators(List(GeneratorsOfGroup(G), g -> Word(g)));
  stab := StabilizerOfFirstLevel(G);
  stab := List(GeneratorsOfGroup(stab), a -> StatesWords(a));

  for i in [1..DegreeOfTree(G)] do
    if f <> GroupWithGenerators(List(stab, s -> s[i])) then
      return false;
    fi;
  od;
  return true;
end);


###############################################################################
##
#M  Size(G)
##
InstallMethod(Size, "Size(IsAutomGroup)", [IsAutomGroup],
function (G)
  if IsTrivial(G) then
    Info(InfoAutomata, 3, "Size(G): 1");
    Info(InfoAutomata, 3, "  G is trivial");
    return 1;
  fi;

  if CanEasilyTestSphericalTransitivity(G) and IsSphericallyTransitive(G) then
    Info(InfoAutomata, 3, "Size(G): infinity");
    Info(InfoAutomata, 3, "  G is spherically transitive");
    return infinity;
  fi;

  if IsFractalByWords(G) then
    Info(InfoAutomata, 3, "Size(G): infinity");
    Info(InfoAutomata, 3, "  G is fractal by words");
    return infinity;
  fi;

  if CanEasilyTestFractalness(G) and IsFractal(G) then
    Info(InfoAutomata, 3, "Size(G): infinity");
    Info(InfoAutomata, 3, "  G is fractal");
    return infinity;
  fi;

  if CanEasilyTestBeingFreeNonabelian(G) and IsFreeNonabelian(G) then
    Info(InfoAutomata, 3, "Size(G): infinity");
    Info(InfoAutomata, 3, "  G is free nonabelian");
    return infinity;
  fi;

  if CanEasilyTestBeingFreeAbelian(G) and IsFreeAbelian(G) then
    Info(InfoAutomata, 3, "Size(G): infinity");
    Info(InfoAutomata, 3, "  G is free abelian");
    return infinity;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsSphericallyTransitive(G)
##
InstallMethod(IsSphericallyTransitive, "IsSphericallyTransitive(IsAutomGroup)",
              [IsAutomGroup],
function (G)
  local x, rat_gens, abel_hom;

  if IsTrivial(G) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is trivial: G = ", G);
    return false;
  fi;

  if CanEasilyComputeSize(G) and Size(G) < infinity then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  Size(G) < infinity: G = ", G);
    return false;
  fi;

  if HasIsFinite(G) and IsFinite(G) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  IsFinite(G): G = ", G);
    return false;
  fi;

  TryNextMethod();
end);


InstallMethod(IsSphericallyTransitive,
              "method for wreath product of AutomGroup and Symmetric group",
              [IsTreeAutomorphismGroup], 10,
function (G)
  if not IsAutomGroup(G) and IsAutom(State(GeneratorsOfGroup(G)[1], 1)) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): checking");
    Info(InfoAutomata, 3, "IsTransitiveOnLevel(G, 1) and IsSphericallyTransitive(ProjStab(G, 1))");
    return IsTransitiveOnLevel(G, 1) and IsSphericallyTransitive(ProjStab(G, 1));
  fi;
  TryNextMethod();
end);


###############################################################################
##
#M  DiagonalAction(<G>, <n>)
##
InstallOtherMethod( DiagonalAction,
                    "DiagonalAction(IsAutomGroup and IsGroupOfAutomFamily, IsPosInt)",
                    [IsAutomGroup and IsGroupOfAutomFamily, IsPosInt],
function(G, n)
  return DiagonalAction(UnderlyingAutomFamily(G), n);
end);


###############################################################################
##
#M  MultAutomAlphabet(<G>, <n>)
##
InstallOtherMethod( MultAutomAlphabet,
                    "MultAutomAlphabet(IsAutomGroup and IsGroupOfAutomFamily, IsPosInt)",
                    [IsAutomGroup and IsGroupOfAutomFamily, IsPosInt],
function(G, n)
  return MultAutomAlphabet(UnderlyingAutomFamily(G), n);
end);


###############################################################################
##
#M  \= (<G>, <H>)
##
InstallMethod(\=, "\=(IsAutomGroup, IsAutomGroup)",
              IsIdenticalObj, [IsAutomGroup, IsAutomGroup],
function(G, H)
  local fgens1, fgens2;

  if HasIsGroupOfAutomFamily(G) and HasIsGroupOfAutomFamily(H)
    and IsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
      Info(InfoAutomata, 3, "G = H: true");
      Info(InfoAutomata, 3, "  both are GroupOfAutomFamily");
      return true;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
  if GroupWithGenerators(fgens1) = GroupWithGenerators(fgens2) then
    Info(InfoAutomata, 3, "G = H: true");
    Info(InfoAutomata, 3, "  by subgroups of free group");
    return true;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsSubset (<G>, <H>)
##
InstallMethod(IsSubset, "IsSubset(IsAutomGroup, IsAutomGroup)",
              IsIdenticalObj, [IsAutomGroup, IsAutomGroup],
function(G, H)
  local h, gens1, gens2, fgens1, fgens2;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    Info(InfoAutomata, 3, "IsSubgroup(G, H): true");
    Info(InfoAutomata, 3, "  G is GroupOfAutomFamily");
    return true;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  gens2 := GeneratorsOfGroup(H);
  fgens2 := List(gens2, g -> Word(g));
  if IsSubgroup(GroupWithGenerators(fgens1), GroupWithGenerators(fgens2)) then
    Info(InfoAutomata, 3, "IsSubgroup(G, H): true");
    Info(InfoAutomata, 3, "  by subgroups of free group");
    return true;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  <g> in <G>)
##
InstallMethod(\in, "\in(IsAutom, IsAutomGroup)",
              [IsAutom, IsAutomGroup],
function(g, G)
  local fgens, w;

  fgens := List(GeneratorsOfGroup(G), g -> Word(g));
  if Word(g) in GroupWithGenerators(fgens) then
    Info(InfoAutomata, 3, "g in G: true");
    Info(InfoAutomata, 3, "  by elements of free group");
    Info(InfoAutomata, 3, "  g = ", g, "; G = ", G);
    return true;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  Random(<G>)
##
InstallMethod(Random, "Random(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  return Autom(Random(UnderlyingAutomFamily(G)!.freegroup),
                UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  UnderlyingFreeGroup(<G>)
##
InstallMethod(UnderlyingFreeGroup, "UnderlyingFreeGroup(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  return UnderlyingAutomFamily(G)!.freegroup;
end);


###############################################################################
##
#M  UnderlyingFreeSubgroup(<G>)
##
InstallMethod(UnderlyingFreeSubgroup, "UnderlyingFreeSubgroup(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  local f;
  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    return UnderlyingFreeGroup(G);
  fi;
  f := Subgroup(UnderlyingFreeGroup(G), UnderlyingFreeGenerators(G));
  if f = UnderlyingFreeGroup(G) then
    SetIsGroupOfAutomFamily(G, true);
  fi;
  return f;
end);


###############################################################################
##
#M  IndexInFreeGroup(<G>)
##
InstallMethod(IndexInFreeGroup, "IndexInFreeGroup(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  return IndexInWholeGroup(UnderlyingFreeSubgroup(G));
end);


###############################################################################
##
#M  UnderlyingFreeGenerators(<G>)
##
InstallMethod(UnderlyingFreeGenerators, "UnderlyingFreeGenerators(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  return List(GeneratorsOfGroup(G), g -> Word(g));
end);


###############################################################################
##
#M  ApplyNielsen(<G>)
##
InstallMethod(ApplyNielsen, "ApplyNielsen(IsAutomGroup)",
              [IsAutomGroup],
function(G)
  local fgens;
  fgens := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens := ReducedByNielsen(fgens);
  fgens := Difference(fgens, [One(fgens[1])]);
  if IsEmpty(fgens) then
    SetUnderlyingFreeGenerators(G, [One(UnderlyingFreeGroup(G))]);
    SetUnderlyingFreeSubgroup(G, TrivialSubgroup(UnderlyingFreeGroup(G)));
  else
    SetUnderlyingFreeGenerators(G, fgens);
    SetUnderlyingFreeSubgroup(G, Subgroup(UnderlyingFreeGroup(G), fgens));
  fi;
  return fgens;
end);


#E
