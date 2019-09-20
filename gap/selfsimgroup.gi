#############################################################################
##
#W  selfsimgroup.gi           automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  SelfSimilarGroup(<list>)
##
InstallMethod(SelfSimilarGroup, "for [IsList]", [IsList],
function(list)
  return SelfSimilarGroup(list, false);
end);


###############################################################################
##
#M  SelfSimilarGroup(<list>, <bind_vars>)
##
InstallMethod(SelfSimilarGroup, "for [IsList, IsBool]", [IsList, IsBool],
function(list, bind_vars)
  if not AG_IsCorrectRecurList(list, true) then
    Error("in SelfSimilarGroup(IsList, IsBool):\n",
          "  given list is not a correct list representing self-similar group\n");
  fi;

  return GroupOfSelfSimFamily(SelfSimFamily(list, bind_vars));
end);


###############################################################################
##
#M  SelfSimilarGroup(<list>, <names>)
##
InstallMethod(SelfSimilarGroup, "for [IsList, IsList]", [IsList, IsList],
function(list, names)
  return SelfSimilarGroup(list, names, AG_Globals.bind_vars_autom_family);
end);


###############################################################################
##
#M  SelfSimilarGroup(<list>, <names>, <bind_vars>)
##
InstallMethod(SelfSimilarGroup,
              "for [IsList, IsList, IsBool]", [IsList, IsList, IsBool],
function(list, names, bind_vars)
  if not AG_IsCorrectRecurList(list, true) then
    Error("error in SelfSimilarGroup(IsList, IsList, IsBool):\n",
          "  given list is not a correct list representing self-similar group\n");
  fi;

  return GroupOfSelfSimFamily(SelfSimFamily(list, names, bind_vars));
end);


###############################################################################
##
#M  SelfSimilarGroup(<string>)
#M  SelfSimilarGroup(<string>, <bind_vars>)
##
InstallMethod(SelfSimilarGroup, "for [IsString]", [IsString],
function(string)
  return SelfSimilarGroup(string, AG_Globals.bind_vars_autom_family);
end);

InstallMethod(SelfSimilarGroup, "for [IsString, IsBool]", [IsString, IsBool],
function(string, bind_vars)
  local s;
  s := AG_ParseAutomatonStringFR(string);
  return SelfSimilarGroup(s[2], s[1], bind_vars);
end);


###############################################################################
##
#M  SelfSimilarGroup(<A>)
#M  SelfSimilarGroup(<A>, <bind_vars>)
##
InstallMethod(SelfSimilarGroup, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  if not IsInvertible(A) then
    Error("Automaton <A> is not invertible");
  fi;
  return SelfSimilarGroup(AutomatonList(A), A!.states);
end);

InstallMethod(SelfSimilarGroup, "for [IsMealyAutomaton, IsBool]", [IsMealyAutomaton, IsBool],
function(A, bind_vars)
  if not IsInvertible(A) then
    Error("Automaton <A> is not invertible");
  fi;
  return SelfSimilarGroup(AutomatonList(A), A!.states, bind_vars);
end);



###############################################################################
##
#M  GroupOfSelfSimFamily(<G>)
##
InstallMethod(GroupOfSelfSimFamily, "for [IsSelfSimGroup]",
                   [IsSelfSimGroup],
function(G)
  return GroupOfSelfSimFamily(UnderlyingSelfSimFamily(G));
end);


###############################################################################
##
#M  IsGroupOfSelfSimFamily(<G>)
##
InstallMethod(IsGroupOfSelfSimFamily, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  return G = GroupOfSelfSimFamily(G);
end);


###############################################################################
##
#M  UseSubsetRelation(<G>)
##
InstallMethod(UseSubsetRelation,
              "for [IsSelfSimGroup, IsSelfSimGroup]",
              [IsSelfSimGroup, IsSelfSimGroup],
function(super, sub)
  ## the full group is self similar, so if <super> is smaller than the full
  ##  group then sub is smaller either
  if HasIsGroupOfSelfSimFamily(super) then
    if not IsGroupOfSelfSimFamily(super) then
      SetIsGroupOfSelfSimFamily(sub, false); fi; fi;
  TryNextMethod();
end);


###############################################################################
##
#M  __AG_SubgroupOnLevel(<G>, <gens>, <level>)
##
InstallMethod(__AG_SubgroupOnLevel, [IsSelfSimGroup,
                                    IsList and IsTreeAutomorphismCollection,
                                    IsPosInt],
function(G, gens, level)
  local overgroup;

  if IsEmpty(gens) or (Length(gens) = 1 and IsOne(gens[1])) then
    return TrivialSubgroup(G);
  fi;

  if HasIsGroupOfSelfSimFamily(G) and IsGroupOfSelfSimFamily(G) then
    overgroup := G;
  else
    overgroup := GroupOfSelfSimFamily(UnderlyingSelfSimFamily(G));
  fi;

  return SubgroupNC(overgroup, gens);
end);

InstallOtherMethod(__AG_SubgroupOnLevel, [IsSelfSimGroup, IsList and IsEmpty, IsPosInt],
function(G, gens, level)
  return TrivialSubgroup(G);
end);

InstallMethod(__AG_SubgroupOnLevel, [IsTreeAutomorphismGroup,
                                    IsList and IsSelfSimCollection,
                                    IsPosInt],
function(G, gens, level)
  local overgroup;

  overgroup := GroupOfSelfSimFamily(FamilyObj(gens[1]));

  if Length(gens) = 1 and IsOne(gens[1]) then
    return TrivialSubgroup(overgroup);
  fi;

  return SubgroupNC(overgroup, gens);
end);

InstallMethod(__AG_SimplifyGroupGenerators, "for [IsList and IsInvertibleSelfSimCollection]",
                          [IsList and IsInvertibleSelfSimCollection],
function(gens)
  local words, fam;

  if IsEmpty(gens) then
    return [];
  fi;

  fam := FamilyObj(gens[1]);
  words := FreeGeneratorsOfGroup(Group(List(gens, a -> a!.word)));

  if fam!.use_rws and not IsEmpty(words) then
    words := AG_ReducedForm(fam!.rws, words);
    if IsEmpty(words) then
      return [];
    fi;
    words := FreeGeneratorsOfGroup(Group(words));
  fi;

  return List(words, w -> SelfSim(w, fam));
end);

###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, "for [IsSelfSimilarGroup]",
              [IsSelfSimilarGroup],
function(G)
  Print("SelfSimilarGroup(\"", String(G), "\")");
end);


###############################################################################
##
#M  Display(<G>)
##
InstallMethod(Display, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
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
InstallMethod(String, "for [IsSelfSimGroup]", [IsSelfSimGroup],
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
InstallMethod(ViewObj, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
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
#M  IsFractalByWords(G)
##
InstallMethod(IsFractalByWords, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
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
InstallMethod(Size, "for [IsSelfSimGroup]", [IsSelfSimGroup],
function (G)
  local f;
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

  if IsSelfSimilarGroup(G) and LevelOfFaithfulAction(G, 8)<>fail then
    return Size(G);
  fi;

  f := FindElementOfInfiniteOrder(G, 10, 10);

  if HasSize(G) or f <> fail then
    return Size(G);
  fi;

  Info(InfoAutomGrp, 1, "You can try to use IsomorphismPermGroup(<G>) or\n",
                        "   FindElementOfInfiniteOrder( <G>, <length>, <depth> ) with bigger bounds");
  TryNextMethod();
end);


InstallOtherMethod(LevelOfFaithfulAction, "for [IsSelfSimGroup and IsSelfSimilar, IsCyclotomic]",
              [IsSelfSimGroup and IsSelfSimilar, IsCyclotomic],
function(G, max_lev)
  local s, s_next, lev;
  if HasIsFinite(G) and not IsFinite(G) then return fail; fi;
  if HasLevelOfFaithfulAction(G) then return LevelOfFaithfulAction(G); fi;
  lev := 0; s := 1; s_next := Size(PermGroupOnLevel(G, 1));
  while s<s_next and lev<max_lev do
    lev := lev+1;
    s := s_next;
    s_next := Size(PermGroupOnLevel(G, lev+1));
  od;
  if s=s_next then
    SetSize(G, s);
    SetLevelOfFaithfulAction(G, lev);
    return lev;
  else
    return fail;
  fi;
end);


InstallMethod(LevelOfFaithfulAction, "for [IsSelfSimGroup and IsSelfSimilar]",
              [IsSelfSimGroup and IsSelfSimilar],
function(G)
  return LevelOfFaithfulAction(G, infinity);
end);


################################################################################
##
#O  IsomorphismPermGroup (<G>)
#O  IsomorphismPermGroup (<G>, <max_lev>)
##
##  For a given finite group <G> generated by initial automata or by elements defined by
##  wreath recursion
##  computes an isomorphism from <G> into a finite permutational group.
##  If <G> is not known to be self-similar (see "IsSelfSimilar") the isomorphism is based on the
##  regular representation, which works generally much slower. If <G> is self-similar
##  there is a level of the tree (see "LevelOfFaithfulAction"), where <G> acts faithfully.
##  The corresponding representation is returned in this case. If <max_lev> is given
##  it finds only the first <max_lev> quotients by stabilizers and if all of them have
##  different size it returns `fail'.
##  If <G> is infinite and <max_lev> is not specified it will loop forever.
##
##  For example, consider a subgroup $\langle a, b\rangle$ of Grigorchuk group.
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> f := IsomorphismPermGroup(Group(a, b));
##  MappingByFunction( < a, b >, Group(
##  [ (1,2)(3,5)(4,6)(7,9)(8,10)(11,13)(12,14)(15,17)(16,18)(19,21)(20,22)(23,
##      25)(24,26)(27,29)(28,30)(31,32), (1,3)(2,4)(5,7)(6,8)(9,11)(10,12)(13,
##      15)(14,16)(17,19)(18,20)(21,23)(22,24)(25,27)(26,28)(29,31)(30,32)
##   ]), function( g ) ... end, function( b ) ... end )
##  gap> Size(Image(f));
##  32
##  gap> H := SelfSimilarGroup("a=(a*b,1)(1,2), b=(1,b*a^-1)(1,2), c=(b, a*b)");
##  < a, b, c >
##  gap> f1 := IsomorphismPermGroup(H);
##  MappingByFunction( < a, b, c >, Group([ (1,3)(2,4), (1,3)(2,4), (1,2)
##   ]), function( g ) ... end, function( b ) ... end )
##  gap> Size(Image(f1));
##  8
##  gap> PreImagesRepresentative(f1, (1,3,2,4));
##  a*c
##  gap> (a*c)^f1;
##  (1,3,2,4)
##  \endexample
##
InstallOtherMethod(IsomorphismPermGroup, "for [IsSelfSimilarGroup, IsCyclotomic]",
                   [IsSelfSimGroup and IsSelfSimilar, IsCyclotomic],
function (G, n)
  local H, lev;
  lev := LevelOfFaithfulAction(G, n);
  if lev <> fail then
    H := PermGroupOnLevel(G, LevelOfFaithfulAction(G));
    return AG_GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
  fi;
  return fail;
end);


###############################################################################
##
#M  IsSphericallyTransitive(G)
##
InstallMethod(IsSphericallyTransitive, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function (G)
  local x, rat_gens, abel_hom, lev;

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
    if HasIsFinite(G) and IsFinite(G)=false then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomGrp, 3, "  <G> is infinite self-similar acting on binary tree");
      return true;
    fi;
    if PermGroupOnLevel(G, 2)=Group((1, 4, 2, 3)) then
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
                    "for [IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt]",
                    [IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt],
function(G, n)
  return DiagonalPower(UnderlyingSelfSimFamily(G), n);
end);


###############################################################################
##
#M  MultAutomAlphabet(<G>, <n>)
##
InstallOtherMethod( MultAutomAlphabet,
                    "for [IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt]",
                    [IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt],
function(G, n)
  return MultAutomAlphabet(UnderlyingSelfSimFamily(G), n);
end);


###############################################################################
##
#M  \= (<G>, <H>)
##
InstallMethod(\=, "for [IsSelfSimGroup, IsSelfSimGroup]",
              IsIdenticalObj, [IsSelfSimGroup, IsSelfSimGroup],
function(G, H)
  local fgens1, fgens2, fam;

  if HasIsGroupOfSelfSimFamily(G) and HasIsGroupOfSelfSimFamily(H) then
    if IsGroupOfSelfSimFamily(G) <> IsGroupOfSelfSimFamily(H) then
      Info(InfoAutomGrp, 3, "G = H: false, exactly one is GroupOfSelfSimFamily");
      return false;
    fi;
    if IsGroupOfSelfSimFamily(G) then
      Info(InfoAutomGrp, 3, "G = H: true, both are GroupOfSelfSimFamily");
      return true;
    fi;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
  fam := UnderlyingSelfSimFamily(G);

  if fam!.rws <> fail then
    fgens1 := AG_ReducedForm(fam!.rws, fgens1);
    fgens2 := AG_ReducedForm(fam!.rws, fgens2);
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
InstallMethod(IsSubset, "for [IsSelfSimGroup, IsSelfSimGroup]",
              IsIdenticalObj, [IsSelfSimGroup, IsSelfSimGroup],
function(G, H)
  local h, fam, fgens1, fgens2;

  if HasIsGroupOfSelfSimFamily(G) and IsGroupOfSelfSimFamily(G) then
    Info(InfoAutomGrp, 3, "IsSubgroup(G, H): true");
    Info(InfoAutomGrp, 3, "  G is GroupOfSelfSimFamily");
    return true;
  fi;

  fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
  fam := UnderlyingSelfSimFamily(G);

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
InstallMethod(\in, "for [IsSelfSim, IsSelfSimGroup]",
              [IsSelfSim, IsSelfSimGroup],
function(g, G)
  local fam, fgens, w;

  if HasIsGroupOfSelfSimFamily(G) and IsGroupOfSelfSimFamily(G) then
    return true;
  fi;

  fgens := List(GeneratorsOfGroup(G), g -> Word(g));
  w := Word(g);

  fam := UnderlyingSelfSimFamily(G);

  if fam!.rws <> fail then
    fgens := AG_ReducedForm(fam!.rws, fgens);
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
#O  Random(<G>)
##
##  Returns a random element of a group (semigroup) <G>. The operation is based
##  on the generator of random elements in free groups and semigroups.
##
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> Random( Basilica );
##  v*u^-3
##  \endexample
##
InstallMethodWithRandomSource(Random, "for a random source and [IsSelfSimGroup]",
              [IsRandomSource, IsSelfSimGroup],
function(rs, G)
  local F, gens, pi;

  if IsTrivial(G) then
    return One(G);
  elif IsSelfSimilarGroup(G) then
    return SelfSim(Random(rs, UnderlyingFreeGroup(G)), UnderlyingSelfSimFamily(G));
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
InstallMethod(UnderlyingFreeSubgroup, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  local f;
  if HasIsGroupOfSelfSimFamily(G) and IsGroupOfSelfSimFamily(G) then
    return UnderlyingFreeGroup(G);
  fi;
  f := Subgroup(UnderlyingFreeGroup(G), UnderlyingFreeGenerators(G));
  if f = UnderlyingFreeGroup(G) then
    SetIsGroupOfSelfSimFamily(G, true);
  fi;
  return f;
end);


###############################################################################
##
#M  UnderlyingFreeGenerators(<G>)
##
InstallMethod(UnderlyingFreeGenerators, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  return List(GeneratorsOfGroup(G), g -> Word(g));
end);


###############################################################################
##
#M  TrivialSubmagmaWithOne(<G>)
##
InstallMethod(TrivialSubmagmaWithOne, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  return Subgroup(G, [One(G)]);
end);


###############################################################################
##
#M  IsSelfSimilarGroup(<G>)
##
##  Returns `true' if generators of <G> coincide with generators of the family
InstallImmediateMethod(IsSelfSimilarGroup, IsSelfSimGroup, 0,
function(G)
  local fam;
  fam := UnderlyingSelfSimFamily(G);
  return fam!.numstates = 0 or
         GeneratorsOfGroup(G) = fam!.recurgens{[1..fam!.numstates]};
end);


###############################################################################
##
#M  RecurList(<G>)
##
InstallMethod(RecurList, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  if IsSelfSimilarGroup(G) then
    return RecurList(GroupOfSelfSimFamily(UnderlyingSelfSimFamily(G)));
  else
    Error("Group <G> is not necessarily self-similar");
  fi;
end);


###############################################################################
##
#M  IsSelfSimilar(<G>)
##
InstallMethod(IsSelfSimilar, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  local g, i, res;
  res := true;
  for g in GeneratorsOfGroup(G) do
    for i in [1..UnderlyingSelfSimFamily(G)!.deg] do
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
#M  UnderlyingSelfSimFamily(<G>)
##
InstallMethod(UnderlyingSelfSimFamily, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  return FamilyObj(GeneratorsOfGroup(G)[1]);
end);


###############################################################################
##
#M  IsFiniteState(<G>)
##
InstallMethod(IsFiniteState, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  local states, MealyAutomatonLocal, aut_list, gens, images, H, g, hom_function, \
        inv_hom_function, hom, free_groups_hom, inv_free_groups_hom, inv_hom, \
        gens_in_freegrp, images_in_freegrp, preimages_in_freegrp, F, pi, pi_bar, \
        preimage_in_freegrp, MealyAutomatonLocalFinite;

# if we do not know much, we compare just words in free group
  MealyAutomatonLocal := function(g)
    local cur_state;
    if g!.word in states then return Position(states, g!.word); fi;
    Add(states, g!.word);
    cur_state := Length(states);
    aut_list[cur_state] := List([1..g!.deg], x -> MealyAutomatonLocal(Section(g, x)));
    Add(aut_list[cur_state], g!.perm);
    return cur_state;
  end;

# if we do know that the groups is finite, we compare actual elements of the group
  MealyAutomatonLocalFinite := function(g)
    local cur_state;
    if g in states then return Position(states, g); fi;
    Add(states, g);
    cur_state := Length(states);
    aut_list[cur_state] := List([1..g!.deg], x -> MealyAutomatonLocalFinite(Section(g, x)));
    Add(aut_list[cur_state], g!.perm);
    return cur_state;
  end;


  if IsTrivial(G) then return true; fi;

  states := [];
  aut_list := [];
  gens := GeneratorsOfGroup(G);
  images := [];


  if HasIsFinite(G) and IsFinite(G) then
    for g in gens do
      Add(images, MealyAutomatonLocalFinite(g));
    od;
    states := List(states, Word);
  else
    for g in gens do
      Add(images, MealyAutomatonLocal(g));
    od;
  fi;

  H := AutomatonGroup(aut_list);

  if IsTrivial(H) then
    SetIsTrivial( G, true);
    return true;
  fi;

  images := UnderlyingAutomFamily(H)!.oldstates{images};

  SetIsomorphicAutomGroup(G, GroupWithGenerators(UnderlyingAutomFamily(H)!.automgens{images}));
  SetUnderlyingAutomatonGroup(G, H);

# preimages of generators of G in UnderlyingFreeGroup(G)
  gens_in_freegrp := List(GeneratorsOfGroup(G), Word);

# preimages of generators of a subgroup of H isomorphic to G in UnderlyingFreeGroup(H)
  images_in_freegrp := List(UnderlyingAutomFamily(H)!.automgens{images}, Word);


  preimage_in_freegrp := function(x)
    local w;
    w := LetterRepAssocWord(x!.word)[1];
    if w > 0 then
      return states[ Position( UnderlyingAutomFamily(H)!.oldstates, w)];
    else
      return states[ Position( UnderlyingAutomFamily(H)!.oldstates, -w+UnderlyingAutomFamily(H)!.numstates)];
    fi;
  end;

#  preimages of generators of H in UnderlyingFreeGroup(G)
#  preimages_in_freegrp := List([1..Length(GeneratorsOfGroup(H))], x->states[Position(UnderlyingAutomFamily(H)!.oldstates, x)]);
  preimages_in_freegrp := List(GeneratorsOfGroup(H), x -> preimage_in_freegrp(x));


  if IsSelfSimilarGroup(G) then
    free_groups_hom :=
       GroupHomomorphismByImagesNC( Group(gens_in_freegrp), UnderlyingFreeGroup(H),
                                    gens_in_freegrp, images_in_freegrp );

    inv_free_groups_hom :=
       GroupHomomorphismByImagesNC( UnderlyingFreeGroup(H), UnderlyingFreeGroup(G),
                                    UnderlyingFreeGenerators(H), preimages_in_freegrp );

    hom_function := function(a)
      return Autom(Image(free_groups_hom, a!.word), UnderlyingAutomFamily(H));
    end;

    inv_hom_function :=  function(b)
      return SelfSim(Image(inv_free_groups_hom, b!.word), UnderlyingSelfSimFamily(G));
    end;

    hom := GroupHomomorphismByFunction(G, GroupWithGenerators(UnderlyingAutomFamily(H)!.automgens{images}), hom_function, inv_hom_function);

    SetMonomorphismToAutomatonGroup(G, hom);
  else
    F := FreeGroup(Length(GeneratorsOfGroup(G)));

#        pi
#    F ------> G ----> UnderlyingFreeGroup(H)
#      -------------->
#            pi_bar

    pi := GroupHomomorphismByImages(F,                     Group(gens_in_freegrp),
                                    GeneratorsOfGroup(F),  gens_in_freegrp);

    pi_bar := GroupHomomorphismByImages(F,                     UnderlyingFreeGroup(H),
                                        GeneratorsOfGroup(F),  images_in_freegrp);

    hom_function := function(g)
      return Autom(Image(pi_bar, PreImagesRepresentative(pi, g!.word)), UnderlyingAutomFamily(H));
    end;


    inv_hom_function :=  function(b)
      return SelfSim(Image(pi, PreImagesRepresentative(pi_bar, b!.word)), UnderlyingSelfSimFamily(G));
    end;

    hom := GroupHomomorphismByFunction(G, GroupWithGenerators(UnderlyingAutomFamily(H)!.automgens{images}), hom_function, inv_hom_function);

    SetMonomorphismToAutomatonGroup(G, hom);
  fi;


  return true;
end);


###############################################################################
##
#M  IsomorphicAutomGroup( <G> )
##
InstallMethod(IsomorphicAutomGroup, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  if IsFiniteState(G) then return IsomorphicAutomGroup(G); fi;
end);


###############################################################################
##
#M  UnderlyingAutomatonGroup( <G> )
##
InstallMethod(UnderlyingAutomatonGroup, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  if IsFiniteState(G) then return UnderlyingAutomatonGroup(G); fi;
end);

###############################################################################
##
#M  MonomorphismToAutomatonGroup( <G> )
##
InstallMethod(MonomorphismToAutomatonGroup, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  if IsFiniteState(G) then return MonomorphismToAutomatonGroup(G); fi;
end);



###############################################################################
##
#M  IsContracting( <G> )
##
InstallMethod(IsContracting, "for [IsSelfSimilarGroup]",
              [IsSelfSimilarGroup],
function(G)
  local res;
  if not IsFiniteState(G) then
#   every contracting self-similar group is finite-state
    return false;
  fi;

  res := IsContracting(GroupOfAutomFamily(UnderlyingAutomFamily(UnderlyingAutomatonGroup(G))));

  UnderlyingSelfSimFamily(G)!.use_contraction := true;
  UnderlyingAutomFamily(UnderlyingAutomatonGroup(G))!.use_contraction := true;

  return res;
end);



###############################################################################
##
#M  GroupNucleus( <G> )
##
InstallMethod(GroupNucleus, "for [IsSelfSimilarGroup]",
              [IsSelfSimilarGroup],
function(G)
  local H;
  if not IsFiniteState(G) then
#   every contracting self-similar group is finite-state
    Error("Group <G> is not finite-state");
  fi;

  if not IsContracting(G) then
    Error("Group <G> is not contracting");
  fi;

  H := GroupOfAutomFamily( UnderlyingAutomFamily( UnderlyingAutomatonGroup(G)));

  return List( GroupNucleus(H), x -> PreImagesRepresentative( MonomorphismToAutomatonGroup(G), x));
end);



###############################################################################
##
#M  UseContraction( <G> )
##
InstallMethod(UseContraction, "for [IsSelfSimGroup]", true,
              [IsSelfSimGroup],
function(G)
  if not IsSelfSimilarGroup(G) then
    Print("Error in UseContraction(<G>): The method is implemented only for IsSelfSimilarGroup\n");
    return fail;
  fi;

  if not HasIsContracting(G) then
    Print("Error in UseContraction(<G>): It is not known whether the group <G> is contracting\n");
    return fail;
  elif not IsContracting(G) then
    Print("Error in UseContraction(<G>): The group <G> is not contracting");
    return fail;
  fi;
  #  IsContracting returns either true or false or an error (it can not return fail)

  UnderlyingSelfSimFamily(G)!.use_contraction := true;
  UnderlyingAutomFamily( UnderlyingAutomatonGroup(G))!.use_contraction := true;

  return true;
end);



###############################################################################
##
#M  DoNotUseContraction( <G> )
##
InstallMethod(DoNotUseContraction, "for [IsSelfSimGroup]", true,
              [IsSelfSimGroup],
function(G)
  UnderlyingAutomFamily(G)!.use_contraction := false;

  if HasUnderlyingAutomatonGroup(G) then
    UnderlyingAutomFamily( UnderlyingAutomatonGroup(G))!.use_contraction := false;
  fi;
  return true;
end);




###############################################################################
##
#M  FindNucleus( <G> )
##
InstallMethod(FindNucleus, "for [IsSelfSimilarGroup, IsCyclotomic]",
              [IsSelfSimilarGroup, IsCyclotomic],
function(G, max_nucl)
  local H, nuclH, nuclG;
  if not IsFiniteState(G) then
#   every contracting self-similar group is finite-state
    Error("Group <G> is not finite-state");
  fi;

  if HasIsContracting(G) and not IsContracting(G) then
    Error("Group <G> is not contracting");
  fi;

  H := GroupOfAutomFamily( UnderlyingAutomFamily( UnderlyingAutomatonGroup( G )));

  if HasIsContracting(H) and not IsContracting(H) then
    Error("Group <G> is not contracting");
  fi;

  nuclH := FindNucleus(H, max_nucl);

  if nuclH=fail then return fail; fi;

  nuclG := [];
  Add(nuclG, List( GeneratingSetWithNucleus(H), x -> PreImagesRepresentative( MonomorphismToAutomatonGroup( G ), x )));
  Add(nuclG, List( GroupNucleus(H), x -> PreImagesRepresentative( MonomorphismToAutomatonGroup( G ), x )));
  Add(nuclG, GeneratingSetWithNucleusAutom(H));

  SetGroupNucleus(G, nuclG[1]);
  SetGeneratingSetWithNucleus(G, nuclG[2]);
  SetGeneratingSetWithNucleusAutom(G, nuclG[3]);
  SetContractingLevel(G, ContractingLevel(H));

  return nuclG;
end);


InstallMethod(FindNucleus, "for [IsSelfSimilarGroup]", true,
              [IsSelfSimilarGroup],
function(G)
  return FindNucleus(G, infinity);
end);


InstallMethod(GeneratingSetWithNucleus, "for [IsSelfSimilarGroup]", true,
              [IsSelfSimilarGroup],
function(G)
  if IsContracting(G) then return GeneratingSetWithNucleus(G); fi;
end);


InstallMethod(GeneratingSetWithNucleusAutom, "for [IsSelfSimilarGroup]", true,
              [IsSelfSimilarGroup],
function(G)
  if IsContracting(G) then return GeneratingSetWithNucleusAutom(G); fi;
end);

#E
