#############################################################################
##
#W  treeaut.gi                 automata package                Yevgen Muntyan
#W                                                              Dmytro Sachuk
##
##  automata v 0.91 started June 07 2004
##

Revision.treeaut_gi :=
  "@(#)$Id$";


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
MakeReadWriteGlobal("CreatedTreeAutomorphismFamilies");


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
      top_deg < Maximum(MovedPointsPerms([permutation])) then
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
  if k = 1 then return Perm(a); fi;
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
      return false; fi; fi;

  if v^a = v then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomata, 3, "  a fixes vertex ", v);
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
#M  State(<a>, <k>)
##
InstallOtherMethod(State, [IsTreeAutomorphism and IsTreeAutomorphismRep, IsPosInt],
function(a, k)
  if k > a!.deg then Error(); fi;
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
  local i;
  if Perm(a1) <> Perm(a2) then return false; fi;
  for i in [1..TopDegreeOfTree(a1)] do
    if State(a1, i) <> State(a2, i) then return false; fi;
  od;
  return true;
end);


###############################################################################
##
#M  \<(<a1>, <a2>)
##
InstallMethod(\<, [ IsTreeAutomorphism and IsTreeAutomorphismRep,
                    IsTreeAutomorphism and IsTreeAutomorphismRep ],
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
#M  \<(<a1>, <a2>)
##
InstallMethod(\<, [IsTreeAutomorphism, IsTreeAutomorphism],
function(a1, a2)
  local i;
  if Perm(a1) < Perm(a2) then return true;
  elif Perm(a1) > Perm(a2) then return false; fi;
  for i in [1..TopDegreeOfTree(a1)] do
    if State(a1, i) < State(a2, i) then return true;
    elif State(a1, i) > State(a2, i) then return false; fi;
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
InstallMethod(\*, [ IsTreeAutomorphism and IsTreeAutomorphismRep,
                    IsTreeAutomorphism and IsTreeAutomorphismRep ],
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


#E
