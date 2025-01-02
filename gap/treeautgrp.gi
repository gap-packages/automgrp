#############################################################################
##
#W  treeautgrp.gi              automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


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
  gens := List(GeneratorsOfGroup(S), s -> [List([1..s_deg], i -> One(G)), s]);
  Append(gens, List(GeneratorsOfGroup(G), g ->
                [Concatenation([g], List([2..s_deg], i -> One(g))), ()]));
  Apply(gens, g -> TreeAutomorphism(g[1], g[2]));
  return GroupWithGenerators(gens);
end);


###############################################################################
##
#M  UseSubsetRelation(<super>, <sub>)
##
InstallMethod(UseSubsetRelation, "for [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup],
function(super, sub)
  if HasIsSphericallyTransitive(super) then
    if not IsSphericallyTransitive(super) then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(sub): false");
      Info(InfoAutomGrp, 3, "  super is not spherically transitive");
      Info(InfoAutomGrp, 3, "  super = ", super);
      Info(InfoAutomGrp, 3, "  sub = ", sub);
      SetIsSphericallyTransitive(sub, false); fi; fi;

  TryNextMethod();
end);


###############################################################################
##
#M  SphericalIndex(<G>)
##
InstallMethod(SphericalIndex, "for [IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup],
function(G)
  return SphericalIndex(GeneratorsOfGroup(G)[1]);
end);
InstallMethod(TopDegreeOfTree, "for [IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup],
function(G)
  return TopDegreeOfTree(GeneratorsOfGroup(G)[1]);
end);
InstallMethod(DegreeOfTree, "for [IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup],
function(G)
  return DegreeOfTree(GeneratorsOfGroup(G)[1]);
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
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G is finite");
    Info(InfoAutomGrp, 3, "  G = ", G);
    return false;
  fi;
  TryNextMethod();
end);

InstallMethod(IsSphericallyTransitive, "for [IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup],
function (G)
  local i, k, stab;

  if DegreeOfTree(G)=1 then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
    Info(InfoAutomGrp, 3, "  G acts on 1-ary tree");
    return true;
  fi;


  if HasIsFinite(G) and IsFinite(G) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G is finite");
    Info(InfoAutomGrp, 3, "  G = ", G);
    return false;
  fi;

  if not IsTransitiveOnLevel(G, 1) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G is not transitive on ", i, "-th level");
    Info(InfoAutomGrp, 3, "  G = ", G);
    return false;
  fi;

  if IsActingOnBinaryTree(G) then
    if AG_AbelImageSpherTrans() in AbelImage(G) then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomGrp, 3, "  using AbelImage");
      Info(InfoAutomGrp, 3, "  G = ", G);
      return true;
    fi;
  fi;

  if not IsAutomGroup(G) then
    stab := StabilizerOfVertex(G, 1);
    return IsSphericallyTransitive(Projection(stab, 1));
  fi;

#  TryNextMethod();
  return fail;
end);


###############################################################################
##
#M  IsTransitiveOnLevel (<G>, <k>)
##
InstallMethod(IsTransitiveOnLevel, [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  return IsTransitive(G, AG_TreeLevelTuples(SphericalIndex(G), k));
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
##
##  Fractalness implies spherical transitivity, hence not spherical transitive
##  group isn't fractal.
##
InstallImmediateMethod(IsFractal, HasIsSphericallyTransitive, 0,
function(G)
  if not IsSphericallyTransitive(G) then return false; fi;
  TryNextMethod();
end);

InstallImmediateMethod(IsFractal, IsTreeAutomorphismGroup and HasIsFinite, 0,
function(G)
  if IsFinite(G) and DegreeOfTree(G)>1 then return false; fi;
  TryNextMethod();
end);

InstallMethod(IsFractal, "for [IsTreeAutomorphismGroup]", [IsTreeAutomorphismGroup],
function(G)
  local i;

  if DegreeOfTree(G)=1 then
    SetIsSphericallyTransitive(G, true);
    Info(InfoAutomGrp, 3, "IsFractal(G): true");
    Info(InfoAutomGrp, 3, "  G acts on 1-ary tree");
    return true;
  fi;


  if not IsTransitive(PermGroupOnLevel(G, 1), [1..DegreeOfTree(G)]) then
    SetIsSphericallyTransitive(G, false);
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "IsFractal(G): false");
    Info(InfoAutomGrp, 3, "  G is not transitive on first level");
    return false;
  fi;

  if HasIsFinite(G) and IsFinite(G) then
    Info(InfoAutomGrp, 3, "IsFractal(G): false");
    Info(InfoAutomGrp, 3, "  G is finite");
    return false;
  fi;

  if CanEasilyTestSphericalTransitivity(G) and not IsSphericallyTransitive(G) then
    Info(InfoAutomGrp, 3, "IsFractal(G): false");
    Info(InfoAutomGrp, 3, "  G is not spherically transitive");
    return false;
  fi;

  if ProjStab(G, 1) <> G then
    Info(InfoAutomGrp, 3, "IsFractal(G): false");
    Info(InfoAutomGrp, 3, "  ProjStab(G, 1) <> G");
    return false;
  fi;
  Info(InfoAutomGrp, 3, "IsFractal(G): true");
  Info(InfoAutomGrp, 3, "  ProjStab(G, 1) = G and G is transitive on first level");
  return true;
end);


###############################################################################
##
#M  Size (<G>)
##
InstallImmediateMethod(Size, HasIsFractal, 0,
function(G)
  if IsFractal(G) and DegreeOfTree(G)>1 then return infinity; fi;
  TryNextMethod();
end);

InstallImmediateMethod(Size, HasIsSphericallyTransitive, 0,
function(G)
  if IsSphericallyTransitive(G) and DegreeOfTree(G)>1 then return infinity; fi;
  TryNextMethod();
end);


###############################################################################
##
#M  PermGroupOnLevelOp (<G>, <k>)
##
InstallMethod(PermGroupOnLevelOp, "for [IsTreeAutomorphismGroup, IsPosInt]",
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  local pgens, pgroup;

  pgens := List(GeneratorsOfGroup(G), g -> PermOnLevel(g, k));
  if pgens = [] then
    return Group(());
  else
    pgroup := GroupWithGenerators(pgens);
    if IsActingOnBinaryTree(G) then
      SetIsPGroup(pgroup, true);
      if IsTrivial(pgroup) then
        SetPrimePGroup(pgroup, fail);
      else
        SetPrimePGroup(pgroup, 2);
      fi;
    fi;
    return pgroup;
  fi;
end);


###############################################################################
##
#M  StabilizerOfFirstLevel(G)
##
InstallMethod(StabilizerOfFirstLevel,
              "for [IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup],
function (G)
  return StabilizerOfLevel(G, 1);
end);


###############################################################################
##
#M  StabilizerOfLevelOp(G, k)
##
InstallMethod(StabilizerOfLevelOp,
              "for [IsTreeAutomorphismGroup, IsPosInt]",
              [IsTreeAutomorphismGroup, IsPosInt],
function (G, k)
  local perms, S, F, hom, chooser, s, f, gens;

  if DegreeOfTree(G)=1 then
    return G;
  fi;

  if FixesLevel(G, k) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G is not transitive on level", k);
    Info(InfoAutomGrp, 3, "  G = ", G);
    SetIsSphericallyTransitive(G, false);
    return G;
  fi;

  perms := List(GeneratorsOfGroup(G), a -> PermOnLevel(a, k));
  S := GroupWithGenerators(perms);
  F := FreeGroup(Length(perms));
  hom := GroupHomomorphismByImagesNC(F, S, GeneratorsOfGroup(F), perms);
  gens := FreeGeneratorsOfGroup(Kernel(hom));
  gens := List(gens, w  ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := __AG_SimplifyGroupGenerators(gens);
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
InstallMethod(StabilizerOfVertex,
              "for [IsTreeAutomorphismGroup, IsPosInt]",
              [IsTreeAutomorphismGroup, IsPosInt],
function (G, k)
  local X, S, F, hom, s, f, gens, i, action;

  if k > TopDegreeOfTree(G) then
    Print("error in StabilizerOfVertex(IsTreeAutomorphismGroup, IsPosInt):\n");
    Print("  given k is not a valid vertex\n");
    return fail;
  fi;
  if FixesVertex(G, k) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G fixes vertex", k);
    Info(InfoAutomGrp, 3, "  G = ", G);
    Info(InfoAutomGrp, 3, "  k = ", k);
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
  gens := FreeGeneratorsOfGroup(Stabilizer(F, k, action));
  gens := List(gens, w  ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := __AG_SimplifyGroupGenerators(gens);
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
              "for [IsTreeAutomorphismGroup, IsList]",
              [IsTreeAutomorphismGroup, IsList],
function (G, seq)
  local X, S, F, hom, s, f, gens, stab, action, i, v;

  if Length(seq) = 0 then
    return G;
  fi;

  if TopDegreeOfTree(G) = 2 and Length(seq) = 1 then
    return StabilizerOfFirstLevel(G);
  fi;

  if FixesVertex(G, seq) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G fixes vertex", seq);
    Info(InfoAutomGrp, 3, "  G = ", G);
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
  gens := FreeGeneratorsOfGroup(Stabilizer(F, v, action));
  gens := List(gens, w  ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := __AG_SimplifyGroupGenerators(gens);
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
InstallMethod(FixesLevel, "for [IsTreeAutomorphismGroup, IsPosInt]",
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  if IsTrivial(PermGroupOnLevel(G, k)) then
    if DegreeOfTree(G)>1 then
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
      SetIsSphericallyTransitive(G, false);
    fi;
    Info(InfoAutomGrp, 3, "  G fixes level", k);
    Info(InfoAutomGrp, 3, "  G = ", G);
    return true;
  else
    return false;
  fi;
end);


###############################################################################
##
#M  FixesVertex(<G>, <v>)
##
InstallMethod(FixesVertex, "for [IsTreeAutomorphismGroup, IsPosInt]",
              [IsTreeAutomorphismGroup, IsObject],
function(G, v)
  local gens, g;
  gens := GeneratorsOfGroup(G);
  for g in gens do
    if not FixesVertex(g, v) then return false; fi;
  od;
  if DegreeOfTree(G)>1 then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomGrp, 3, "  G fixes vertex", v);
    Info(InfoAutomGrp, 3, "  G = ", G);
    SetIsSphericallyTransitive(G, false);
  fi;
  return true;
end);


###############################################################################
##
#M  Projection(<G>, <k>)
##
InstallMethod(Projection, "for [IsTreeAutomorphismGroup, IsPosInt]",
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  if not IsBound(G!.projections) then
    G!.projections := [];
  fi;
  if not IsBound(G!.projections[k]) then
    G!.projections[k] := Projection(G, [k]);
  fi;
  return G!.projections[k];
end);


# TODO: check whether gens are from the same overgroup;
# check degree of tree and stuff
InstallMethod(__AG_SubgroupOnLevel, [IsTreeAutomorphismGroup,
                                    IsList and IsTreeAutomorphismCollection,
                                    IsPosInt],
function(G, gens, level)
  local a;
  if IsEmpty(gens) then
    a := Section(One(G), List([1..level], i -> 1));
    gens := [a];
  fi;
  return Group(gens);
end);

InstallOtherMethod(__AG_SubgroupOnLevel, [IsTreeAutomorphismGroup,
                                    IsList and IsEmpty,
                                    IsPosInt],
function(G, gens, level)
  return Group(Section(One(G), List([1..level], i -> 1)));
end);

InstallMethod(__AG_SimplifyGroupGenerators, "for [IsList and IsTreeAutomorphismCollection]",
                              [IsList and IsTreeAutomorphismCollection],
function(gens)
  if IsEmpty(gens) then
    return [];
  else
    return Difference(gens, [One(gens[1])]);
  fi;
end);


###############################################################################
##
#M  ProjectionNC(<G>, <v>)
##
InstallMethod(ProjectionNC, "for [IsTreeAutomorphismGroup, IsList]",
              [IsTreeAutomorphismGroup, IsList],
function(G, v)
  local gens, pgens, a;

  if IsEmpty(v) then
    return G;
  fi;

  gens := GeneratorsOfGroup(G);
  pgens := List(gens, g -> Section(g, v));
  pgens := __AG_SimplifyGroupGenerators(pgens);

  return __AG_SubgroupOnLevel(G, pgens, Length(v));
end);

###############################################################################
##
#M  Projection (<G>, <v>)
##
InstallOtherMethod(Projection, "for [IsTreeAutomorphismGroup, IsList]",
                   [IsTreeAutomorphismGroup, IsList],
function(G, v)
  if not FixesVertex(G, v) then
    Error("in Projection(G, v): G does not fix vertex v");
  fi;
  return ProjectionNC(G, v);
end);


###############################################################################
##
#M  ProjStab(<G>, <v>)
##
InstallMethod(ProjStab, "for [IsTreeAutomorphismGroup, IsObject]",
              [IsTreeAutomorphismGroup, IsObject],
function(G, v)
  if HasIsFractal(G) and IsFractal(G) then
    return G;
  else
    if IsPosInt(v) then
      v := [v];
    fi;
    return ProjectionNC(StabilizerOfVertex(G, v), v);
  fi;
end);


###############################################################################
##
#M  \= (<G>, <H>)
##
InstallMethod(\=, "for [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup],
function(G, H)
  if HasIsFinite(G) and HasIsFinite(H) and
    IsFinite(G) <> IsFinite(H) then
      Info(InfoAutomGrp, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
      Info(InfoAutomGrp, 3, "  IsFinite(G)<>IsFinite(H)");
      return false;
  fi;

  if HasSize(G) and HasSize(H) and
    Size(G) <> Size(H) then
      Info(InfoAutomGrp, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
      Info(InfoAutomGrp, 3, "  Size(G)<>Size(H)");
      return false;
  fi;

  if CanEasilyTestSphericalTransitivity(G) and
    CanEasilyTestSphericalTransitivity(H) and
      IsSphericallyTransitive(G) <> IsSphericallyTransitive(H) then
        Info(InfoAutomGrp, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
        Info(InfoAutomGrp, 3, "  IsSphericallyTransitive(G) <> IsSphericallyTransitive(H)");
        return false;
  fi;

  if HasIsFractal(G) and HasIsFractal(H) and
     IsFractal(G) <> IsFractal(H)
  then
    Info(InfoAutomGrp, 3, "\=(IsTreeAutomorphismGroup, IsTreeAutomorphismGroup): false");
    Info(InfoAutomGrp, 3, "  IsFractal(G) <> IsFractal(H)");
    return false;
  fi;

  return IsSubgroup(G, H) and IsSubgroup(H, G);
end);


###############################################################################
##
#M  IsSubset (<G>, <H>)
##
InstallMethod(IsSubset, "for [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup]",
              [IsTreeAutomorphismGroup, IsTreeAutomorphismGroup],
function(G, H)
  local h, gens;

  if IsTrivial(H) then
    Info(InfoAutomGrp, 3, "IsSubset(G, H): true");
    Info(InfoAutomGrp, 3, "  IsTrivial(H)");
    return true;
  elif IsTrivial(G) then
    Info(InfoAutomGrp, 3, "IsSubset(G, H): false");
    Info(InfoAutomGrp, 3, "  not IsTrivial(H) and IsTrivial(G)");
    return false;
  fi;

  if HasIsFinite(G) and HasIsFinite(H) and
    IsFinite(G) and not IsFinite(H) then
      Info(InfoAutomGrp, 3, "IsSubset(G, H): false");
      Info(InfoAutomGrp, 3, "  IsFinite(G) and not IsFinite(H)");
      return false;
  fi;

  if HasSize(G) and HasSize(H) and
    Size(G) < Size(H) then
      Info(InfoAutomGrp, 3, "IsSubset(G, H): false");
      Info(InfoAutomGrp, 3, "  Size(G) < Size(H)");
      return false;
  fi;

  if  CanEasilyTestSphericalTransitivity(G) and
      CanEasilyTestSphericalTransitivity(H) and
      not IsSphericallyTransitive(G) and
      IsSphericallyTransitive(H)
  then
    Info(InfoAutomGrp, 3, "IsSubset(G, H): false");
    Info(InfoAutomGrp, 3, "  not IsSphericallyTransitive(G) and IsSphericallyTransitive(H)");
    return false;
  fi;

  G := AG_ReducedForm(G);
  H := AG_ReducedForm(H);

  gens := GeneratorsOfGroup(H);
  for h in gens do
    if not h in G then
      Info(InfoAutomGrp, 3, "IsSubset(G, H): false");
      Info(InfoAutomGrp, 3, "  not h in G");
      return false;
    fi;
  od;
  return true;
end);


###############################################################################
##
#M  <g> in <G>
##
InstallMethod(\in, "for [IsTreeAutomorphism, IsTreeAutomorphismGroup]",
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
    Info(InfoAutomGrp, 3, "g in G: false");
    Info(InfoAutomGrp, 3, "  not IsSphericallyTransitive(G) and IsSphericallyTransitive(g)");
    Info(InfoAutomGrp, 3, "  g = ", g);
    Info(InfoAutomGrp, 3, "  G = ", G);
    return false;
  fi;

  if not AbelImage(g) in AbelImage(G) then
    Info(InfoAutomGrp, 3, "g in G: false");
    Info(InfoAutomGrp, 3, "  not AbelImage(g) in AbelImage(G)");
    Info(InfoAutomGrp, 3, "  g = ", g);
    Info(InfoAutomGrp, 3, "  G = ", G);
    return false;
  fi;

  G := AG_ReducedForm(G);
  g := AG_ReducedForm(g);

  if FindElement(G, function(el) return el=g; end ,true, 8)<>fail then
    Info(InfoAutomGrp, 3, "g in G: FindElement returned true");
    return true;
  fi;

#TODO
  for i in [1..10] do
    if not PermOnLevel(g, i) in PermGroupOnLevel(G, i) then
      Info(InfoAutomGrp, 3, "g in G: false");
      Info(InfoAutomGrp, 3, "  not PermOnLevel(g, ",i,") in PermGroupOnLevel(G, ",i,")");
      Info(InfoAutomGrp, 3, "  g = ", g);
      Info(InfoAutomGrp, 3, "  G = ", G);
      return false;
    fi;
  od;

  TryNextMethod();
end);


InstallMethod(IsomorphismPermGroup, "for [IsTreeAutomorphismGroup and IsSelfSimilar]",
              [IsTreeAutomorphismGroup and IsSelfSimilar], SUM_FLAGS,
function(G)
  local H, F, gens_in_freegrp, pi, pi_bar, hom_function, inv_hom_function;
  H := PermGroupOnLevel(G, LevelOfFaithfulAction(G));
  return AG_GroupHomomorphismByImagesNC(G, H, GeneratorsOfGroup(G), GeneratorsOfGroup(H));
end);




InstallMethod(ContainsSphericallyTransitiveElement, "for [IsTreeAutomorphismGroup and IsSelfSimilar and IsActingOnBinaryTree]",
              [IsTreeAutomorphismGroup and IsSelfSimilar and IsActingOnBinaryTree],
function(G)
  local abels, indices, ab, trans;
  abels := List( GeneratorsOfGroup(G), AbelImage);
  if Length(abels)=0 then return false; fi;
  ab:=abels[1];
  trans:=One(ab)/(One(ab)+IndeterminateOfUnivariateRationalFunction(ab));
  for indices in Combinations([1..Length(abels)]) do
    if Sum(abels{indices})=trans then
      SetSphericallyTransitiveElement(G,Product(GeneratorsOfGroup(G){indices}));
      return true;
    fi;
  od;
  SetSphericallyTransitiveElement(G,fail);
  return false;
end);


InstallMethod(SphericallyTransitiveElement, "for [IsTreeAutomorphismGroup and IsSelfSimilar and IsActingOnBinaryTree]",
              [IsTreeAutomorphismGroup and IsSelfSimilar and IsActingOnBinaryTree],
function(G)
  ContainsSphericallyTransitiveElement(G);
  return SphericallyTransitiveElement(G);
end);


###############################################################################
##
#M  MarkovOperator(<G>, <lev>, <weights>)
##
InstallMethod(MarkovOperator, "for [IsTreeAutomorphismGroup, IsCyclotomic, IsList]",
              [IsTreeAutomorphismGroup, IsCyclotomic, IsList],
function(G, n, weights)
  local gens,R,indet;
  gens := ShallowCopy(GeneratorsOfGroup(G));
  if Length(weights)<>2*Length(gens) then Error("The number of weights must be twice as big as the number of generators"); fi;
  Append(gens, List(gens, x -> x^-1));
  if IsString(weights[1]) then
    R:=PolynomialRing(Integers,weights);
    indet:=IndeterminatesOfPolynomialRing(R);
    return Sum(List([1..Length(gens)], x -> indet[x]*PermOnLevelAsMatrix(gens[x], n)));
  else
    return Sum(List([1..Length(gens)], x -> weights[x]*PermOnLevelAsMatrix(gens[x], n)));
  fi;
end);



###############################################################################
##
#M  MarkovOperator(<G>, <lev>)
##
InstallMethod(MarkovOperator, "for [IsTreeAutomorphismGroup, IsCyclotomic]",
              [IsTreeAutomorphismGroup, IsCyclotomic],
function(G, n)
  return MarkovOperator(G,n,List([1..2*Length(GeneratorsOfGroup(G))],x->1/(2*Length(GeneratorsOfGroup(G)))));
end);


###############################################################################
##
#M  Section(<G>, <v>)
##
InstallMethod(Section, "for [IsTreeAutomorphismGroup, IsList]",
              [IsTreeAutomorphismGroup, IsList],
function(G, v)
  local gens, sec_gens, g;
  gens:=GeneratorsOfGroup(G);
  for g in gens do
    if v^g<>v then
      Error("Section([IsTreeAutomorphismGroup, IsList]): <G> does not fix <v>");
      return fail;
    fi;
  od;

  if not IsAutomGroup(G) then
    return Group(List(gens,x->Section(x,v)));
  else
    sec_gens:=[];
    for g in List(gens,x->Section(x,v)) do
      if not IsOne(g) and not g in sec_gens then
        Add(sec_gens, g);
      fi;
    od;
    if Length(sec_gens)>0 then
      return Group(sec_gens);
    else
      return Group([One(FamilyObj(Section(gens[1],v)))]);
    fi;
  fi;
end);


###############################################################################
##
#M  Section(<G>, <n>)
##
InstallMethod(Section, "for [IsTreeAutomorphismGroup, IsPosInt]",
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, n)
  return Section(G,[n]);
end);


#E
