#############################################################################
##
#W  treeautgrp.gi              automata package                Yevgen Muntyan
#W                                                              Dmytro Sachuk
##
##  automata v 0.91 started June 07 2004
##

Revision.treeautgrp_gi :=
  "@(#)$Id$";


###############################################################################
##
#M  TreeAutomorphismGroup(<G>, <S>)
##
##  Wreath product
##
InstallOtherMethod(TreeAutomorphismGroup, [IsTreeAutomorphismGroup, IsSymmetricGroup],
function(G, S)
  local g_gens, s_gens, g_deg, s_deg, orbs, o, gens;
  s_deg := Maximum(MovedPointsPerms(S));
  g_deg := DegreeOfTree(G);
  gens := List(GeneratorsOfGroup(S), s -> [List([1..s_deg], i->One(G)), s]);
  Append(gens, List(GeneratorsOfGroup(G), g ->
                [Concatenation([g], List([2..s_deg], i->One(g))), ()]));
  Apply(gens, g -> TreeAutomorphism(g[1], g[2]));
  return GroupWithGenerators(gens);
end);


###############################################################################
##
#M  UseSubsetRelation(<super>, <sub>)
##
InstallMethod(UseSubsetRelation, "method for two IsTreeAutomorphismGroup's",
              [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup],
function(super, sub)
  if HasIsFreeAbelian(super) then
    if IsFreeAbelian(super) then
      if not IsTrivial(sub) then SetIsFreeAbelian(sub, true); fi;
    else
      SetIsFreeAbelian(sub, false);
    fi;
  fi;

  if HasIsFreeNonabelian(super) then
    if IsFreeNonabelian(super) then
      if not IsTrivial(sub) then SetIsFreeNonabelian(sub, true); fi;
    else
      SetIsFreeNonabelian(sub, false);
    fi;
  fi;

  if HasIsSphericallyTransitive(super) then
    if not IsSphericallyTransitive(super) then
      SetIsSphericallyTransitive(sub, false); fi; fi;

  TryNextMethod();
end);


###############################################################################
##
#M  SphericalIndex(<G>)
##
InstallMethod(SphericalIndex, "method for IsTreeAutomorphismGroup",
              [IsTreeAutomorphismGroup],
function(G)
  return SphericalIndex(GeneratorsOfGroup(G)[1]);
end);


###############################################################################
##
#M  IsSphericallyTransitive (<G>)
#M  CanEasilyTestSphericalTransitivity (<G>)
##
##  Fractalness implies spherical transitivity.
##
InstallTrueMethod(IsSphericallyTransitive, IsFractal);
InstallTrueMethod(CanEasilyTestSphericalTransitivity, HasIsSphericallyTransitive);

InstallImmediateMethod(IsSphericallyTransitive, IsTreeAutomorphismGroup and HasIsFinite, 0,
function(G)
  if IsFinite(G) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is finite");
    return false;
  fi;
  TryNextMethod();
end);

InstallMethod(IsSphericallyTransitive, [IsTreeAutomorphismGroup and IsActingOnBinaryTree],
function(G)
  if AutomataAbelImageSpherTrans in AbelImage(G) then return true; fi;
  TryNextMethod();
end);

RedispatchOnCondition(IsSphericallyTransitive, true, [IsTreeAutomorphismGroup],
                      [IsTreeAutomorphismGroup and IsActingOnBinaryTree], 0);

InstallMethod(IsSphericallyTransitive, "IsSphericallyTransitive(IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup],
function (G)
  if CanEasilyComputeSize(G) and Size(G) < infinity then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is finite");
    return false;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  AbelImage (<G>)
##
InstallMethod(AbelImage, [IsTreeAutomorphismGroup],
function(G)
  local ab, gens, abgens;

  abgens := List(GeneratorsOfGroup(G), g -> AbelImage(g));
  return AdditiveGroup(abgens);
end);


###############################################################################
##
#M  IsFractal (<G>)
#M  CanEasilyTestFractalness (<G>)
##
##  Fractalness implies spherical transitivity, hence not spherical transitive
##  group isn't fractal.
##
InstallTrueMethod(CanEasilyTestFractalness, HasIsFractal);

InstallImmediateMethod(IsFractal, HasIsSphericallyTransitive, 0,
function(G)
  if not IsSphericallyTransitive(G) then return false; fi;
  TryNextMethod();
end);

InstallImmediateMethod(IsFractal, IsTreeAutomorphismGroup and HasIsFinite, 0,
function(G)
  if IsFinite(G) then return false; fi;
  TryNextMethod();
end);

InstallMethod(IsFractal, "IsFractal(IsTreeAutomorphismGroup)", [IsTreeAutomorphismGroup],
function(G)
  local i;

  if not IsTransitive(PermGroupOnLevel(G, 1), [1..DegreeOfTree(G)]) then
    SetIsSphericallyTransitive(G, false);
    Info(InfoAutomata, 3, "IsFractal(G): false");
    Info(InfoAutomata, 3, "  G is not transitive on first level");
    return false;
  fi;

  if CanEasilyComputeSize(G) and Size(G) < infinity then
    Info(InfoAutomata, 3, "IsFractal(G): false");
    Info(InfoAutomata, 3, "  G is finite");
    return false;
  fi;

  if CanEasilyTestSphericalTransitivity(G) and not IsSphericallyTransitive(G) then
    Info(InfoAutomata, 3, "IsFractal(G): false");
    Info(InfoAutomata, 3, "  G is not spherically transitive");
    return false;
  fi;

  if ProjStab(G, 1) <> G then
    Info(InfoAutomata, 3, "IsFractal(G): false");
    Info(InfoAutomata, 3, "  ProjStab(G, 1) <> G");
    return false;
  fi;
  Info(InfoAutomata, 3, "IsFractal(G): true");
  Info(InfoAutomata, 3, "  ProjStab(G, 1) = G and G is transitive on first level");
  return true;
end);


###############################################################################
##
#M  CanEasilyTestSelfSimilarity (<G>)
##
InstallTrueMethod(CanEasilyTestSelfSimilarity, HasIsSelfSimilar);


###############################################################################
##
#M  IsFreeNonabelian (<G>)
#M  CanEasilyTestBeingFreeNonabelian (<G>)
##
InstallTrueMethod(CanEasilyTestBeingFreeNonabelian, HasIsFreeNonabelian);
InstallTrueMethod(CanEasilyTestBeingFreeNonabelian, IsTrivial);

InstallImmediateMethod(IsFreeNonabelian, IsTreeAutomorphismGroup and HasIsAbelian, 0,
function(G)
  if IsAbelian(G) then return false; fi;
  TryNextMethod();
end);

InstallImmediateMethod(IsFreeNonabelian, IsTreeAutomorphismGroup and HasIsFinite, 0,
function(G)
  if IsFinite(G) then return false; fi;
  TryNextMethod();
end);


###############################################################################
##
#M  IsFreeNonabelian(G)
##
InstallMethod(IsFreeNonabelian, "IsFreeNonabelian(IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup],
function (G)
  if IsTrivial(G) then
    Info(InfoAutomata, 3, "IsFreeNonabelian(G): false");
    Info(InfoAutomata, 3, "  G is trivial");
    return false;
  fi;

  if IsAbelian(G) then
    Info(InfoAutomata, 3, "IsFreeNonabelian(G): false");
    Info(InfoAutomata, 3, "  G is abelian");
    return false;
  fi;

  if CanEasilyComputeSize(G) and Size(G) < infinity then
    Info(InfoAutomata, 3, "IsFreeNonabelian(G): false");
    Info(InfoAutomata, 3, "  Size(G) < infinity");
    return false;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsFreeAbelian (<G>)
#M  CanEasilyTestBeingFreeAbelian (<G>)
##
InstallTrueMethod(CanEasilyTestBeingFreeAbelian, HasIsFreeAbelian);
InstallTrueMethod(CanEasilyTestBeingFreeAbelian, IsTrivial);

InstallImmediateMethod(IsFreeAbelian, IsTreeAutomorphismGroup and HasIsAbelian, 0,
function(G)
  if not IsAbelian(G) then return false; fi;
  TryNextMethod();
end);

InstallImmediateMethod(IsFreeAbelian, IsTreeAutomorphismGroup and HasIsFinite, 0,
function(G)
  if IsFinite(G) then return false; fi;
  TryNextMethod();
end);

InstallMethod(IsFreeAbelian, "IsFreeAbelian(IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup],
function (G)
  if IsTrivial(G) then
    Info(InfoAutomata, 3, "IsFreeAbelian(G): false");
    Info(InfoAutomata, 3, "  G is trivial");
    return false;
  fi;

  if not IsAbelian(G) then
    Info(InfoAutomata, 3, "IsFreeAbelian(G): false");
    Info(InfoAutomata, 3, "  G is not abelian");
    return false;
  fi;

  if CanEasilyComputeSize(G) and Size(G) < infinity then
    Info(InfoAutomata, 3, "IsFreeAbelian(G): false");
    Info(InfoAutomata, 3, "  Size(G) < infinity");
    return false;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  Size (<G>)
#M  CanEasilyComputeSize (<G>)
##
InstallTrueMethod(CanEasilyComputeSize, HasSize);

InstallImmediateMethod(Size, HasIsFractal, 0,
function(G)
  if IsFractal(G) then return infinity; fi;
  TryNextMethod();
end);

InstallImmediateMethod(Size, HasIsSphericallyTransitive, 0,
function(G)
  if IsSphericallyTransitive(G) then return infinity; fi;
  TryNextMethod();
end);

InstallImmediateMethod(Size, HasIsFreeAbelian, 0,
function(G)
  if IsFreeAbelian(G) then return infinity; fi;
  TryNextMethod();
end);

InstallImmediateMethod(Size, HasIsFreeNonabelian, 0,
function(G)
  if IsFreeNonabelian(G) then return infinity; fi;
  TryNextMethod();
end);


###############################################################################
##
#M  PermGroupOnLevelOp (<G>, <k>)
##
InstallMethod(PermGroupOnLevelOp, "method for IsTreeAutomorphismGroup and IsPosInt",
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  local gens, a, pgens, pgroup;
  gens := GeneratorsOfGroup(G);
  if gens = [] then return Group(()); fi;
  pgens := [];
  for a in gens do
    Add(pgens, PermOnLevel(a, k));
  od;
  pgroup := Group(pgens);

  if IsActingOnBinaryTree(G) then
    SetIsPGroup(pgroup, true);
    if IsTrivial(pgroup) then
      SetPrimePGroup(pgroup, fail);
    else
      SetPrimePGroup(pgroup, 2);
    fi;
  fi;

  return pgroup;
end);


###############################################################################
##
#M  StabilizerOfFirstLevel(G)
##
InstallMethod(StabilizerOfFirstLevel,
              "StabilizerOfFirstLevel(IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup],
function (G)
  return StabilizerOfLevel(G, 1);
end);


###############################################################################
##
#M  StabilizerOfLevelOp(G, k)
##
InstallMethod(StabilizerOfLevelOp,
              "StabilizerOfLevelOp(IsTreeAutomorphismGroup, IsPosInt)",
              [IsTreeAutomorphismGroup, IsPosInt],
function (G, k)
  local perms, S, F, hom, chooser, s, f, gens;

  if FixesLevel(G, k) then
    SetIsSphericallyTransitive(G, false);
    return G;
  fi;

  perms := List(GeneratorsOfGroup(G), a -> PermOnLevel(a, k));
  S := GroupWithGenerators(perms);
  F := FreeGroup(Length(perms));
  hom := GroupHomomorphismByImagesNC(F, S, GeneratorsOfGroup(F), perms);
  gens := GeneratorsOfGroup(Kernel(hom));
  gens := List(gens, w ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := Difference(gens, [One(gens[1])]);
  if IsEmpty(gens) then
    return TrivialSubgroup(G);
  else
    return SubgroupNC(G, gens);
  fi;
end);


###############################################################################
##
#M  StabilizerOfVertex(G, k)
##
InstallOtherMethod( StabilizerOfVertex,
                    "StabilizerOfVertex(IsTreeAutomorphismGroup, IsPosInt)",
                    [IsTreeAutomorphismGroup, IsPosInt],
function (G, k)
  local X, S, F, hom, s, f, gens, i, action;

  if k > TopDegreeOfTree(G) then
    Print("error in StabilizerOfVertex(IsTreeAutomorphismGroup, IsPosInt):\n");
    Print("  given k is not a valid vertex\n");
    return fail;
  fi;
  if FixesVertex(G, k) then
    SetIsSphericallyTransitive(G, false);
    return G;
  fi;
  if TopDegreeOfTree(G) = 2 then
    return StabilizerOfFirstLevel(G);
  fi;

  X := List(GeneratorsOfGroup(G), a -> Perm(a));
  S := GroupWithGenerators(X);
  F := FreeGroup(Length(X));
  hom := GroupHomomorphismByImagesNC(F, S,
              GeneratorsOfGroup(F), X);
  action := function(k, w)
      return k^Image(hom, w);
  end;
  gens := GeneratorsOfGroup(Stabilizer(F, k, action));
  gens := List(gens, w ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := Difference(gens, [One(gens[1])]);
  if IsEmpty(gens) then
    return TrivialSubgroup(G);
  else
    return SubgroupNC(G, gens);
  fi;
end);


###############################################################################
##
#M  StabilizerOfVertex(G, seq)
##
InstallMethod(StabilizerOfVertex,
              "StabilizerOfVertex(IsTreeAutomorphismGroup, IsList)",
              [IsTreeAutomorphismGroup, IsList],
function (G, seq)
  local X, S, F, hom, s, f, gens, stab, action, i, v;

  if Length(seq) = 0 then return G; fi;
  if TopDegreeOfTree(G) = 2 and Length(seq) = 1 then
    return StabilizerOfFirstLevel(G);
  fi;
  if FixesVertex(G, seq) then
    SetIsSphericallyTransitive(G, false);
    return G;
  fi;

  v := Position(AsList(Tuples([1..DegreeOfTree(G)], Length(seq))), seq);

  X := List(GeneratorsOfGroup(G), a -> [Word(a), PermOnLevel(a, Length(seq))]);
  S := Group(List(X, x -> x[2]));
  F := FreeGroup(Length(X));
  hom := GroupHomomorphismByImagesNC(F, S,
              GeneratorsOfGroup(F), List(X, x -> x[2]));
  action := function(k, w)
      return k^Image(hom, w);
  end;
  gens := GeneratorsOfGroup(Stabilizer(F, v, action));
  gens := Difference(gens, [One(gens[1])]);
  gens := List(gens, w ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  if IsEmpty(gens) then
    return TrivialSubgroup(G);
  else
    return SubgroupNC(G, gens);
  fi;
end);


###############################################################################
##
#M  FixesLevel(<G>, <k>)
##
InstallMethod(FixesLevel, "method for IsTreeAutomorphismGroup and IsPosInt",
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  if IsTrivial(PermGroupOnLevel(G, k)) then
    SetIsSphericallyTransitive(G, false);
    return true;
  else
    return false;
  fi;
end);


###############################################################################
##
#M  FixesVertex(<G>, <v>)
##
InstallOtherMethod(FixesVertex, "method for IsTreeAutomorphismGroup and IsPosInt",
                   [IsTreeAutomorphismGroup, IsObject],
function(G, v)
  local gens, g;
  gens := GeneratorsOfGroup(G);
  for g in gens do
    if not FixesVertex(g, v) then return false; fi;
  od;
  SetIsSphericallyTransitive(G, false);
  return true;
end);


###############################################################################
##
#M  ProjectionOp (<G>, <k>)
##
InstallMethod(ProjectionOp, "ProjectionOp(IsTreeAutomorphismGroup, IsPosInt)",
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  local gens, pgens;

  if k > TopDegreeOfTree(G) then return fail; fi;
  if not FixesVertex(G, k) then return fail; fi;

  gens := GeneratorsOfGroup(G);
  pgens := List(gens, g -> State(g, k));
  return Group(pgens);
end);


###############################################################################
##
#M  Projection (<G>, <v>)
##
InstallOtherMethod(Projection, "Projection(IsTreeAutomorphismGroup, IsList)",
                   [IsTreeAutomorphismGroup, IsList],
function(G, v)
  local gens, pgens;

  if not FixesVertex(G, v) then return fail; fi;

  gens := GeneratorsOfGroup(G);
  pgens := List(gens, g -> State(g, v));
  return Group(pgens);
end);


###############################################################################
##
#M  ProjStab (<G>, <v>)
##
InstallMethod(ProjStab, "ProjStab(IsTreeAutomorphismGroup, IsObject)",
              [IsTreeAutomorphismGroup, IsObject],
function(G, k)
  return Projection(StabilizerOfVertex(G, k), k);
end);


###############################################################################
##
#M  \= (<G>, <H>)
##
InstallMethod(\=, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup],
function(G, H)
  if HasIsFinite(G) and HasIsFinite(H) and
    IsFinite(G) <> IsFinite(H) then
      Info(InfoAutomata, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
      Info(InfoAutomata, 3, "  IsFinite(G)<>IsFinite(H)");
      return false;
  fi;

  if HasSize(G) and HasSize(H) and
    Size(G) <> Size(H) then
      Info(InfoAutomata, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
      Info(InfoAutomata, 3, "  Size(G)<>Size(H)");
      return false;
  fi;

  if CanEasilyTestSphericalTransitivity(G) and
    CanEasilyTestSphericalTransitivity(H) and
      IsSphericallyTransitive(G) <> IsSphericallyTransitive(H) then
        Info(InfoAutomata, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
        Info(InfoAutomata, 3, "  IsSphericallyTransitive(G) <> IsSphericallyTransitive(H)");
        return false;
  fi;

  if CanEasilyTestFractalness(G) and
    CanEasilyTestFractalness(H) and
      IsFractal(G) <> IsFractal(H) then
        Info(InfoAutomata, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
        Info(InfoAutomata, 3, "  IsFractal(G) <> IsFractal(H)");
        return false;
  fi;

  return IsSubgroup(G, H) and IsSubgroup(H, G);
end);


###############################################################################
##
#M  IsSubset (<G>, <H>)
##
InstallMethod(IsSubset, "IsSubgroup(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup],
function(G, H)
  local h, gens;

  if IsTrivial(H) then
    Info(InfoAutomata, 3, "IsSubset(G, H): true");
    Info(InfoAutomata, 3, "  IsTrivial(H)");
    return true;
  elif IsTrivial(G) then
    Info(InfoAutomata, 3, "IsSubset(G, H): false");
    Info(InfoAutomata, 3, "  not IsTrivial(H) and IsTrivial(G)");
    return false;
  fi;

  if HasIsFinite(G) and HasIsFinite(H) and
    IsFinite(G) and not IsFinite(H) then
      Info(InfoAutomata, 3, "IsSubset(G, H): false");
      Info(InfoAutomata, 3, "  IsFinite(G) and not IsFinite(H)");
      return false;
  fi;

  if HasSize(G) and HasSize(H) and
    Size(G) < Size(H) then
      Info(InfoAutomata, 3, "IsSubset(G, H): false");
      Info(InfoAutomata, 3, "  Size(G) < Size(H)");
      return false;
  fi;

  if  CanEasilyTestSphericalTransitivity(G) and
      CanEasilyTestSphericalTransitivity(H) and
      not IsSphericallyTransitive(G) and
      IsSphericallyTransitive(H)
  then
    Info(InfoAutomata, 3, "IsSubset(G, H): false");
    Info(InfoAutomata, 3, "  not IsSphericallyTransitive(G) and IsSphericallyTransitive(H)");
    return false;
  fi;

  gens := GeneratorsOfGroup(H);
  for h in gens do
    if not h in G then
      Info(InfoAutomata, 3, "IsSubset(G, H): false");
      Info(InfoAutomata, 3, "  not h in G");
      return false;
    fi;
  od;
  return true;
end);


###############################################################################
##
#M  <g> in <G>)
##
InstallMethod(\in, "\in(IsTreeAutomorphism, IsTreeAutomorphismGroup)",
              [IsTreeAutomorphism, IsTreeAutomorphismGroup],
function(g, G)
  local i;

  if IsOne(g) then return true;
  elif IsTrivial(G) then return false; fi;

  if CanEasilyTestSphericalTransitivity(G) and
    CanEasilyTestSphericalTransitivity(g) and
      not IsSphericallyTransitive(G) and
        IsSphericallyTransitive(g)
  then
    Info(InfoAutomata, 3, "g in G: false");
    Info(InfoAutomata, 3, "  not IsSphericallyTransitive(G) and IsSphericallyTransitive(g)");
    return false;
  fi;

  if not AbelImage(g) in AbelImage(G) then
    Info(InfoAutomata, 3, "g in G: false");
    Info(InfoAutomata, 3, "  not AbelImage(g) in AbelImage(G)");
    return false;
  fi;

#TODO
  for i in [1..10] do
    if not PermOnLevel(g, i) in PermGroupOnLevel(G, i) then
      return false;
    fi;
  od;

  TryNextMethod();
end);


#E
