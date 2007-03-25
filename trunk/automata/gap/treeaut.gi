#############################################################################
##
#W  treeaut.gi                 automata package                Yevgen Muntyan
#W                                                              Dmytro Sachuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsTreeAutomorphismRep
##
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
#V  CreatedTreeAutomorphismFamilies
##
BindGlobal("CreatedTreeAutomorphismFamilies", []);


###############################################################################
##
#M  TreeAutomorphismFamily(<sph_ind>)
##
InstallMethod(TreeAutomorphismFamily, [IsRecord],
function(sph_ind)
  local p, red_ind, fam;
  red_ind := ReducedSphericalIndex(sph_ind);
  for p in CreatedTreeAutomorphismFamilies do
    if p[1] = red_ind then
      return p[2]; fi;
  od;
  fam := NewFamily( Concatenation("Automorphisms of ",
                      red_ind.start, ", (", red_ind.period, ")-tree"),
                    IsTreeAutomorphism,
                    IsTreeAutomorphism,
                    IsTreeAutomorphismFamily and IsTreeAutomorphismFamilyRep);
  fam!.spher_index := red_ind;
  AddSet(CreatedTreeAutomorphismFamilies, [red_ind, fam]);
  return fam;
end);


###############################################################################
##
#M  TreeAutomorphism(<states_list>, <perm>)
##
InstallMethod(TreeAutomorphism, [IsList and IsAutomatonCollection, IsPerm],
function(list_states, permutation)
  local top_deg, bot_deg, ind, fam;
  top_deg := Length(list_states);
  if not IsOne(permutation) and
      top_deg < Maximum(MovedPoints(permutation)) then
    Error();
  fi;
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
InstallMethod(TreeAutomorphism, [IsList, IsPerm],
function(states, perm)
  local autom, nstates, s;

  autom := fail;

  for s in states do
    if IsTreeAutomorphism(s) then
      autom := s;
      break;
    elif not IsOne(s) then
      Error("Invalid state `", s, "'");
    fi;
  od;

  if autom = fail then
    Error("Can't create an automaton with all trivial states ",
          "without information about the tree");
  fi;

  nstates := List(states, function(s)
                            if IsOne(s) then
                              return One(autom);
                            else
                              return s;
                            fi;
                          end);

  return TreeAutomorphism(nstates, perm);
end);


###############################################################################
##
#M  TreeAutomorphism(<state_1>, <state_2>, ..., <state_n>, <perm>)
##
InstallOtherMethod(TreeAutomorphism, [IsObject, IsObject, IsPerm],
  function(a1, a2, perm) return TreeAutomorphism([a1, a2], perm); end);
InstallOtherMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, perm) return TreeAutomorphism([a1, a2, a3], perm); end);
InstallOtherMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, perm) return TreeAutomorphism([a1, a2, a3, a4], perm); end);
InstallOtherMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, a5, perm) return TreeAutomorphism([a1, a2, a3, a4, a5], perm); end);
InstallOtherMethod(TreeAutomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, a5, a6, perm) return TreeAutomorphism([a1, a2, a3, a4, a5, a6], perm); end);


###############################################################################
##
#M  ViewObj(<a>)
##
InstallMethod(ViewObj, [IsTreeAutomorphism],
function (a)
    local deg, printword, i;

    deg := TopDegreeInSphericalIndex(FamilyObj(a)!.spher_index);
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
InstallMethod(PrintObj, [IsTreeAutomorphism],
function (a)
    local deg, printword, i;

    deg := TopDegreeInSphericalIndex(FamilyObj(a)!.spher_index);
    Print("(");
    for i in [1..deg] do
      if (IsAutom(a!.states[i])) then
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
InstallOtherMethod(Perm, "method for IsTreeAutomorphism and IsTreeAutomorphismRep",
              [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  return a!.perm;
end);


###############################################################################
##
#M  Perm (<a>, <k>)
##
InstallMethod(Perm, "method for IsTreeAutomorphism and IsPosInt",
              [IsTreeAutomorphism, IsPosInt],
function(a, k)
  return PermOnLevel(a, k);
end);


###############################################################################
##
#M  PermOnLevel (<a>, <k>)
##
InstallMethod(PermOnLevelOp, "method for IsTreeAutomorphism and IsPosInt",
              [IsTreeAutomorphism, IsPosInt],
function(a, k)
  local states, top, first_level, i, j, d1, d2, permuted;

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
  states := States(a);
  top := Perm(a);
  first_level := List(states, s -> PermOnLevel(s, k-1));
  permuted := [];
  for i in [1..d1] do
    for j in [1..d2] do
      permuted[d2*(i-1) + j] := d2*(i^top - 1) + j^first_level[i];
    od;
  od;
  return PermList(permuted);
end);


###############################################################################
##
#M  k ^ a
##
InstallOtherMethod(\^, "\^(IsPosInt, IsTreeAutomorphism)",
                   [IsPosInt, IsTreeAutomorphism],
function(k, a)
    return k ^ Perm(a);
end);


###############################################################################
##
#M  seq ^ a
##
InstallOtherMethod(\^, "\^(IsList, IsTreeAutomorphism)",
                   [IsList, IsTreeAutomorphism],
function(seq, a)
  if Length(seq) = 0 then return []; fi;
  if Length(seq) = 1 then return [seq[1]^Perm(a)]; fi;
  return Concatenation([seq[1]^Perm(a)], seq{[2..Length(seq)]}^State(a, seq[1]));
end);


###############################################################################
##
#M  FixesLevel(<a>, <k>)
##
InstallMethod(FixesLevel, "method for IsTreeAutomorphism and IsPosInt",
              [IsTreeAutomorphism, IsPosInt],
function(a, k)
  if HasIsSphericallyTransitive(a) then
    if IsSphericallyTransitive(a) then
      return false; fi; fi;

  if IsOne(PermOnLevel(a, k)) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomata, 3, "  a is not transitive on level", k);
    Info(InfoAutomata, 3, "  a = ", a);
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
InstallOtherMethod(FixesVertex,  "method for IsTreeAutomorphism and IsObject",
                   [IsTreeAutomorphism, IsObject],
function(a, v)
  if HasIsSphericallyTransitive(a) then
    if IsSphericallyTransitive(a) then
      Info(InfoAutomata, 3, "FixesVertex(a, v): false");
      Info(InfoAutomata, 3, "  IsSphericallyTransitive(a)");
      Info(InfoAutomata, 3, "  a = ", a);
      return false;
    fi;
  fi;

  if v^a = v then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomata, 3, "  a fixes vertex ", v);
    Info(InfoAutomata, 3, "  a = ", a);
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
              "method for IsTreeAutomorphism acting on binary tree",
              [IsTreeAutomorphism and IsActingOnBinaryTree],
function(a)
  local ab;
  Info(InfoAutomata, 3, "IsSphericallyTransitive(a): using AbelImage");
  Info(InfoAutomata, 3, "  a = ", a);
  ab := AbelImage(a);
  return ab = One(ab)/(One(ab)+IndeterminateOfUnivariateRationalFunction(ab));
end);

RedispatchOnCondition(IsSphericallyTransitive, true, [IsTreeAutomorphism],
                      [IsTreeAutomorphism and IsActingOnBinaryTree], 0);

InstallMethod(IsSphericallyTransitive, "method for IsTreeAutomorphism",
              [IsTreeAutomorphism],
function(a)
  if not IsTransitive(Group(PermOnLevel(a, 1)), [1..Degree(a)]) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomata, 3, "  PermOnLevel(a, 1) isn't transitive");
    Info(InfoAutomata, 3, "  a = ", a);
    return false;
  fi;
  TryNextMethod();
end);

InstallMethod(IsSphericallyTransitive,
              "IsSphericallyTransitive(IsTreeAutomorphism and HasOrder)",
              [IsTreeAutomorphism and HasOrder],
function(a)
  if Order(a) < infinity then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomata, 3, "  Order(a) < infinity");
    Info(InfoAutomata, 3, "  a = ", a);
    return false;
  fi;
  TryNextMethod();
end);


###############################################################################
##
#M  CanEasilyComputeOrder (<a>)
##
InstallTrueMethod(CanEasilyComputeOrder, HasOrder and IsTreeAutomorphism);
InstallTrueMethod(CanEasilyComputeOrder, IsSphericallyTransitive and IsTreeAutomorphism);


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
__FA_perm_exponent := function(perm)
  local cycles;
  cycles := CycleStructurePerm(perm);
  return Product(List([1..Length(cycles)],
                      function(i)
                        if IsBound(cycles[i]) then
                          return i+1;
                        else
                          return 1;
                        fi;
                      end));
end;

InstallMethod(Order, "Order(IsTreeAutomorphism)", [IsTreeAutomorphism],
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

  states := States(stab);
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
#M  State(<a>, <k>)
##
InstallOtherMethod(State, [IsTreeAutomorphism, IsPosInt],
function(a, k)
  return States(a)[k];
end);

InstallOtherMethod(State, [IsTreeAutomorphism and IsTreeAutomorphismRep, IsPosInt],
function(a, k)
  return a!.states[k];
end);


###############################################################################
##
#M  State(<a>, <v>)
##
InstallMethod(State, [IsTreeAutomorphism, IsList],
function(a, v)
  if Length(v) = 1 then return State(a, v[1]);
  else return State(State(a, v[1]), v{[2..Length(v)]});
  fi;
end);


###############################################################################
##
#M  States(<a>)
##
InstallMethod(States, [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  return a!.states;
end);


###############################################################################
##
#M  States(a, k)
##
InstallOtherMethod(States, "States(IsTreeAutomorphism, IsPosInt)",
                   [IsTreeAutomorphism, IsPosInt],
function(a, level)
  if level = 1 then
    return States(a);
  else
    return Concatenation(List(States(a), s -> States(s, level-1)));
  fi;
end);


###############################################################################
##
#M  Expand(<a>, <k>)
##
InstallMethod(Expand, [IsTreeAutomorphism, IsPosInt],
function(a, level)
  return TreeAutomorphism(States(a, level), PermOnLevel(a, level));
end);


###############################################################################
##
#M  Expand(<a>)
##
InstallOtherMethod(Expand, [IsTreeAutomorphism],
function(a)
  return Expand(a, 1);
end);


###############################################################################
##
#M  IsOne(<a>)
##
InstallOtherMethod(IsOne, [IsTreeAutomorphism and IsTreeAutomorphismRep],
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
InstallOtherMethod(IsOne, [IsTreeAutomorphism],
function(a)
  local i;
  if not IsOne(Perm(a)) then return false; fi;
  for i in [1..TopDegreeOfTree(a)] do
    if not IsOne(State(a, i)) then return false; fi;
  od;
  return true;
end);


###############################################################################
##
#M  \=(<a1>, <a2>)
##
InstallMethod(\=, [IsTreeAutomorphism and IsTreeAutomorphismRep,
                        IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a1, a2)
  local i;
  if a1!.perm <> a2!.perm then return false; fi;
  for i in [1..a1!.deg] do
    if a1!.states[i] <> a2!.states[i] then return false; fi;
  od;
  return true;
end);


###############################################################################
##
#M  \=(<a1>, <a2>)
##
InstallMethod(\=, [IsTreeAutomorphism, IsTreeAutomorphism],
function(a1, a2)
  return Perm(a1) = Perm(a2) and States(a1) = States(a2);
end);


###############################################################################
##
#M  \<(<a1>, <a2>)
##
InstallMethod(\<, [IsTreeAutomorphism and IsTreeAutomorphismRep,
                   IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a1, a2)
  local i;
  if a1!.perm < a2!.perm then return true;
  elif a1!.perm > a2!.perm then return false; fi;
  for i in [1..a1!.deg] do
    if a1!.states[i] < a2!.states[i] then return true;
    elif a1!.states[i] > a2!.states[i] then return false; fi;
  od;
  return false;
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
  SetIsActingOnHomogeneousTree(a, IsActingOnHomogeneousTree(a1));
  return a;
end);


###############################################################################
##
#M  \*(<a1>, <a2>)
##
InstallMethod(\*, [IsTreeAutomorphism, IsTreeAutomorphism],
function(a1, a2)
  local s1, s2, p1, p2, states, perm, d, a;
  s1 := States(a1); p1 := Perm(a1);
  s2 := States(a2); p2 := Perm(a2);
  states := List([1..Length(s1)], i -> s1[i] * s2[i^p1]);
  return TreeAutomorphism(states, p1*p2);
end);


###############################################################################
##
#M  InverseOp(<a>)
##
InstallMethod(InverseOp, "InverseOp(IsTreeAutomorphism and IsTreeAutomorphismRep)",
              [IsTreeAutomorphism and IsTreeAutomorphismRep],
function(a)
  local inv;
  inv := Objectify(NewType(FamilyObj(a), IsTreeAutomorphism and IsTreeAutomorphismRep),
            rec(states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1),
                perm := a!.perm ^ -1,
                deg := a!.deg) );
  SetIsActingOnBinaryTree(inv, IsActingOnBinaryTree(a));
  SetIsActingOnHomogeneousTree(inv, IsActingOnHomogeneousTree(a));
  return inv;
end);

InstallMethod(InverseOp, "InverseOp(IsTreeAutomorphism)", [IsTreeAutomorphism],
function(a)
  local states, inv_states, perm;
  states := States(a);
  perm := Inverse(Perm(a));
  inv_states := List([1..Length(states)], i -> Inverse(states[i^perm]));
  return TreeAutomorphism(inv_states, perm);
end);


#E
