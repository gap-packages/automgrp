#############################################################################
##
#W  selfsimgroup.gi           automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  SelfSimilarGroup(<list>)
##
InstallMethod(SelfSimilarGroup, "SelfSimilarGroup(IsList)", [IsList],
function(list)
  return SelfSimilarGroup(list, false);
end);


###############################################################################
##
#M  SelfSimilarGroup(<list>, <bind_vars>)
##
InstallMethod(SelfSimilarGroup, "SelfSimilarGroup(IsList, IsBool)", [IsList, IsBool],
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
InstallMethod(SelfSimilarGroup, "SelfSimilarGroup(IsList, IsList)", [IsList, IsList],
function(list, names)
  return SelfSimilarGroup(list, names, AG_Globals.bind_vars_autom_family);
end);


###############################################################################
##
#M  SelfSimilarGroup(<list>, <names>, <bind_vars>)
##
InstallMethod(SelfSimilarGroup,
              "SelfSimilarGroup(IsList, IsList, IsBool)", [IsList, IsList, IsBool],
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
InstallMethod(SelfSimilarGroup, "SelfSimilarGroup(IsString)", [IsString],
function(string)
  return SelfSimilarGroup(string, AG_Globals.bind_vars_autom_family);
end);

InstallMethod(SelfSimilarGroup, "SelfSimilarGroup(IsString, IsBool)", [IsString, IsBool],
function(string, bind_vars)
  local s;
  s := AG_ParseAutomatonStringFR(string);
  return SelfSimilarGroup(s[2], s[1], bind_vars);
end);



###############################################################################
##
#M  GroupOfSelfSimFamily(<G>)
##
InstallOtherMethod(GroupOfSelfSimFamily, "GroupOfSelfSimFamily(IsSelfSimGroup)",
                   [IsSelfSimGroup],
function(G)
  return GroupOfSelfSimFamily(UnderlyingSelfSimFamily(G));
end);


###############################################################################
##
#M  IsGroupOfSelfSimFamily(<G>)
##
InstallMethod(IsGroupOfSelfSimFamily, "IsGroupOfSelfSimFamily(IsSelfSimGroup)",
              [IsSelfSimGroup],
function(G)
  return G = GroupOfSelfSimFamily(G);
end);


###############################################################################
##
#M  UseSubsetRelation(<G>)
##
InstallMethod(UseSubsetRelation,
              "UseSubsetRelation(IsSelfSimGroup, IsSelfSimGroup)",
              [IsSelfSimGroup, IsSelfSimGroup],
function(super, sub)
  ## the full group is self similar, so if <super> is smaller than the full
  ##  group then sub is smaller either
  if HasIsGroupOfSelfSimFamily(super) then
    if not IsGroupOfSelfSimFamily(super) then
      SetIsGroupOfSelfSimFamily(sub, false); fi; fi;
InstallTrueMethod(IsFractal, IsFractalByWords);
  TryNextMethod();
end);


###############################################################################
##
#M  $AG_SubgroupOnLevel(<G>, <gens>, <level>)
##
InstallMethod($AG_SubgroupOnLevel, [IsSelfSimGroup,
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

InstallMethod($AG_SubgroupOnLevel, [IsSelfSimGroup, IsList and IsEmpty, IsPosInt],
function(G, gens, level)
  return TrivialSubgroup(G);
end);

InstallMethod($AG_SubgroupOnLevel, [IsTreeAutomorphismGroup,
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

InstallMethod($AG_SimplifyGroupGenerators, "for [IsList and IsInvertibleSelfSimCollection]",
                          [IsList and IsInvertibleSelfSimCollection],
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

  return List(words, w -> SelfSim(w, fam));
end);


###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, "PrintObj(IsSelfSimGroup)",
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


###############################################################################
##
#M  ViewObj(<G>)
##
InstallMethod(ViewObj, "ViewObj(IsSelfSimGroup)",
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
InstallMethod(IsFractalByWords, "IsFractalByWords(IsSelfSimGroup)",
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
InstallMethod(Size, "Size(IsSelfSimGroup)", [IsSelfSimGroup],
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

  if IsSelfSimilarGroup(G) and LevelOfFaithfulAction(G,8)<>fail then
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


InstallOtherMethod(LevelOfFaithfulAction, "method for IsSelfSimGroup and IsSelfSimilar",
              [IsSelfSimGroup and IsSelfSimilar,IsCyclotomic],
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


InstallMethod(LevelOfFaithfulAction, "method for IsSelfSimGroup and IsSelfSimilar",
              [IsSelfSimGroup and IsSelfSimilar],
function(G)
  return LevelOfFaithfulAction(G,infinity);
end);


################################################################################
##
#O  IsomorphismPermGroup (<G>)
#O  IsomorphismPermGroup (<G>, <max_lev>)
##
##  For a given finite group <G> generated by initial automata (see "IsSelfSimGroup")
##  computes an isomorphism from <G> into a finite permutational group.
##  If <G> is not known to be self-similar (see "IsSelfSimilar") the isomorphism is based on the
##  regular representation, which works generally much slower. If <G> is self-similar
##  there is a level of the tree (see "LevelOfFaithfulAction"), where <G> acts faithfully.
##  The corresponding representation is returned in this case. If <max_lev> is given
##  it finds only first <max_lev> quotients by stabilizers and if all of them have
##  different size returns `fail'.
##  If <G> is infinite and <max_lev> is not specified will loop forever.
##
##  For example, consider a subgroup $\langle a,b\rangle$ of Grigorchuk group.
##  \beginexample
##  gap> f:=IsomorphismPermGroup(Group(a,b));
##  [ a, b ] -> [ (1,2)(3,5)(4,6)(7,9)(8,10)(11,13)(12,14)(15,17)(16,18)(19,21)(20,
##      22)(23,25)(24,26)(27,29)(28,30)(31,32), (1,3)(2,4)(5,7)(6,8)(9,11)(10,12)(13,
##      15)(14,16)(17,19)(18,20)(21,23)(22,24)(25,27)(26,28)(29,31)(30,32) ]
##  gap> Size(Image(f));
##  32
##  gap> H:=SelfSimilarGroup("a=(a,a)(1,2),b=(a,a),c=(b,a)(1,2)");
##  < a, b, c >
##  gap> f1:=IsomorphismPermGroup(H);
##  [ a, b, c ] -> [ (1,8)(2,7)(3,6)(4,5), (1,4)(2,3)(5,8)(6,7), (1,6,3,8)(2,5,4,7) ]
##  gap> Size(Image(f1));
##  16
##  \endexample
##
InstallOtherMethod(IsomorphismPermGroup, "IsomorphismPermGroup(IsSelfSimilarGroup,IsCyclotomic)",
                   [IsSelfSimGroup and IsSelfSimilar, IsCyclotomic],
function (G, n)
  local H, lev;
  lev := LevelOfFaithfulAction(G, n);
  if lev <> fail then
    H := PermGroupOnLevel(G,LevelOfFaithfulAction(G));
    return GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
  fi;
  return fail;
end);


###############################################################################
##
#M  IsSphericallyTransitive(G)
##
InstallMethod(IsSphericallyTransitive, "IsSphericallyTransitive(IsSelfSimGroup)",
              [IsSelfSimGroup],
function (G)
  local x, rat_gens, abel_hom;

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
    if PermGroupOnLevel(G,2)=Group((1,4,2,3)) then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomGrp, 3, "  any element which acts transitively on the first level acts spherically transitively");
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
                    "DiagonalAction(IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt)",
                    [IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt],
function(G, n)
  return DiagonalAction(UnderlyingSelfSimFamily(G), n);
end);


###############################################################################
##
#M  MultAutomAlphabet(<G>, <n>)
##
InstallOtherMethod( MultAutomAlphabet,
                    "MultAutomAlphabet(IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt)",
                    [IsSelfSimGroup and IsGroupOfSelfSimFamily, IsPosInt],
function(G, n)
  return MultAutomAlphabet(UnderlyingSelfSimFamily(G), n);
end);


###############################################################################
##
#M  \= (<G>, <H>)
##
InstallMethod(\=, "\=(IsSelfSimGroup, IsSelfSimGroup)",
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
    fgens1 := AsSet(ReducedForm(fam!.rws, fgens1));
    fgens2 := AsSet(ReducedForm(fam!.rws, fgens2));
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
InstallMethod(IsSubset, "IsSubset(IsSelfSimGroup, IsSelfSimGroup)",
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
    fgens1 := AsSet(ReducedForm(fam!.rws, fgens1));
    fgens2 := AsSet(ReducedForm(fam!.rws, fgens2));
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
InstallMethod(\in, "\in(IsSelfSim, IsSelfSimGroup)",
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
    fgens := AsSet(ReducedForm(fam!.rws, fgens));
    w := ReducedForm(fam!.rws, w);
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
InstallMethod(Random, "Random(IsSelfSimGroup)",
              [IsSelfSimGroup],
function(G)
  # XXX! only for whole group
  if IsTrivial(G) then
    return One(G);
  else
    return SelfSim(Random(UnderlyingFreeGroup(G)), UnderlyingSelfSimFamily(G));
  fi;
end);


###############################################################################
##
#M  UnderlyingFreeSubgroup(<G>)
##
InstallMethod(UnderlyingFreeSubgroup, "UnderlyingFreeSubgroup(IsSelfSimGroup)",
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
#M  IndexInFreeGroup(<G>)
##
InstallMethod(IndexInFreeGroup, "IndexInFreeGroup(IsSelfSimGroup)",
              [IsSelfSimGroup],
function(G)
  return IndexInWholeGroup(UnderlyingFreeSubgroup(G));
end);


###############################################################################
##
#M  UnderlyingFreeGenerators(<G>)
##
InstallMethod(UnderlyingFreeGenerators, "UnderlyingFreeGenerators(IsSelfSimGroup)",
              [IsSelfSimGroup],
function(G)
  return List(GeneratorsOfGroup(G), g -> Word(g));
end);


###############################################################################
##
##  AG_ApplyNielsen(<G>)
##
InstallMethod(AG_ApplyNielsen, "AG_ApplyNielsen(IsSelfSimGroup)",
              [IsSelfSimGroup],
function(G)
  local fgens;

  fgens := List(GeneratorsOfGroup(G), g -> Word(g));
  fgens := AG_ReducedByNielsen(fgens);
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
#M  TrivialSubmagmaWithOne(<G>)
##
InstallMethod(TrivialSubmagmaWithOne, "for IsSelfSimGroup",
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
InstallMethod(RecurList, "for IsSelfSimGroup",
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
InstallMethod(IsSelfSimilar, "for IsSelfSimGroup",
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
InstallMethod(UnderlyingSelfSimFamily, "UnderlyingSelfSimFamily(IsSelfSimGroup)",
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
  local states, MealyAutomatonLocal, aut_list, gens, images, H, g, hom_function,\
        inv_hom_function, hom, free_groups_hom, inv_free_groups_hom, inv_hom,\
        gens_in_freegrp, images_in_freegrp, preimages_in_freegrp;

  MealyAutomatonLocal:=function(g)
    local cur_state;
    if g!.word in states then return Position(states, g!.word); fi;
    Add(states,g!.word);
    cur_state := Length(states);
    aut_list[cur_state] := List([1..g!.deg], x -> MealyAutomatonLocal(Section(g, x)));
    Add(aut_list[cur_state], g!.perm);
    return cur_state;
  end;

  states := [];
  aut_list := [];
  gens := GeneratorsOfGroup(G);
  images := [];

  for g in gens do
    Add(images, MealyAutomatonLocal(g));
  od;


  H := AutomatonGroup(aut_list);
  SetUnderlyingAutomGroup(G, H);

  images := UnderlyingAutomFamily(H)!.oldstates{images};

# preimages of generators of G in UnderlyingFreeGroup(G)
  gens_in_freegrp := List(GeneratorsOfGroup(G), Word);

# preimages of generators of a subgroup of H isomorphic to G in UnderlyingFreeGroup(H)
  images_in_freegrp := List(GeneratorsOfGroup(H){images}, Word);

# preimages of generators of H in UnderlyingFreeGroup(G)
  preimages_in_freegrp := List([1..Length(GeneratorsOfGroup(H))], x->states[Position(UnderlyingAutomFamily(H)!.oldstates,x)]);


  free_groups_hom:=
     GroupHomomorphismByImagesNC( Group(gens_in_freegrp), UnderlyingFreeGroup(H),
                                  gens_in_freegrp, images_in_freegrp );

#  inv_free_groups_hom:=
#     GroupHomomorphismByImagesNC( Group(images_in_freegrp), Group(gens_in_freegrp),
#                                  images_in_freegrp, gens_in_freegrp );


  inv_free_groups_hom:=
     GroupHomomorphismByImagesNC( UnderlyingFreeGroup(H), UnderlyingFreeGroup(G),
                                  UnderlyingFreeGenerators(H), preimages_in_freegrp );


  if IsSelfSimilarGroup(G) then

    hom_function:=function(a)
      return Autom(Image(free_groups_hom,a!.word),UnderlyingAutomFamily(H));
    end;

    inv_hom_function:= function(b)
      return SelfSim(Image(inv_free_groups_hom,b!.word),UnderlyingSelfSimFamily(G));
    end;

    hom := GroupHomomorphismByFunction(G,Group(GeneratorsOfGroup(H){images}),hom_function, inv_hom_function);

    SetMonomorphismToAutomatonGroup(G, hom);
  fi;

  return true;
end);

###############################################################################
##
#M  UnderlyingAutomGroup( <G> )
##
InstallMethod(UnderlyingAutomGroup, "for [IsSelfSimGroup]",
              [IsSelfSimGroup],
function(G)
  if IsFiniteState(G) then return UnderlyingAutomGroup(G); fi;
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

  res:=IsContracting(GroupOfAutomFamily(UnderlyingAutomFamily(UnderlyingAutomGroup(G))));

  SetUseContraction(G,true);

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

  H:=GroupOfAutomFamily(UnderlyingAutomFamily(UnderlyingAutomGroup(G)));

  return List( GroupNucleus(H),x->PreImagesRepresentative(MonomorphismToAutomatonGroup(G), x));
end);


###############################################################################
##
#M  UseContraction( <G> )
##
InstallMethod(GroupNucleus, "for [IsSelfSimilarGroup]",
              [IsSelfSimilarGroup],
function(G)
  if HasGroupNucleus(G) then
    return true;
  else return false;
  fi;
end);


###############################################################################
##
#M  UseContraction( <G> )
##
InstallMethod(GroupNucleus, "for [IsSelfSimilarGroup]",
              [IsSelfSimilarGroup],
function(G)
  if HasGroupNucleus(G) then
    return true;
  else return false;
  fi;
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

  if not IsContracting(G) then
    Error("Group <G> is not contracting");
  fi;

  H:=GroupOfAutomFamily( UnderlyingAutomFamily( UnderlyingAutomGroup( G )));

  nuclH:=FindNucleus(H, max_nucl);

  if nuclH=fail then return fail; fi;

  nuclG:=[];
  Add(nuclG, List( GeneratingSetWithNucleus(H),x -> PreImagesRepresentative( MonomorphismToAutomatonGroup( G ), x )));
  Add(nuclG, List( GroupNucleus(H),x -> PreImagesRepresentative( MonomorphismToAutomatonGroup( G ), x )));
  Add(nuclG, GeneratingSetWithNucleusAutom(H));

  SetGroupNucleus(G, nuclG[1]);
  SetGeneratingSetWithNucleusAutom(G, nuclG[2]);
  SetGeneratingSetWithNucleusAutom(G, nuclG[3]);
  SetContractingLevel(G, ContractingLevel(H));

  return nuclG;
end);


InstallMethod(FindNucleus, "for [IsSelfSimilarGroup]", true,
              [IsSelfSimilarGroup],
function(G)
  return FindNucleus(G,infinity);
end);

#E
