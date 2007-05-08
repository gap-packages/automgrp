#############################################################################
##
#W  automgroup.gi             automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  AutomGroup(<list>)
##
InstallMethod(AutomGroup, "AutomGroup(IsList)", [IsList],
function (list)
  local fam, g;

  if not IsCorrectAutomatonList(list, true) then
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

  if not IsCorrectAutomatonList(list, true) then
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
InstallMethod(AutomGroup, "AutomGroup(IsList, IsList)", [IsList, IsList],
function (list, names)
  local fam, g;

  if not IsCorrectAutomatonList(list, true) then
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
InstallMethod(AutomGroupNoBindGlobal,
              "AutomGroupNoBindGlobal(IsList, IsList)", [IsList, IsList],
function (list, names)
  local fam, g;

  if not IsCorrectAutomatonList(list, true) then
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
#M  AutomGroup(<string>)
#M  AutomGroupNoBindGlobal(<string>)
##
InstallMethod(AutomGroup, "AutomGroup(IsString)", [IsString],
function (string)
    local s;
    s := ParseAutomatonString(string);
    return AutomGroup(s[2], s[1]);
end);
InstallMethod(AutomGroupNoBindGlobal, "AutomGroupNoBindGlobal(IsString)", [IsString],
function (string)
    local s;
    s := ParseAutomatonString(string);
    return AutomGroupNoBindGlobal(s[2], s[1]);
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
#M  $SubgroupOnLevel(<G>, <gens>, <level>)
##
InstallMethod($SubgroupOnLevel, [IsAutomGroup,
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

InstallMethod($SubgroupOnLevel, [IsAutomGroup, IsList and IsEmpty, IsPosInt],
function(G, gens, level)
  return TrivialSubgroup(G);
end);

InstallMethod($SubgroupOnLevel, [IsTreeAutomorphismGroup,
                                 IsList and IsAutomCollection,
                                 IsPosInt],
function(G, gens, level)
  local overgroup;

  overgroup := GroupOfAutomFamily(FamilyObj(gens[1]));

  if Length(gens) = 1 and IsOne(gens[1]) then
    return TrivialSubgroup(overgroup);
  fi;

  return SubgroupNC(overgroup, gens);
end);

InstallMethod($SimplifyGenerators, [IsList and IsAutomCollection],
function(gens)
  local words, fam;

  if IsEmpty(gens) then
    return [];
  fi;

  fam := FamilyObj(gens[1]);
  words := FreeGeneratorsOfGroup(Group(List(gens, a -> a!.word)));

  if fam!.use_rws and not IsEmpty(words) then
    words := ReducedForm(fam!.rws, words);
    words := FreeGeneratorsOfGroup(Group(words));
  fi;

  return List(words, w -> Autom(w, fam));
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

InstallMethod(TopDegreeOfTree, "DegreeOfTree(IsAutomGroup)",
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
  local i, gens, printone;

  printone := function(a)
    Print(a, " = ", Expand(a));
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
## TODO XXX it's broken, test it
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

  if mih = fail then
    return fail;
  elif not mih[3] then
    return gens;
  fi;

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
  local f;
  if IsTrivial(G) then
    Info(InfoAutomata, 3, "Size(G): 1, G is trivial");
    return 1;
  fi;

  if CanEasilyTestSphericalTransitivity(G) and IsSphericallyTransitive(G) then
    Info(InfoAutomata, 3, "Size(G): infinity, G is spherically transitive");
    return infinity;
  fi;

  if IsFractalByWords(G) then
    Info(InfoAutomata, 3, "Size(G): infinity, G is fractal by words");
    return infinity;
  fi;

  if HasIsFractal(G) and IsFractal(G) then
    Info(InfoAutomata, 3, "Size(G): infinity, G is fractal");
    return infinity;
  fi;

  if IsAutomatonGroup(G) and LevelOfFaithfulAction(G,8)<>fail then
    return Size(G);
  fi;

  f := FindElementOfInfiniteOrder(G,10,10);

  if HasSize(G) or f <> fail then
    return Size(G);
  fi;

  Info(InfoAutomata, 1, "You can try to use IsomorphismPermGroup(<G>) or\n",
                        "   FindElementOfInfiniteOrder(<G>,<length>,<depth>) with bigger bounds");
  TryNextMethod();
end);


###############################################################################
##
#A  LevelOfFaithfulAction (<G>)
#A  LevelOfFaithfulAction (<G>, <max_lev>)
##
##  For a given finite self-similar group <G> determines the smallest level of
##  the tree, where <G> acts faithfully, i.e. the stabilizer of this level in <G>
##  is trivial. The idea here is that for self-similar group all nontrivial level
##  stabilizers are different. If <max_lev> is given it finds only first <max_lev>
##  quotients by stabilizers and if all of them have different size returns 'fail'.
##  If <G> is infinite and <max_lev> is not specified will loop forever.
##
##  See also "IsomorphismPermGroup".
##  \beginexample
##  gap> H:=AutomGroup("a=(a,a)(1,2),b=(a,a),c=(b,a)(1,2)");
##  < a, b, c >
##  gap> LevelOfFaithfulAction(H);
##  3
##  gap> LevelOfFaithfulAction(AddingMachine,10);
##  fail
##  \endexample
##
InstallOtherMethod(LevelOfFaithfulAction, "method for IsAutomGroup and IsSelfSimilar",
              [IsAutomGroup and IsSelfSimilar,IsCyclotomic],
function(G,max_lev)
  local s,s_next,lev;
  if HasIsFinite(G) and not IsFinite(G) then return fail; fi;
  if HasLevelOfFaithfulAction(G) then return LevelOfFaithfulAction(G); fi;
  lev:=0; s:=1; s_next:=Size(PermGroupOnLevel(G,1));
  while s<s_next and lev<max_lev do
    lev:=lev+1;
    s:=s_next;
    s_next:=Size(PermGroupOnLevel(G,lev+1));
  od;
  if s=s_next then
    SetSize(G,s);
    SetLevelOfFaithfulAction(G,lev);
    return lev;
  else
    return fail;
  fi;
end);


InstallMethod(LevelOfFaithfulAction, "method for IsAutomGroup and IsSelfSimilar",
              [IsAutomGroup and IsSelfSimilar],
function(G)
  return LevelOfFaithfulAction(G,infinity);
end);


################################################################################
##
#O  IsomorphismPermGroup (<G>)
#O  IsomorphismPermGroup (<G>, <max_lev>)
##
##  For a given finite group <G> generated by initial automata (see "IsAutomGroup")
##  computes an isomorphism from <G> into a finite permutational group.
##  If <G> is not known to be self-similar (see "IsSelfSimilar") the isomorphism is based on the
##  regular representation, which works generally much slower. If <G> is self-similar
##  there is a level of the tree (see "LevelOfFaithfulAction"), where <G> acts faithfully.
##  The corresponding representation is returned in this case. If <max_lev> is given
##  it finds only first <max_lev> quotients by stabilizers and if all of them have
##  different size returns 'fail'.
##  If <G> is infinite and <max_lev> is not specified will loop forever.
##  \beginexample
##  gap> G:=GrigorchukGroup;
##  < a, b, c, d >
##  gap> f:=IsomorphismPermGroup(Group(a,b));
##  [ a, b ] -> [ (1,2)(3,5)(4,6)(7,9)(8,10)(11,13)(12,14)(15,17)(16,18)(19,21)(20,22)(23,25)(24,26)(27,29)(28,
##      30)(31,32), (1,3)(2,4)(5,7)(6,8)(9,11)(10,12)(13,15)(14,16)(17,19)(18,20)(21,23)(22,24)(25,27)(26,
##      28)(29,31)(30,32) ]
##  gap> Size(Image(f));
##  32
##  gap> H:=AutomGroup("a=(a,a)(1,2),b=(a,a),c=(b,a)(1,2)");
##  < a, b, c >
##  gap> f1:=IsomorphismPermGroup(H);
##  [ a, b, c ] -> [ (1,8)(2,7)(3,6)(4,5), (1,4)(2,3)(5,8)(6,7), (1,6,3,8)(2,5,4,7) ]
##  gap> Size(Image(f1));
##  16
##  \endexample
##
InstallOtherMethod(IsomorphismPermGroup, "IsomorphismPermGroup(IsAutomatonGroup,IsCyclotomic)",
                   [IsAutomGroup and IsSelfSimilar, IsCyclotomic],
function (G, n)
  local H, lev;
  lev := LevelOfFaithfulAction(G, n);
  if lev <> fail then
    H := PermGroupOnLevel(G,LevelOfFaithfulAction(G));
    return GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
  fi;
  return fail;
end);

## XXX need general method
InstallMethod(IsomorphismPermGroup, "IsomorphismPermGroup(IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup],
function(G)
  local H;
  H := PermGroupOnLevel(G, LevelOfFaithfulAction(G));
  return GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
end);

InstallMethod(IsomorphismPermGroup, "IsomorphismPermGroup(IsAutomGroup)",
              [IsAutomGroup],
function (G)
  local H;
  H := AG_FiniteGroupId(G);
  return GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
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
InstallMethod(IsSphericallyTransitive, "IsSphericallyTransitive(IsAutomGroup)",
              [IsAutomGroup],
function (G)
  local x, rat_gens, abel_hom;

  if IsFractalByWords(G) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): true");
    Info(InfoAutomata, 3, "  G is fractal");
    return true;
  fi;

  if IsTrivial(G) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is trivial: G = ", G);
    return false;
  fi;

  if HasIsFinite(G) and IsFinite(G) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  IsFinite(G): G = ", G);
    return false;
  fi;

  if DegreeOfTree(G) = 2 and TestSelfSimilarity(G) and IsSelfSimilar(G) then
    if HasIsFinite(G) and IsFinite(G)=false then
      Info(InfoAutomata, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomata, 3, "  <G> is infinite self-similar acting on binary tree");
      return true;
    fi;
    if PermGroupOnLevel(G,2)=Group((1,4,2,3)) then
      Info(InfoAutomata, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomata, 3, "  any element which acts transitively on the first level acts spherically transitively");
      return true;
    fi;
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
  local fgens1, fgens2, fam;

  if HasIsGroupOfAutomFamily(G) and HasIsGroupOfAutomFamily(H) then
    if IsGroupOfAutomFamily(G) <> IsGroupOfAutomFamily(H) then
      Info(InfoAutomata, 3, "G = H: false, exactly one is GroupOfAutomFamily");
      return false;
    fi;
    if IsGroupOfAutomFamily(G) then
      Info(InfoAutomata, 3, "G = H: true, both are GroupOfAutomFamily");
      return true;
    fi;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
  fam := UnderlyingAutomFamily(G);

  if fam!.rws <> fail then
    fgens1 := AsSet(ReducedForm(fam!.rws, fgens1));
    fgens2 := AsSet(ReducedForm(fam!.rws, fgens2));
  fi;

  if GroupWithGenerators(fgens1) = GroupWithGenerators(fgens2) then
    Info(InfoAutomata, 3, "G = H: true, by subgroups of free group");
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
  local h, fam, fgens1, fgens2;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    Info(InfoAutomata, 3, "IsSubgroup(G, H): true");
    Info(InfoAutomata, 3, "  G is GroupOfAutomFamily");
    return true;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
  fam := UnderlyingAutomFamily(G);

  if fam!.rws <> fail then
    fgens1 := AsSet(ReducedForm(fam!.rws, fgens1));
    fgens2 := AsSet(ReducedForm(fam!.rws, fgens2));
  fi;

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
  local fam, fgens, w;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    return true;
  fi;

  fgens := List(GeneratorsOfGroup(G), g -> Word(g));
  w := Word(g);

  fam := UnderlyingAutomFamily(G);

  if fam!.rws <> fail then
    fgens := AsSet(ReducedForm(fam!.rws, fgens));
    w := ReducedForm(fam!.rws, w);
  fi;

  if w in GroupWithGenerators(fgens) then
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


###############################################################################
##
#M  TrivialSubgroup(<G>)
##
InstallMethod(TrivialSubgroup, "for IsAutomGroup",
              [IsAutomGroup],
function(G)
  return Subgroup(G,[One(UnderlyingAutomFamily(G))]);
end);


###############################################################################
##
#M  IsAutomatonGroup(<G>)
##
InstallImmediateMethod(IsAutomatonGroup,IsAutomGroup,0,
function(G)
  local fam;
  fam:=UnderlyingAutomFamily(G);
  return fam!.numstates = 0 or
         GeneratorsOfGroup(G)=fam!.automgens{[1..fam!.numstates]};
end);


###############################################################################
##
#M  AutomatonList(<G>)
##
InstallMethod(AutomatonList, "for IsAutomGroup",
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
InstallMethod(IsSelfSimilar, "for IsAutomGroup",
              [IsAutomGroup],
function(G)
  local g,i,res;
  res:=true;
  for g in GeneratorsOfGroup(G) do
    for i in [1..UnderlyingAutomFamily(G)!.deg] do
      res:= State(g,i) in G;
      if res=fail then TryNextMethod();
      elif not res then return false;
      fi;
    od;
  od;
  return true;
end);


InstallMethod(SphericalIndex, "for IsAutomGroup",
              [IsAutomGroup],
function(G)
  return SphericalIndex(GeneratorsOfGroup(G)[1]);
end);
InstallMethod(DegreeOfTree, "for IsAutomGroup",
              [IsAutomGroup],
function(G)
  return UnderlyingAutomFamily(G)!.deg;
end);
InstallMethod(TopDegreeOfTree, "for IsAutomGroup",
              [IsAutomGroup],
function(G)
  return UnderlyingAutomFamily(G)!.deg;
end);


#E
