#############################################################################
##
#W  automgroup.gi             automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  AutomatonGroup(<list>)
##
InstallMethod(AutomatonGroup, "for [IsList]", [IsList],
function(list)
  return AutomatonGroup(list, false);
end);


###############################################################################
##
#M  AutomatonGroup(<list>, <bind_vars>)
##
InstallMethod(AutomatonGroup, "for [IsList, IsBool]", [IsList, IsBool],
function(list, bind_vars)
  if not AG_IsCorrectAutomatonList(list, true) then
    Error("in AutomatonGroup(IsList, IsBool):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  return GroupOfAutomFamily(AutomFamily(list, bind_vars));
end);


###############################################################################
##
#M  AutomatonGroup(<list>, <names>)
##
InstallMethod(AutomatonGroup, "for [IsList, IsList]", [IsList, IsList],
function(list, names)
  return AutomatonGroup(list, names, AG_Globals.bind_vars_autom_family);
end);


###############################################################################
##
#M  AutomatonGroup(<list>, <names>, <bind_vars>)
##
InstallMethod(AutomatonGroup,
              "for [IsList, IsList, IsBool]", [IsList, IsList, IsBool],
function(list, names, bind_vars)
  if not AG_IsCorrectAutomatonList(list, true) then
    Error("error in AutomatonGroup(IsList, IsList, IsBool):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  return GroupOfAutomFamily(AutomFamily(list, names, bind_vars));
end);


###############################################################################
##
#M  AutomatonGroup(<string>)
#M  AutomatonGroup(<string>, <bind_vars>)
##
InstallMethod(AutomatonGroup, "for [IsString]", [IsString],
function(string)
  return AutomatonGroup(string, AG_Globals.bind_vars_autom_family);
end);

InstallMethod(AutomatonGroup, "for [IsString, IsBool]", [IsString, IsBool],
function(string, bind_vars)
  local s;
  s := AG_ParseAutomatonString(string);
  return AutomatonGroup(s[2], s[1], bind_vars);
end);


InstallMethod(AutomatonGroup, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  if not IsInvertible(A) then
    Error("Automaton <A> is not invertible");
  fi;
  return AutomatonGroup(AutomatonList(A), A!.states);
end);

InstallMethod(AutomatonGroup, "for [IsMealyAutomaton, IsBool]", [IsMealyAutomaton, IsBool],
function(A, bind_vars)
  if not IsInvertible(A) then
    Error("Automaton <A> is not invertible");
  fi;
  return AutomatonGroup(AutomatonList(A), A!.states, bind_vars);
end);


###############################################################################
##
#M  GroupOfAutomFamily(<G>)
##
InstallMethod(GroupOfAutomFamily, "for [IsAutomGroup]",
                   [IsAutomGroup],
function(G)
  return GroupOfAutomFamily(UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  IsGroupOfAutomFamily(<G>)
##
InstallMethod(IsGroupOfAutomFamily, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  return G = GroupOfAutomFamily(G);
end);


###############################################################################
##
#M  UseSubsetRelation(<G>)
##
InstallMethod(UseSubsetRelation,
              "for [IsAutomGroup, IsAutomGroup]",
              [IsAutomGroup, IsAutomGroup],
function(super, sub)
  ## the full group is self similar, so if <super> is smaller than the full
  ##  group then sub is smaller either
  if HasIsGroupOfAutomFamily(super) then
    if not IsGroupOfAutomFamily(super) then
      SetIsGroupOfAutomFamily(sub, false); fi; fi;
  TryNextMethod();
end);


###############################################################################
##
#M  __AG_SubgroupOnLevel(<G>, <gens>, <level>)
##
InstallMethod(__AG_SubgroupOnLevel, [IsAutomGroup,
                                    IsList and IsTreeAutomorphismCollection,
                                    IsPosInt],
function(G, gens, level)
  local overgroup;

  if IsEmpty(gens) or (Length(gens) = 1 and IsOne(gens[1])) then
    return TrivialSubgroup(G);
  fi;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    overgroup := G;
  else
    overgroup := GroupOfAutomFamily(UnderlyingAutomFamily(G));
  fi;

  return SubgroupNC(overgroup, gens);
end);

InstallOtherMethod(__AG_SubgroupOnLevel, [IsAutomGroup, IsList and IsEmpty, IsPosInt],
function(G, gens, level)
  return TrivialSubgroup(G);
end);

InstallMethod(__AG_SubgroupOnLevel, [IsTreeAutomorphismGroup,
                                    IsList and IsInvertibleAutomCollection,
                                    IsPosInt],
function(G, gens, level)
  local overgroup;

  overgroup := GroupOfAutomFamily(FamilyObj(gens[1]));

  if Length(gens) = 1 and IsOne(gens[1]) then
    return TrivialSubgroup(overgroup);
  fi;

  return SubgroupNC(overgroup, gens);
end);

InstallMethod(__AG_SimplifyGroupGenerators, [IsList and IsInvertibleAutomCollection],
function(gens)
  local words, fam;

  if IsEmpty(gens) then
    return [];
  fi;

  fam := FamilyObj(gens[1]);
  words := FreeGeneratorsOfGroup(Group(List(gens, a -> a!.word)));

  if fam!.use_rws and not IsEmpty(words) then
    words := AG_ReducedForm(fam!.rws, words);
    if not IsEmpty(words) then
      words := FreeGeneratorsOfGroup(Group(words));
    fi;
  fi;

  if IsEmpty(words) then
    return [];
  fi;

  return List(words, w -> Autom(w, fam));
end);

###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, "for [IsAutomatonGroup]",
              [IsAutomatonGroup],
function(G)
  Print("AutomatonGroup(\"", String(G), "\")");
end);


###############################################################################
##
#M  Display(<G>)
##
InstallMethod(Display, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  local i, gens, printone;

  printone := function(a)
    Print(a, " = ", Decompose(a));
  end;

  gens := GeneratorsOfGroup(G);
  if gens = [] then Print("< >"); fi;
  if Length(gens) = 1 then
    Print("< "); printone(gens[1]); Print(" >");
  else
    Print("< "); printone(gens[1]); Print(", \n");
    for i in [2..Length(gens)-1] do
      Print("  "); printone(gens[i]); Print(", \n");
    od;
    Print("  "); printone(gens[Length(gens)]); Print(" >");
  fi;
end);


#############################################################################
##
#M  String(<G>)
##
InstallMethod(String, "for [IsAutomGroup]", [IsAutomGroup],
function(G)
  local i, gens, formatone, s;

  formatone := function(a)
    return Concatenation(String(a), " = ", String(Decompose(a)));
  end;

  gens := GeneratorsOfGroup(G);

  s := "";
  for i in [1..Length(gens)] do
    Append(s, formatone(gens[i]));
    if i <> Length(gens) then
      Append(s, ", ");
    fi;
  od;

  return s;
end);

###############################################################################
##
#M  ViewObj(<G>)
##
InstallMethod(ViewObj, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  local i, gens;
  gens := List(GeneratorsOfGroup(G), g -> Word(g));
  if gens = [] then Print("< >"); fi;
  Print("< ");
  for i in [1..Length(gens)-1] do
    if IsOne(gens[i]) then
      Print(AG_Globals.identity_symbol, ", ");
    else
      Print(gens[i], ", ");
    fi;
  od;
  if IsOne(gens[Length(gens)]) then
    Print(AG_Globals.identity_symbol, " >");
  else
    Print(gens[Length(gens)], " >");
  fi;
end);


###############################################################################
##
#M  MihailovaSystem(G)
##
##  TODO XXX test it
##
InstallMethod(MihailovaSystem, "for [IsAutomatonGroup]", [IsAutomatonGroup],
function (G)
  local gens, mih, mih_gens, i;

  if not IsActingOnBinaryTree(G) then
    Error("MihailovaSystem(IsAutomGroup):\n  sorry, group is not acting on binary tree\n");
  fi;
  if not IsFractalByWords(G) then
    Info(InfoAutomGrp, 1, "given group is not IsFractalByWords");
    return fail;
  fi;

  gens := GeneratorsOfGroup(StabilizerOfFirstLevel(G));
  mih := AG_ComputeMihailovaSystemPairs(List(gens, a -> StatesWords(a)));

  if mih = fail then
    return fail;
  elif not mih[3] then
    return gens;
  fi;

  mih_gens := [];
  for i in [1..Length(gens)] do
    mih_gens[i] := AG_CalculateWord(mih[2][i], gens);
  od;
  return mih_gens;
end);


###############################################################################
##
#M  IsFractalByWords(G)
##
InstallMethod(IsFractalByWords, "for [IsAutomGroup]",
              [IsAutomGroup],
function (G)
  local freegens, stab, i, sym, f;

  sym := GroupWithGenerators(List(GeneratorsOfGroup(G), g -> Perm(g)));
  if not IsTransitive(sym, [1..DegreeOfTree(G)]) then
    Info(InfoAutomGrp, 1, "group is not transitive on first level");
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
InstallMethod(Size, "for [IsAutomGroup]", [IsAutomGroup],
function (G)
  local f, A, lev;
  if IsTrivial(G) then
    Info(InfoAutomGrp, 3, "Size(G): 1, G is trivial");
    return 1;
  fi;

  if CanEasilyTestSphericalTransitivity(G) and IsSphericallyTransitive(G) then
    Info(InfoAutomGrp, 3, "Size(G): infinity, G is spherically transitive");
    return infinity;
  fi;

  if IsFractalByWords(G) then
    Info(InfoAutomGrp, 3, "Size(G): infinity, G is fractal by words");
    return infinity;
  fi;

  if HasIsFractal(G) and IsFractal(G) then
    Info(InfoAutomGrp, 3, "Size(G): infinity, G is fractal");
    return infinity;
  fi;


  if IsAutomatonGroup(G) then
    A:=MealyAutomaton(AutomatonList(G));
    if IsMDTrivial(A) then
      Info(InfoAutomGrp, 3, "Size(G): automaton generating G is MD-trivial");
      lev:=LevelOfFaithfulAction(G,infinity);
      return Size(G);
    elif (DegreeOfTree(G)=2 or NumberOfStates(A)=2) and IsIRAutomaton(A) then
      Info(InfoAutomGrp, 3, "Size(G): infinity, G is generated by 2-letter or 2-state not MD-trivial IR-automaton ");
      return infinity;
    fi;
  fi;

  if IsAutomatonGroup(G) and LevelOfFaithfulAction(G,8)<>fail then
    return Size(G);
  fi;

  f := FindElementOfInfiniteOrder(G,10,10);

  if HasSize(G) or f <> fail then
    return Size(G);
  fi;

  Info(InfoAutomGrp, 1, "You can try to use IsomorphismPermGroup(<G>) or\n",
                        "   FindElementOfInfiniteOrder(<G>,<length>,<depth>) with bigger bounds");
  TryNextMethod();
end);


InstallOtherMethod(LevelOfFaithfulAction, "for [IsAutomGroup and IsSelfSimilar]",
              [IsAutomGroup and IsSelfSimilar,IsCyclotomic],
function(G,max_lev)
  local s,s_next,lev;
  if HasIsFinite(G) and not IsFinite(G) then return fail; fi;
  if HasLevelOfFaithfulAction(G) then return LevelOfFaithfulAction(G); fi;
  lev := 0; s := 1; s_next := Size(PermGroupOnLevel(G,1));
  while s<s_next and lev<max_lev do
    lev := lev+1;
    s := s_next;
    s_next := Size(PermGroupOnLevel(G,lev+1));
  od;
  if s = s_next then
    SetSize(G,s);
    SetLevelOfFaithfulAction(G,lev);
    return lev;
  else
    return fail;
  fi;
end);


InstallMethod(LevelOfFaithfulAction, "for [IsAutomGroup and IsSelfSimilar]",
              [IsAutomGroup and IsSelfSimilar],
function(G)
  return LevelOfFaithfulAction(G,infinity);
end);


InstallOtherMethod(IsomorphismPermGroup, "for [IsAutomGroup and IsSelfSimilar,IsCyclotomic]",
                   [IsAutomGroup and IsSelfSimilar, IsCyclotomic],
function (G, n)
  local H, lev;
  lev := LevelOfFaithfulAction(G, n);
  if lev <> fail then
    H := PermGroupOnLevel(G,LevelOfFaithfulAction(G));
    return AG_GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
  fi;
  return fail;
end);



InstallMethod(IsomorphismPermGroup, "for [IsAutomGroup]",
              [IsAutomGroup], SUM_FLAGS,
function (G)
  local H;
  H := AG_FiniteGroupId(G);
  return AG_GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
end);



BindGlobal("TestSelfSimilarity",
function(G)
  if CanEasilyTestSelfSimilarity(G) then
    IsSelfSimilar(G);
    return true;
  fi;

  if IsTrivial(G) then
    SetIsSelfSimilar(G, true);
    return true;
  fi;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    SetIsSelfSimilar(G, true);
    return true;
  fi;

  if Set(GeneratorsOfGroup(G)) = Set(GeneratorsOfGroup(GroupOfAutomFamily(UnderlyingAutomFamily(G)))) then
    SetIsSelfSimilar(G, true);
    return true;
  fi;

  return false;
end);


###############################################################################
##
#M  IsSphericallyTransitive(G)
##
InstallMethod(IsSphericallyTransitive, "for [IsAutomGroup]",
              [IsAutomGroup],
function (G)
  local x, rat_gens, abel_hom, lev;

  if DegreeOfTree(G)=1 then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
    Info(InfoAutomGrp, 3, "  G acts on 1-ary tree");
    return true;
  fi;


  if IsFractalByWords(G) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
    Info(InfoAutomGrp, 3, "  G is fractal");
    return true;
  fi;

  if IsTrivial(G) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G is trivial: G = ", G);
    return false;
  fi;

  if HasIsFinite(G) and IsFinite(G) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  IsFinite(G): G = ", G);
    return false;
  fi;

  if DegreeOfTree(G) = 2 and TestSelfSimilarity(G) and IsSelfSimilar(G) then
    if HasIsFinite(G) and IsFinite(G) = false then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomGrp, 3, "  <G> is infinite self-similar acting on binary tree");
      return true;
    fi;
    if PermGroupOnLevel(G,2) = Group((1,4,2,3)) then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomGrp, 3, "  any element which acts transitively on the first level acts spherically transitively");
      return true;
    fi;
  fi;

  for lev in [1..8] do
    if not IsTransitiveOnLevel(G,lev) then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
      Info(InfoAutomGrp, 3, "  the group does not act transitively on level ", lev);
      return false;
    fi;
  od;

  TryNextMethod();
end);


###############################################################################
##
#M  DiagonalPower(<G>, <n>)
##
InstallOtherMethod( DiagonalPower,
                    "for [IsAutomGroup and IsGroupOfAutomFamily, IsPosInt]",
                    [IsAutomGroup and IsGroupOfAutomFamily, IsPosInt],
function(G, n)
  return DiagonalPower(UnderlyingAutomFamily(G), n);
end);


###############################################################################
##
#M  MultAutomAlphabet(<G>, <n>)
##
InstallOtherMethod( MultAutomAlphabet,
                    "for [IsAutomGroup and IsGroupOfAutomFamily, IsPosInt]",
                    [IsAutomGroup and IsGroupOfAutomFamily, IsPosInt],
function(G, n)
  return MultAutomAlphabet(UnderlyingAutomFamily(G), n);
end);


###############################################################################
##
#M  \= (<G>, <H>)
##
InstallMethod(\=, "for [IsAutomGroup, IsAutomGroup]",
              IsIdenticalObj, [IsAutomGroup, IsAutomGroup],
function(G, H)
  local fgens1, fgens2, fam;

  if HasIsGroupOfAutomFamily(G) and HasIsGroupOfAutomFamily(H) then
    if IsGroupOfAutomFamily(G) <> IsGroupOfAutomFamily(H) then
      Info(InfoAutomGrp, 3, "G = H: false, exactly one is GroupOfAutomFamily");
      return false;
    fi;
    if IsGroupOfAutomFamily(G) then
      Info(InfoAutomGrp, 3, "G = H: true, both are GroupOfAutomFamily");
      return true;
    fi;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
  fam := UnderlyingAutomFamily(G);

  if fam!.rws <> fail then
    fgens1 := AG_ReducedForm(fam!.rws, fgens1);
    fgens2 := AG_ReducedForm(fam!.rws, fgens2);
  fi;

  if IsEmpty(fgens1) then
    return ForAll(fgens2, IsOne);
  elif IsEmpty(fgens2) then
    return ForAll(fgens1, IsOne);
  fi;

  if GroupWithGenerators(fgens1) = GroupWithGenerators(fgens2) then
    Info(InfoAutomGrp, 3, "G = H: true, by subgroups of free group");
    return true;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsSubset (<G>, <H>)
##
InstallMethod(IsSubset, "for [IsAutomGroup, IsAutomGroup]",
              IsIdenticalObj, [IsAutomGroup, IsAutomGroup],
function(G, H)
  local h, fam, fgens1, fgens2;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    Info(InfoAutomGrp, 3, "IsSubgroup(G, H): true");
    Info(InfoAutomGrp, 3, "  G is GroupOfAutomFamily");
    return true;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
  fam := UnderlyingAutomFamily(G);

  if fam!.rws <> fail then
    fgens1 := AG_ReducedForm(fam!.rws, fgens1);
    fgens2 := AG_ReducedForm(fam!.rws, fgens2);
  fi;

  if IsSubgroup(GroupWithGenerators(fgens1), GroupWithGenerators(fgens2)) then
    Info(InfoAutomGrp, 3, "IsSubgroup(G, H): true");
    Info(InfoAutomGrp, 3, "  by subgroups of free group");
    return true;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  <g> in <G>
##
InstallMethod(\in, "for [IsAutom, IsAutomGroup]",
              [IsAutom, IsAutomGroup],
function(g, G)
  local fam, fgens, w;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    return true;
  fi;

  fgens := List(GeneratorsOfGroup(G), g -> Word(g));
  w := Word(g);

  fam := UnderlyingAutomFamily(G);

  if fam!.rws <> fail then
    fgens := AG_ReducedForm(fam!.rws, fgens);
    if IsEmpty(fgens) then
      return IsOne(g);
    fi;
    w := AG_ReducedForm(fam!.rws, w);
  fi;

  if w in GroupWithGenerators(fgens) then
    Info(InfoAutomGrp, 3, "g in G: true");
    Info(InfoAutomGrp, 3, "  by elements of free group");
    Info(InfoAutomGrp, 3, "  g = ", g, "; G = ", G);
    return true;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  Random(<G>)
##
InstallMethodWithRandomSource(Random, "for a random source and [IsAutomGroup]",
              [IsRandomSource, IsAutomGroup],
function(rs, G)
  local F, gens, pi;

  if IsTrivial(G) then
    return One(G);
  elif IsAutomatonGroup(G) then
    return Autom(Random(rs, UnderlyingFreeGroup(G)), UnderlyingAutomFamily(G));
  else
    gens := GeneratorsOfGroup(G);
    F := FreeGroup(Length(gens));
    pi := GroupHomomorphismByImagesNC(F, G,  GeneratorsOfGroup(F), gens);
    return Random(rs, F)^pi;
  fi;
end);


###############################################################################
##
#M  UnderlyingFreeSubgroup(<G>)
##
InstallMethod(UnderlyingFreeSubgroup, "for [IsAutomGroup]",
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
#M  UnderlyingFreeGenerators(<G>)
##
InstallMethod(UnderlyingFreeGenerators, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  return List(GeneratorsOfGroup(G), g -> Word(g));
end);


###############################################################################
##
#M  TrivialSubmagmaWithOne(<G>)
##
InstallMethod(TrivialSubmagmaWithOne, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  return Subgroup(G, [One(G)]);
end);


###############################################################################
##
#M  IsAutomatonGroup(<G>)
##
InstallImmediateMethod(IsAutomatonGroup, IsAutomGroup, 0,
function(G)
  local fam;
  fam := UnderlyingAutomFamily(G);
  return fam!.numstates = 0 or
         GeneratorsOfGroup(G) = fam!.automgens{[1..fam!.numstates]};
end);


###############################################################################
##
#M  AutomatonList(<G>)
##
InstallMethod(AutomatonList, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  if IsAutomatonGroup(G) then
    return AutomatonList(GroupOfAutomFamily(UnderlyingAutomFamily(G)));
  else
    Error("Group <G> is not necessarily generated by automaton,");
  fi;
end);


###############################################################################
##
#M  IsSelfSimilar(<G>)
##
InstallMethod(IsSelfSimilar, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  local g, i, res;
  res := true;
  for g in GeneratorsOfGroup(G) do
    for i in [1..UnderlyingAutomFamily(G)!.deg] do
      res := Section(g, i) in G;
      if res = fail then
        TryNextMethod();
      elif not res then
        return false;
      fi;
    od;
  od;
  return true;
end);


###############################################################################
##
#M  UnderlyingAutomFamily(<G>)
##
InstallMethod(UnderlyingAutomFamily, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  return FamilyObj(GeneratorsOfGroup(G)[1]);
end);


###############################################################################
##
#M  UnderlyingAutomaton(<G>)
##
InstallMethod(UnderlyingAutomaton, "for [IsAutomGroup]",
              [IsAutomGroup],
function(G)
  local fam;
  fam := UnderlyingAutomFamily(G);
  return MealyAutomaton(AG_AddInversesList(fam!.automatonlist){[1..fam!.numstates+1]});
end);


#E
