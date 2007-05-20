#############################################################################
##
#W  treeautgrp.gi              automgrp package                Yevgen Muntyan
#W                                                              Dmytro Sachuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
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
  if HasIsSphericallyTransitive(super) then
    if not IsSphericallyTransitive(super) then
      Info(InfoAutomata, 3, "IsSphericallyTransitive(sub): false");
      Info(InfoAutomata, 3, "  super is not spherically transitive");
      Info(InfoAutomata, 3, "  super = ", super);
      Info(InfoAutomata, 3, "  sub = ", sub);
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
InstallMethod(TopDegreeOfTree, "method for IsTreeAutomorphismGroup",
              [IsTreeAutomorphismGroup],
function(G)
  return TopDegreeOfTree(GeneratorsOfGroup(G)[1]);
end);
InstallMethod(DegreeOfTree, "method for IsTreeAutomorphismGroup",
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
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is finite");
    Info(InfoAutomata, 3, "  G = ", G);
    return false;
  fi;
  TryNextMethod();
end);

InstallMethod(IsSphericallyTransitive, "IsSphericallyTransitive(IsTreeAutomorphismGroup)",
              [IsTreeAutomorphismGroup],
function (G)
  local i, k, stab;

  if HasIsFinite(G) and IsFinite(G) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is finite");
    Info(InfoAutomata, 3, "  G = ", G);
    return false;
  fi;

  if not IsTransitiveOnLevel(G, 1) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is not transitive on ", i, "-th level");
    Info(InfoAutomata, 3, "  G = ", G);
    return false;
  fi;

  if IsActingOnBinaryTree(G) then
    if AutomataAbelImageSpherTrans in AbelImage(G) then
      Info(InfoAutomata, 3, "IsSphericallyTransitive(G): true");
      Info(InfoAutomata, 3, "  using AbelImage");
      Info(InfoAutomata, 3, "  G = ", G);
      return true;
    fi;
  fi;

  if not IsAutomGroup(G) then
    stab := StabilizerOfVertex(G, 1);
    return IsSphericallyTransitive(Projection(stab, 1));
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  IsTransitiveOnLevel (<G>, <k>)
##
InstallMethod(IsTransitiveOnLevel, [IsTreeAutomorphismGroup, IsPosInt],
function(G, k)
  return IsTransitive(G, TreeLevelTuples(SphericalIndex(G), k));
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
  if IsFinite(G) then return false; fi;
  TryNextMethod();
end);

InstallMethod(IsFractal, "IsFractal(IsTreeAutomorphismGroup)", [IsTreeAutomorphismGroup],
function(G)
  local i;

  if not IsTransitive(PermGroupOnLevel(G, 1), [1..DegreeOfTree(G)]) then
    SetIsSphericallyTransitive(G, false);
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "IsFractal(G): false");
    Info(InfoAutomata, 3, "  G is not transitive on first level");
    return false;
  fi;

  if HasIsFinite(G) and IsFinite(G) then
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
#M  Size (<G>)
##
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


###############################################################################
##
#M  PermGroupOnLevelOp (<G>, <k>)
##
InstallMethod(PermGroupOnLevelOp, "method for IsTreeAutomorphismGroup and IsPosInt",
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
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G is not transitive on level", k);
    Info(InfoAutomata, 3, "  G = ", G);
    SetIsSphericallyTransitive(G, false);
    return G;
  fi;

  perms := List(GeneratorsOfGroup(G), a -> PermOnLevel(a, k));
  S := GroupWithGenerators(perms);
  F := FreeGroup(Length(perms));
  hom := GroupHomomorphismByImagesNC(F, S, GeneratorsOfGroup(F), perms);
  gens := FreeGeneratorsOfGroup(Kernel(hom));
  gens := List(gens, w ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := $SimplifyGenerators(gens);
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
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G fixes vertex", k);
    Info(InfoAutomata, 3, "  G = ", G);
    Info(InfoAutomata, 3, "  k = ", k);
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
  gens := List(gens, w ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := $SimplifyGenerators(gens);
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

  if Length(seq) = 0 then
    return G;
  fi;

  if TopDegreeOfTree(G) = 2 and Length(seq) = 1 then
    return StabilizerOfFirstLevel(G);
  fi;

  if FixesVertex(G, seq) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G fixes vertex", seq);
    Info(InfoAutomata, 3, "  G = ", G);
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
  gens := List(gens, w ->
    MappedWord(w, GeneratorsOfGroup(F), GeneratorsOfGroup(G)));
  gens := $SimplifyGenerators(gens);
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
    Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
    Info(InfoAutomata, 3, "  G fixes level", k);
    Info(InfoAutomata, 3, "  G = ", G);
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
InstallMethod(FixesVertex, "method for IsTreeAutomorphismGroup and IsPosInt",
              [IsTreeAutomorphismGroup, IsObject],
function(G, v)
  local gens, g;
  gens := GeneratorsOfGroup(G);
  for g in gens do
    if not FixesVertex(g, v) then return false; fi;
  od;
  Info(InfoAutomata, 3, "IsSphericallyTransitive(G): false");
  Info(InfoAutomata, 3, "  G fixes vertex", v);
  Info(InfoAutomata, 3, "  G = ", G);
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
  return Projection(G, [k]);
end);


# TODO: check whether gens are from the same overgroup;
# check degree of tree and stuff
InstallMethod($SubgroupOnLevel, [IsTreeAutomorphismGroup,
                                 IsList and IsTreeAutomorphismCollection,
                                 IsPosInt],
function(G, gens, level)
  local a;
  if IsEmpty(gens) then
    a := State(One(G), List([1..level], i->1));
    gens := [a];
  fi;
  return Group(gens);
end);

InstallMethod($SubgroupOnLevel, [IsTreeAutomorphismGroup,
                                 IsList and IsEmpty,
                                 IsPosInt],
function(G, gens, level)
  return Group(State(One(G), List([1..level], i->1)));
end);

InstallMethod($SimplifyGenerators, [IsList and IsTreeAutomorphismCollection],
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
InstallMethod(ProjectionNC, "Projection(IsTreeAutomorphismGroup, IsList)",
              [IsTreeAutomorphismGroup, IsList],
function(G, v)
  local gens, pgens, a;

  if IsEmpty(v) then
    return G;
  fi;

  gens := GeneratorsOfGroup(G);
  pgens := List(gens, g -> State(g, v));
  pgens := $SimplifyGenerators(pgens);

  return $SubgroupOnLevel(G, pgens, Length(v));
end);

###############################################################################
##
#M  Projection (<G>, <v>)
##
InstallOtherMethod(Projection, "Projection(IsTreeAutomorphismGroup, IsList)",
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
InstallMethod(ProjStab, "ProjStab(IsTreeAutomorphismGroup, IsObject)",
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

  if HasIsFractal(G) and HasIsFractal(H) and
     IsFractal(G) <> IsFractal(H)
  then
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

  G := ReducedForm(G);
  H := ReducedForm(H);

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
    Info(InfoAutomata, 3, "  g = ", g);
    Info(InfoAutomata, 3, "  G = ", G);
    return false;
  fi;

  if not AbelImage(g) in AbelImage(G) then
    Info(InfoAutomata, 3, "g in G: false");
    Info(InfoAutomata, 3, "  not AbelImage(g) in AbelImage(G)");
    Info(InfoAutomata, 3, "  g = ", g);
    Info(InfoAutomata, 3, "  G = ", G);
    return false;
  fi;

  G := ReducedForm(G);
  g := ReducedForm(g);

  if FindGroupElement(G, function(el) return el=g; end ,true, 8)<>fail then
    Info(InfoAutomata, 3, "g in G: FindGroupElement returned true");
    return true;
  fi;

#TODO
  for i in [1..10] do
    if not PermOnLevel(g, i) in PermGroupOnLevel(G, i) then
      Info(InfoAutomata, 3, "g in G: false");
      Info(InfoAutomata, 3, "  not PermOnLevel(g, ",i,") in PermGroupOnLevel(G, ",i,")");
      Info(InfoAutomata, 3, "  g = ", g);
      Info(InfoAutomata, 3, "  G = ", G);
      return false;
    fi;
  od;

  TryNextMethod();
end);


BindGlobal("AG_GroupIterator",
function(G, max_len)
  local next_iterator, is_done_iterator, shallow_copy,
        create_iter_rec;

  create_iter_rec := function(G)
    local record;

    record := rec(
      NextIterator := next_iterator,
      IsDoneIterator := is_done_iterator,
      ShallowCopy := shallow_copy,

      group := G,
      done := false,
      max_len := max_len,

      gens := Difference(GeneratorsOfSemigroup(G), [One(G)]),
      gens_ptr := [1, 1],

      ptr := 1,
    );

    record.n_gens := Length(record.gens);
    record.elms := Concatenation([One(G)], record.gens);
    record.levels := [[1], [2..1+Length(record.gens)], []];
    record.is_one := record.n_gens = 0;

    return record;
  end;

  next_iterator := function(iter)
    local elm;

    if iter!.is_one then
      iter!.done := true;
      return One(iter!.group);
    fi;

    elm := iter!.elms[iter!.ptr];
    iter!.ptr := iter!.ptr + 1;

    return elm;
  end;

  is_done_iterator := function(iter)
    local gens_ptr, gens, elm, elm_list, levels, n_levels, added;

    if iter!.done then
      return true;
    fi;

    if iter!.ptr <= Length(iter!.elms) then
      return false;
    fi;

    gens_ptr := iter!.gens_ptr;
    gens := iter!.gens;
    elm_list := iter!.elms;
    levels := iter!.levels;
    n_levels := Length(levels);
    added := false;

    while not added do
      if gens_ptr[1] > Length(levels[n_levels-1]) then
        if IsEmpty(levels[n_levels]) then
          iter!.done := true;
          SetIsFinite(iter!.group, true);
          SetSize(iter!.group, Length(elm_list));
          break;
        elif n_levels - 1 > iter!.max_len then
          iter!.done := true;
          break;
        fi;

        Add(levels, []);
        n_levels := n_levels + 1;
        gens_ptr[1] := 1;
      fi;

      elm := elm_list[levels[n_levels-1][gens_ptr[1]]] * gens[gens_ptr[2]];

      if not elm in elm_list then
        Add(levels[n_levels], Length(elm_list));
        Add(elm_list, elm);
        added := true;
      fi;

      gens_ptr[2] := gens_ptr[2] + 1;
      if gens_ptr[2] > Length(gens) then
        gens_ptr[2] := 1;
        gens_ptr[1] := gens_ptr[1] + 1;
      fi;
    od;

    iter!.ptr := Length(elm_list);
    return iter!.done;
  end;

  shallow_copy := function(iter)
    return create_iter_rec(iter!.G);
  end;

  return IteratorByFunctions(create_iter_rec(G));
end);

InstallMethod(Iterator, [IsTreeAutomorphismGroup],
function(G)
  return AG_GroupIterator(G);
end);

InstallOtherMethod(Iterator, [IsTreeAutomorphismGroup, IsCyclotomic],
function(G, max_len)
  return AG_GroupIterator(G, max_len);
end);


#E
