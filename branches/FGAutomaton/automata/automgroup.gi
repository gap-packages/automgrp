#############################################################################
##
#W  automgroup.gi             automata package                 Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##

Revision.automgroup_gi :=
  "@(#)$Id$";


###############################################################################
##
#M  AutomGroup(<list>)
##
InstallMethod(AutomGroup, [IsList],
function (list)
  local fam, g;

  if not IsCorrectAutomatonList(list) then
    Print("error in AutomGroup(IsList):\n");
    Print("  given list is not a correct list representing automaton\n");
    return fail;
  fi;

  fam := AutomFamily(list);
  if fam = fail then return fail; fi;
  g := Group(fam!.automgens{[1..fam!.numstates]});
  SetUnderlyingAutomFamily(g, fam);
  return g;
end);


###############################################################################
##
#M  AutomGroup(<list>, <names>)
##
InstallOtherMethod(AutomGroup, [IsList, IsList],
function (list, names)
  local fam, g;

  if not IsCorrectAutomatonList(list) then
    Print("error in AutomGroup(IsList):\n");
    Print("  given list is not a correct list representing automaton\n");
    return fail;
  fi;

  fam := AutomFamily(list, names, AutomataParameters.identity_symbol);
  if fam = fail then return fail; fi;
  g := Group(fam!.automgens{[1..fam!.numstates]});
  SetUnderlyingAutomFamily(g, fam);
  return g;
end);


###############################################################################
##
#M  Degree(<G>)
##
InstallOtherMethod(Degree, [IsAutomGroup],
function(G)
  return Degree(UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  IsActingOnBinaryTree(<G>)
##
InstallMethod(IsActingOnBinaryTree, [IsAutomGroup],
function(G)
  return Degree(UnderlyingAutomFamily(G)) = 2;
end);


###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, [IsAutomGroup],
function(G)
  local i, gens;
  gens := GeneratorsOfGroup(G);
  if gens = [] then Print("< >"); fi;
  if Length(gens) = 1 then
    Print("< ", gens[1], " >\n");
  else
    Print("< ", gens[1], " \n");
    for i in [2..Length(gens)-1] do
      Print("  ", gens[i], ", \n");
    od;
    Print("  ", gens[Length(gens)], " >");
  fi;
end);


###############################################################################
##
#M  ViewObj(<G>)
##
InstallMethod(ViewObj, [IsAutomGroup],
function(G)
  local i, gens;
  gens := List(GeneratorsOfGroup(G), g -> Word(g));
  if gens = [] then Print("< >"); fi;
  Print("< ");
  for i in [1..Length(gens)-1] do
    Print(gens[i], ", ");
  od;
  Print(gens[Length(gens)], " >");
end);


###############################################################################
##
#M  StabilizerOfFirstLevel(G)
##
InstallMethod(StabilizerOfFirstLevel, [IsAutomGroup],
function (G)
  local freegens, S, F, hom, chooser, s, f, gens;

  if GeneratorsOfGroup(G) = [] then return G; fi;
  if Set( List(GeneratorsOfGroup(G), g -> Perm(g)) ) = [()] then
    return G;
  fi;

  freegens := List(GeneratorsOfGroup(G), a -> [a!.word, a!.perm]);
  S := Group(List(freegens, x -> x[2]));
  F := FreeGroup(Length(freegens));
  hom := GroupHomomorphismByImagesNC(F, S,
              GeneratorsOfGroup(F), List(freegens, x -> x[2]));
  gens := GeneratorsOfGroup(Kernel(hom));
  gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
  return SubgroupNC(G, gens);
end);


###############################################################################
##
#M  MihaylovSystem(G)
##
## TODO
InstallMethod(MihaylovSystem, [IsAutomGroup],
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
#M  StabilizerOfLevel(G, k)
##
InstallMethod(StabilizerOfLevel, [IsAutomGroup, IsInt],
function (G, k)
    local freegens, S, F, hom, chooser, s, f, gens;

##  TODO
##  if stabilizes the level then return G

    freegens := List(GeneratorsOfGroup(G), a -> [a!.word, Perm(a, k)]);
    S := Group(List(freegens, x -> x[2]));
    F := FreeGroup(Length(freegens));
    hom := GroupHomomorphismByImagesNC(F, S,
                GeneratorsOfGroup(F), List(freegens, x -> x[2]));
    gens := GeneratorsOfGroup(Kernel(hom));
    gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
    return SubgroupNC(G, gens);
end);


###############################################################################
##
#M  StabilizerOfVertex(G, k)
##
InstallMethod(StabilizerOfVertex, [IsAutomGroup, IsInt],
function (G, k)
    local X, S, F, hom, s, f, gens, stab, rt, map, canonreprs,
            action;

##  TODO
#     if G stabilizes k then return G; fi;

    X := List(G!.Gens, a -> [a!.word, a!.perm]);
    S := Group(List(X, x -> x[2]));
    F := FreeGroup(Length(X));
    hom := GroupHomomorphismByImagesNC(F, S,
                GeneratorsOfGroup(F), List(X, x -> x[2]));
    action := function(k, w)
        return k^Image(hom, w);
    end;
    gens := GeneratorsOfGroup(Stabilizer(F, k, action));
#     gens := Nielsen(gens)[1];
    gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
    return SubgroupNC(G, gens);
end);


###############################################################################
##
#M  StabilizerOfVertex(G, seq)
##
InstallOtherMethod(StabilizerOfVertex, [IsAutomGroup, IsList],
function (G, seq)
    local X, S, F, hom, s, f, gens, stab, rt, map, canonreprs,
            action, i, v;

##  TODO
#     if G stabilizes k then return G; fi;

    if Length(seq) = 0 then
      Error("StabilizerOfVertex(IsAutomGroup, IsList): don't want to stabilize root vertex\n");
    fi;
    for i in [1..Length(seq)] do
      if not seq[i] in [1..GeneratorsOfGroup(G)[1]!.deg] then
        Error("StabilizerOfVertex(IsAutomGroup, IsList): list is not valid vertex\n");
      fi;
    od;

    v := Position(AsList(Tuples([1..Degree(G)], Length(seq))), seq);

    X := List(G!.Gens, a -> [a!.Word, Perm(a, Length(seq))]);
    S := Group(List(X, x -> x[2]));
    F := FreeGroup(Length(X));
    hom := GroupHomomorphismByImagesNC(F, S,
                GeneratorsOfGroup(F), List(X, x -> x[2]));
    action := function(k, w)
        return k^Image(hom, w);
    end;
    gens := GeneratorsOfGroup(Stabilizer(F, v, action));
#     gens := Nielsen(gens)[1];
    gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
    return SubgroupNC(G, gens);
end);


###############################################################################
##
InstallTrueMethod(IsFractal, IsFractalByWords);
InstallTrueMethod(IsSphericallyTransitive, IsFractal);
InstallTrueMethod(CanEasilyTestSphericalTransitivity, HasIsSphericallyTransitive);
InstallTrueMethod(CanEasilyTestFractalness, HasIsFractal);
InstallTrueMethod(CanEasilyTestSelfSimilarity, HasIsSelfSimilar);
InstallTrueMethod(CanEasilyTestBeingFreeNonabelian, HasIsFreeNonabelian);
InstallTrueMethod(CanEasilyTestBeingFreeNonabelian, IsAbelian);
InstallTrueMethod(CanEasilyTestBeingFreeNonabelian, IsFinite);
InstallTrueMethod(CanEasilyTestBeingFreeAbelian, HasIsFreeAbelian);
InstallTrueMethod(CanEasilyTestBeingFreeAbelian, IsFinite);
InstallTrueMethod(CanEasilyComputeSize, IsFractal);
InstallTrueMethod(CanEasilyComputeSize, IsSphericallyTransitive);
InstallTrueMethod(CanEasilyComputeSize, IsFreeAbelian);
InstallTrueMethod(CanEasilyComputeSize, IsFreeNonabelian);


###############################################################################
##
#M  IsFractalByWords(G)
##
InstallMethod(IsFractalByWords, [IsAutomGroup],
function (G)
  local freegens, stab, i, proj, sym;

  sym := Group(List(GeneratorsOfGroup(G), g -> Perm(g)));
  if not IsTransitive(sym, [1..Degree(G)]) then
    Info(InfoAutomata, 1, "group is not transitive on first level");
    return false;
  fi;

  freegens := List(GeneratorsOfGroup(G), g -> Word(g));
  freegens := Difference(Nielsen(freegens)[1], [One(freegens[1])]);
  stab := StabilizerOfFirstLevel(G);
  stab := List(GeneratorsOfGroup(stab), a -> StatesWords(a));
  for i in [1..Degree(G)] do
    proj := List(stab, s -> s[i]);
    if Difference(Nielsen(proj)[1], [One(proj[1])]) <> freegens then
      return false;
    fi;
  od;

  return true;
end);


###############################################################################
##
#M  IsFractal(G)
##
InstallMethod(IsFractal, [IsAutomGroup],
function (G)
  if CanEasilyComputeSize(G) then
    if Size(G) < infinity then
      return false; fi; fi;

  if CanEasilyTestSphericalTransitivity(G) then
    if not IsSphericallyTransitive(G) then
      return false; fi; fi;

  if IsFractalByWords(G) then
    return true; fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsFreeNonabelian(G)
##
InstallMethod(IsFreeNonabelian, [IsAutomGroup],
function (G)
  if IsTrivial(G) then
    return false; fi;

  if IsAbelian(G) then
    return false; fi;

  if CanEasilyComputeSize(G) then
    if IsFinite(G) then
      return false; fi; fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsFreeAbelian(G)
##
InstallMethod(IsFreeAbelian, [IsAutomGroup],
function (G)
  if IsTrivial(G) then
    return false; fi;

  if not IsAbelian(G) then
    return false; fi;

  if CanEasilyComputeSize(G) then
    if IsFinite(G) then
      return false; fi; fi;

  TryNextMethod();
end);


###############################################################################
##
#M  Size(G)
##
InstallMethod(Size, [IsAutomGroup],
function (G)
  if IsTrivial(G) then
    return 1; fi;

  if CanEasilyTestSphericalTransitivity(G) then
    if IsSphericallyTransitive(G) then
      return infinity; fi; fi;

  if IsFractalByWords(G) then
    return infinity; fi;

  if CanEasilyTestFractalness(G) then
    if IsFractal(G) then
      return infinity; fi; fi;

  if CanEasilyTestBeingFreeNonabelian(G) then
    if IsFreeNonabelian(G) then
      return infinity; fi; fi;

  if CanEasilyTestBeingFreeAbelian(G) then
    if IsFreeAbelian(G) then
      return infinity; fi; fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsSphericallyTransitive(G)
##
InstallMethod(IsSphericallyTransitive, [IsAutomGroup],
function (G)
  local x, rat_gens, abel_hom;

  if IsTrivial(G) then
    return false; fi;

  if CanEasilyComputeSize(G) then
    if IsFinite(G) then
      return false; fi; fi;

  if IsActingOnBinaryTree(G) then
  fi;

  TryNextMethod();
end);


#E
