#############################################################################
##
#W  treeaut.gi                 automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsTreeAutomorphismRep
##
## XXX remove it, use IsTreeHomomorphismRep
DeclareRepresentation("IsTreeAutomorphismRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["states", "perm", "deg"]);


###############################################################################
##
#R  IsTreeAutomorphismFamilyRep
##
DeclareRepresentation("IsTreeAutomorphismFamilyRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["spher_index"]);


###############################################################################
##
##  AG_CreatedTreeAutomorphismFamilies
##
BindGlobal("AG_CreatedTreeAutomorphismFamilies", []);


###############################################################################
##
#M  TreeAutomorphismFamily(<sph_ind>)
##
InstallMethod(TreeAutomorphismFamily, [IsRecord],
function(sph_ind)
  local p, red_ind, fam;
  red_ind := AG_ReducedSphericalIndex(sph_ind);
  for p in AG_CreatedTreeAutomorphismFamilies do
    if p[1] = red_ind then
      return p[2]; fi;
  od;
  fam := NewFamily( Concatenation("Automorphisms of ",
                      red_ind.start, ", (", red_ind.period, ")-tree"),
                    IsTreeAutomorphism,
                    IsTreeAutomorphism,
                    IsTreeAutomorphismFamily and IsTreeAutomorphismFamilyRep);
  fam!.spher_index := red_ind;
  AddSet(AG_CreatedTreeAutomorphismFamilies, [red_ind, fam]);
  return fam;
end);


BindGlobal("AG_TreeAutomorphism",
function(list_states, permutation)
  local top_deg, bot_deg, ind, fam, s, Orbs, orb;

  if Length(list_states)=0 then
    Error("The list of states can not be empty");
  fi;

  top_deg := Length(list_states);
  if not IsOne(permutation) and
      top_deg < Maximum(MovedPoints(permutation)) then
    Error("The root permutation ", permutation, " must move only points from 1 to the degree ", top_deg, " of the tree");
  fi;

  Orbs := OrbitsPerms([permutation], [1..Length(list_states)]);

  for orb in Orbs do
    for s in [2..Length(orb)] do
      if list_states[orb[s]]!.deg<>list_states[orb[1]]!.deg then
        Error("Sections in one orbit are acting on different trees");
      fi;
    od;
  od;

  bot_deg := DegreeOfTree(list_states[1]);
  ind := rec(start := [top_deg], period := [bot_deg]);
  fam := TreeAutomorphismFamily(ind);

  return Objectify( NewType(fam, IsTreeAutomorphism and IsTreeAutomorphismRep),
                    rec(states := list_states,
                        perm := permutation,
                        deg := top_deg));
end);

###############################################################################
##
#M  TreeAutomorphism(<states_list>, <perm>)
##
InstallMethod(TreeAutomorphism, "for [IsList, IsPerm]", [IsList, IsPerm],
function(states, perm)
  local autom, nstates, s;

  autom := fail;

  for s in states do
    if IsTreeAutomorphism(s) then
      autom := s;
    elif not IsOne(s) then
      Error("Invalid state `", s, "'");
    fi;
  od;

  if autom = fail then
    # XXX homogeneous tree, stupid!
    Error("Can't create an automaton with all trivial states ",
          "without information about the tree");
  fi;


  nstates := List(states, function(x)
                            if IsInt(x) and IsOne(x) then
                              return One(autom);
                            else
                              return x;
                            fi;
                          end);

  return AG_TreeAutomorphism(nstates, perm);
end);


###############################################################################
##
#M  TreeAutomorphism(<state_1>, <state_2>, ..., <state_n>, <perm>)
##
InstallMethod(TreeAutomorphism, [IsObject, IsObject, IsPerm],
  function(a1, a2, perm) return TreeAutomorphism([a1, a2], perm); end);
InstallMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, perm) return TreeAutomorphism([a1, a2, a3], perm); end);
InstallMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, perm) return TreeAutomorphism([a1, a2, a3, a4], perm); end);
InstallMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, a5, perm) return TreeAutomorphism([a1, a2, a3, a4, a5], perm); end);
#InstallMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsObject, IsPerm],
#  function(a1, a2, a3, a4, a5, a6, perm) return TreeAutomorphism([a1, a2, a3, a4, a5, a6], perm); end);


###############################################################################
##
#M  ViewObj(<a>)
##
InstallMethod(ViewObj, [IsTreeAutomorphism],
function (a)
    local deg, printword, i;

    deg := AG_TopDegreeInSphericalIndex(FamilyObj(a)!.spher_index);
    Print("(");
    for i in [1..deg] do
        View(a!.states[i]);
        if i <> deg then Print(", "); fi;
    od;
    Print(")");
    if not IsOne(a!.perm) then Print(a!.perm); fi;
end);


###############################################################################
##
#M  PrintObj(<a>)
##
InstallMethod(PrintObj, "for [IsTreeAutomorphism and IsTreeAutomorphismRep]",
                             [IsTreeAutomorphism and IsTreeAutomorphismRep],
function (a)
    local deg, printword, i;

    deg := AG_TopDegreeInSphericalIndex(FamilyObj(a)!.spher_index);
    Print("(");
    for i in [1..deg] do
      if IsAutom(a!.states[i]) then
        View(a!.states[i]);
      else
        Print(a!.states[i]);
      fi;
      if i <> deg then Print(", "); fi;
    od;
    Print(")");
    if not IsOne(a!.perm) then Print(a!.perm); fi;
end);


###############################################################################
##
#M  String(<a>)
##
InstallMethod(String, "for [IsTreeAutomorphism]", [IsTreeAutomorphism],
function (a)
    local deg, printword, i, perm, states, str;

    states := Sections(a);
    deg := Length(states);
    perm := PermOnLevel(a, 1);
    str:= "(";

    for i in [1..deg] do
        Append(str, String(states[i]));
        if i <> deg then Append(str, ", "); fi;
    od;
    Append(str, ")");
    if not IsOne(perm) then
      Append(str, AG_TransformationString(perm));
    fi;
    return str;
end);


###############################################################################
##
#M  SphericalIndex(<a>)
##
InstallMethod(SphericalIndex, [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  return FamilyObj(a)!.spher_index;
end);


###############################################################################
##
#M  Perm(<a>)
##
InstallMethod(Perm, "for [IsTreeAutomorphism and IsTreeAutomorphismRep]",
              [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  return a!.perm;
end);


###############################################################################
##
#M  Perm (<a>, <k>)
##
InstallMethod(Perm, "for [IsTreeAutomorphism, IsPosInt]",
              [IsTreeAutomorphism, IsPosInt],
function(a, k)
  return PermOnLevel(a, k);
end);


###############################################################################
##
#M  PermOnLevel (<a>, <k>)
##
InstallMethod(PermOnLevelOp, "for [IsTreeAutomorphism, IsPosInt]",
              [IsTreeAutomorphism, IsPosInt],
function(a, k)
  local states, top, first_level, i, j, d1, d2, permuted, p;

  if k = 1 then
    return Perm(a);
  fi;

  # XXX test this function

  # TODO: it goes through all vertices of the second level, it may be
  # unnecessary for sparse actions
  d1 := a!.deg;
  d2 := 1;
  for i in [2 .. k] do
    d2 := d2 * DegreeOfLevel(a, i);
  od;
  states := Sections(a);
  top := Perm(a);
  first_level := List(states, s -> PermOnLevel(s, k-1));
  permuted := [];
  for i in [1..d1] do
    for j in [1..d2] do
      permuted[d2*(i-1) + j] := d2*(i^top - 1) + j^first_level[i];
    od;
  od;

  p := PermList(permuted);
  if p<>fail then
    return p;
  else
    Error("An element ",a," does not induce a permutation on the level ",k);
  fi;
end);


###############################################################################
##
#M  k ^ a
##
InstallMethod(\^, "for [IsPosInt, IsTreeAutomorphism]",
                   [IsPosInt, IsTreeAutomorphism],
function(k, a)
    return k ^ Perm(a);
end);


###############################################################################
##
#M  seq ^ a
##
InstallMethod(\^, "for [IsList, IsTreeAutomorphism]",
                   [IsList, IsTreeAutomorphism],
function(seq, a)
  if Length(seq) = 0 then return []; fi;
  if Length(seq) = 1 then return [seq[1]^Perm(a)]; fi;
  return Concatenation([seq[1]^Perm(a)], seq{[2..Length(seq)]}^Section(a, seq[1]));
end);


###############################################################################
##
#M  FixesLevel(<a>, <k>)
##
InstallMethod(FixesLevel, "for [IsTreeAutomorphism, IsPosInt]",
              [IsTreeAutomorphism, IsPosInt],
function(a, k)
  if HasIsSphericallyTransitive(a) then
    if IsSphericallyTransitive(a) then
      return false; fi; fi;

  if IsOne(PermOnLevel(a, k)) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomGrp, 3, "  a is not transitive on level", k);
    Info(InfoAutomGrp, 3, "  a = ", a);
    SetIsSphericallyTransitive(a, false);
    return true;
  else
    return false;
  fi;
end);


###############################################################################
##
#M  FixesVertex(<a>, <v>)
##
InstallMethod(FixesVertex,  "for [IsTreeAutomorphism, IsObject]",
                   [IsTreeAutomorphism, IsObject],
function(a, v)
  if HasIsSphericallyTransitive(a) then
    if IsSphericallyTransitive(a) then
      Info(InfoAutomGrp, 3, "FixesVertex(a, v): false");
      Info(InfoAutomGrp, 3, "  IsSphericallyTransitive(a)");
      Info(InfoAutomGrp, 3, "  a = ", a);
      return false;
    fi;
  fi;

  if v^a = v then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomGrp, 3, "  a fixes vertex ", v);
    Info(InfoAutomGrp, 3, "  a = ", a);
    SetIsSphericallyTransitive(a, false);
    return true;
  else
    return false;
  fi;
end);


###############################################################################
##
#M  IsSphericallyTransitive (<a>)
##
InstallMethod(IsSphericallyTransitive,
              "for [IsTreeAutomorphism and IsActingOnBinaryTree]",
              [IsTreeAutomorphism and IsActingOnBinaryTree],
function(a)
  local ab;
  Info(InfoAutomGrp, 4, "IsSphericallyTransitive(a): using AbelImage");
  Info(InfoAutomGrp, 4, "  a = ", a);
  ab := AbelImage(a);
  return ab = One(ab)/(One(ab)+IndeterminateOfUnivariateRationalFunction(ab));
end);

RedispatchOnCondition(IsSphericallyTransitive, true, [IsTreeAutomorphism],
                      [IsTreeAutomorphism and IsActingOnBinaryTree], 0);

InstallMethod(IsSphericallyTransitive, "for [IsTreeAutomorphism]",
              [IsTreeAutomorphism],
function(a)
  if not IsTransitive(Group(PermOnLevel(a, 1)), [1..Degree(a)]) then
    Info(InfoAutomGrp, 4, "IsSphericallyTransitive(a): false");
    Info(InfoAutomGrp, 4, "  PermOnLevel(a, 1) isn't transitive");
    Info(InfoAutomGrp, 4, "  a = ", a);
    return false;
  fi;
  TryNextMethod();
end);

InstallMethod(IsSphericallyTransitive,
              "for [IsTreeAutomorphism and HasOrder]",
              [IsTreeAutomorphism and HasOrder],
function(a)
  if Order(a) < infinity then
    Info(InfoAutomGrp, 4, "IsSphericallyTransitive(a): false");
    Info(InfoAutomGrp, 4, "  Order(a) < infinity");
    Info(InfoAutomGrp, 4, "  a = ", a);
    return false;
  fi;
  TryNextMethod();
end);


###############################################################################
##
#M  Order (<a>)
##
InstallImmediateMethod(Order, IsTreeAutomorphism and HasIsSphericallyTransitive, 0,
function(a)
  if IsSphericallyTransitive(a) then return infinity; fi;
  TryNextMethod();
end);


###############################################################################
##
#M  Order(<a>)
##
InstallMethod(Order, "for [IsTreeAutomorphism]", [IsTreeAutomorphism],
function(a)
  local i, perm, stab, stab_order, ord, exp, states;

  perm := Perm(a);
  if IsOne(perm) then
    exp := 1;
    stab := a;
  else
    exp := Order(perm);
    stab := a^exp;
  fi;

  if IsOne(stab) then
    return exp;
  fi;

  states := Sections(stab);
  stab_order := 1;

  for i in [1..Length(states)] do
    ord := Order(states[i]);
    if ord = infinity then
      return infinity;
    else
      stab_order := Lcm(stab_order, ord);
    fi;
  od;

  return exp * stab_order;
end);


###############################################################################
##
#M  Section(<a>, <k>)
##

InstallMethod(Section, [IsTreeAutomorphism and IsTreeAutomorphismRep, IsPosInt],
function(a, k)
  return a!.states[k];
end);

###############################################################################
##
#M  Sections(<a>)
##
InstallMethod(Sections, [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  return a!.states;
end);



###############################################################################
##
#M  Decompose(<a>, <k>)
##
InstallMethod(Decompose, "for [IsTreeAutomorphism, IsPosInt]",
              [IsTreeAutomorphism, IsPosInt],
function(a, level)
  return TreeAutomorphism(Sections(a, level), PermOnLevel(a, level));
end);



###############################################################################
##
#M  Decompose(<a>)
##
InstallMethod(Decompose, "for [IsTreeAutomorphism]", [IsTreeAutomorphism],
function(a)
  return Decompose(a, 1);
end);


###############################################################################
##
#M  IsOne(<a>)
##
InstallMethod(IsOne, "for [IsTreeAutomorphism and IsTreeAutomorphismRep]",
                   [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  local i;
  if a!.perm <> () then return false; fi;
  for i in [1..a!.deg] do
    if not IsOne(a!.states[i]) then return false; fi;
  od;
  return true;
end);


###############################################################################
##
#M  IsOne(<a>)
##
InstallMethod(IsOne, [IsTreeAutomorphism],
function(a)
  local i;
  if not IsOne(Perm(a)) then return false; fi;
  for i in [1..TopDegreeOfTree(a)] do
    if not IsOne(Section(a, i)) then return false; fi;
  od;
  return true;
end);


###############################################################################
##
#M  \=(<a1>, <a2>)
##
# TODO: can lead to infinite recursion
InstallMethod(\=, "for [IsTreeAutomorphism, IsTreeAutomorphism]", ReturnTrue,
              [IsTreeAutomorphism, IsTreeAutomorphism],
function(a1, a2)
  return Perm(a1) = Perm(a2) and Sections(a1) = Sections(a2);
end);


###############################################################################
##
#M  \<(<a1>, <a2>)
##
InstallMethod(\<, [IsTreeAutomorphism and IsTreeAutomorphismRep,
                   IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a1, a2)
  return AG_TreeHomomorphismCmp(a1, a2) < 0;
end);


###############################################################################
##
#M  OneOp(<a>)
##
InstallMethod(OneOp, [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  return Objectify( NewType(FamilyObj(a), IsTreeAutomorphism and IsTreeAutomorphismRep),
                    rec(states := List([1..a!.deg], i -> One(a!.states[1])),
                        perm := (),
                        deg := a!.deg));
end);


###############################################################################
##
#M  \*(<a1>, <a2>)
##
InstallMethod(\*, [IsTreeAutomorphism and IsTreeAutomorphismRep,
                   IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a1, a2)
  local a;
  a := Objectify(NewType(FamilyObj(a1), IsTreeAutomorphism and IsTreeAutomorphismRep),
        rec(states := List([1..a1!.deg], i -> a1!.states[i] * a2!.states[i^(a1!.perm)]),
            perm := a1!.perm * a2!.perm,
            deg := a1!.deg));
  SetIsActingOnBinaryTree(a, IsActingOnBinaryTree(a1));
  SetIsActingOnRegularTree(a, IsActingOnRegularTree(a1));
  return a;
end);


###############################################################################
##
#M  \*(<a1>, <a2>)
##
InstallMethod(\*, [IsTreeAutomorphism, IsTreeAutomorphism],
function(a1, a2)
  local s1, s2, p1, p2, states, perm, d, a;
  s1 := Sections(a1); p1 := Perm(a1);
  s2 := Sections(a2); p2 := Perm(a2);
  states := List([1..Length(s1)], i -> s1[i] * s2[i^p1]);
  return TreeAutomorphism(states, p1*p2);
end);


###############################################################################
##
#M  \[\](<a1>, <a2>)
##
InstallOtherMethod(\[\], [IsTreeAutomorphism, IsPosInt],
function(a, k)
  return Section(a, k);
end);


###############################################################################
##
#M  InverseOp(<a>)
##
InstallMethod(InverseOp, "for [IsTreeAutomorphism and IsTreeAutomorphismRep]",
              [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  local inv;
  inv := Objectify(NewType(FamilyObj(a), IsTreeAutomorphism and IsTreeAutomorphismRep),
            rec(states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1),
                perm := a!.perm ^ -1,
                deg := a!.deg) );
  SetIsActingOnBinaryTree(inv, IsActingOnBinaryTree(a));
  SetIsActingOnRegularTree(inv, IsActingOnRegularTree(a));
  return inv;
end);

InstallMethod(InverseOp, "for [IsTreeAutomorphism]", [IsTreeAutomorphism],
function(a)
  local states, inv_states, perm;
  states := Sections(a);
  perm := Inverse(Perm(a));
  inv_states := List([1..Length(states)], i -> Inverse(states[i^perm]));
  return TreeAutomorphism(inv_states, perm);
end);


###############################################################################
##
#M  AbelImage(<a>)
##
##  XXX  Works for IsAutom or IsSelfSim only !!!!
##
InstallMethod(AbelImage, "for [IsTreeAutomorphism]",
              [IsTreeAutomorphism],
function(a)
  local abels, w, i;
  w := LetterRepAssocWord(Word(a));
  for i in [1..Length(w)] do
    if w[i] < 0 then w[i] := -w[i]+FamilyObj(a)!.numstates; fi;
  od;
  abels := AG_AbelImagesGenerators(FamilyObj(a));
  if not IsEmpty(w) then
    return Sum(List(w, x -> abels[x]));
  else
    return Zero(abels[1]);
  fi;
end);


#E
