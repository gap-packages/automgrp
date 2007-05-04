#############################################################################
##
#W  treehom.gi                 automgrp package                Yevgen Muntyan
#W                                                              Dmytro Sachuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsTreeHomomorphismRep
##
DeclareRepresentation("IsTreeHomomorphismRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["states", "perm", "deg"]);

###############################################################################
##
#R  IsTreeHomomorphismFamilyRep
##
DeclareRepresentation("IsTreeHomomorphismFamilyRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["spher_index", "top_deg"]);

###############################################################################
##
#V  AG_CreatedTreeHomomorphismFamilies
##
##  Contains all created TreeHomomorphismFamily objects; for each spherical
##  index there exists one family, to which all objects created with TreeHomomorphism
##  belong.
##
BindGlobal("AG_CreatedTreeHomomorphismFamilies", rec(ind := [], fam := []));

###############################################################################
##
#M  TreeHomomorphismFamily(<sph_ind>)
##
InstallMethod(TreeHomomorphismFamily, [IsRecord],
function(sph_ind)
  local fam, pos;

  sph_ind := ReducedSphericalIndex(sph_ind);
  if sph_ind in AG_CreatedTreeHomomorphismFamilies.ind then
    for fam in AG_CreatedTreeHomomorphismFamilies.fam do
      if fam!.spher_index = sph_ind then
        return fam;
      fi;
    od;
  fi;

  fam := NewFamily(Concatenation("Automorphisms of ", sph_ind.start, ", (", sph_ind.period, ")-tree"),
                   IsTreeHomomorphism, IsTreeHomomorphism,
                   IsTreeHomomorphismFamily and IsTreeHomomorphismFamilyRep);
  fam!.spher_index := sph_ind;
  fam!.top_deg := TopDegreeInSphericalIndex(sph_ind);

  AddSet(AG_CreatedTreeHomomorphismFamilies.ind, sph_ind);
  Add(AG_CreatedTreeHomomorphismFamilies.fam, fam);

  return fam;
end);

###############################################################################
##
#M  TreeHomomorphism (<states>, <tr>)
##
InstallMethod(TreeHomomorphism,
              [IsList and IsTreeHomomorphismCollection, IsTransformation],
function(states, perm)
  local top_deg, bot_deg, ind, fam;

  top_deg := Length(states);

  if not IsOne(perm) and top_deg < DegreeOfTransformation(perm) then
    Error();
  fi;

  bot_deg := DegreeOfTree(states[1]);
  ind := rec(start := [top_deg], period := [bot_deg]);
  fam := TreeHomomorphismFamily(ind);

  return Objectify(NewType(fam, IsTreeHomomorphism and IsTreeHomomorphismRep),
                   rec(states := ShallowCopy(states),
                       perm := perm,
                       deg := top_deg));
end);

###############################################################################
##
#M  TreeHomomorphism (<states_list>, <perm>)
##
InstallMethod(TreeHomomorphism, [IsList, IsTransformation],
function(states, perm)
  local autom, nstates, s;

  autom := fail;

  for s in states do
    if IsTreeHomomorphism(s) then
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

  return TreeHomomorphism(nstates, perm);
end);

###############################################################################
##
#M  TreeHomomorphism(<state_1>, <state_2>, ..., <state_n>, <perm>)
##
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsTransformation],
  function(a1, a2, perm) return TreeHomomorphism([a1, a2], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsTransformation],
  function(a1, a2, a3, perm) return TreeHomomorphism([a1, a2, a3], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsTransformation],
  function(a1, a2, a3, a4, perm) return TreeHomomorphism([a1, a2, a3, a4], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsTransformation],
  function(a1, a2, a3, a4, a5, perm) return TreeHomomorphism([a1, a2, a3, a4, a5], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsObject, IsTransformation],
  function(a1, a2, a3, a4, a5, a6, perm) return TreeHomomorphism([a1, a2, a3, a4, a5, a6], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsPerm],
  function(a1, a2, perm) return TreeHomomorphism([a1, a2], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, perm) return TreeHomomorphism([a1, a2, a3], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, perm) return TreeHomomorphism([a1, a2, a3, a4], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, a5, perm) return TreeHomomorphism([a1, a2, a3, a4, a5], perm); end);
InstallOtherMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, a5, a6, perm) return TreeHomomorphism([a1, a2, a3, a4, a5, a6], perm); end);

###############################################################################
##
#M  ViewObj(<a>)
##
InstallMethod(ViewObj, [IsTreeHomomorphism],
function (a)
    local deg, printword, i, perm, states;

    states := States(a);
    deg := Length(states);
    perm := TransformationOnLevel(a, 1);

    Print("(");
    for i in [1..deg] do
        View(states[i]);
        if i <> deg then Print(", "); fi;
    od;
    Print(")");
    if not IsOne(perm) then Print(perm); fi;
end);


###############################################################################
##
#M  SphericalIndex (<a>)
##
InstallMethod(SphericalIndex, [IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a)
  return FamilyObj(a)!.spher_index;
end);
InstallMethod(TopDegreeOfTree, [IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a)
  return FamilyObj(a)!.top_deg;
end);


# ###############################################################################
# ##
# #M  TransformationOnLevel (<a>, <k>)
# ##
# InstallMethod(TransformationOnLevelOp, "method for IsTreeHomomorphism and IsPosInt",
#               [IsTreeHomomorphism, IsPosInt],
# function(a, k)
#   local states, top, first_level, i, j, d1, d2, permuted;
#
#   if k = 1 then
#     return Perm(a);
#   fi;
#
#   # XXX test this function
#
#   # TODO: it goes through all vertices of the second level, it may be
#   # unnecessary for sparse actions
#   d1 := a!.deg;
#   d2 := 1;
#   for i in [2 .. k] do
#     d2 := d2 * DegreeOfLevel(a, i);
#   od;
#   states := States(a);
#   top := Perm(a);
#   first_level := List(states, s -> PermOnLevel(s, k-1));
#   permuted := [];
#   for i in [1..d1] do
#     for j in [1..d2] do
#       permuted[d2*(i-1) + j] := d2*(i^top - 1) + j^first_level[i];
#     od;
#   od;
#   return PermList(permuted);
# end);


###############################################################################
##
#M  k ^ a
##
InstallOtherMethod(\^, "\^(IsPosInt, IsTreeHomomorphism)", [IsPosInt, IsTreeHomomorphism],
function(k, a)
    return k ^ TransformationOnLevel(a, 1);
end);

###############################################################################
##
#M  seq ^ a
##
InstallOtherMethod(\^, "\^(IsList, IsTreeHomomorphism)", [IsList, IsTreeHomomorphism],
function(seq, a)
  if Length(seq) = 0 then
    return [];
  elif Length(seq) = 1 then
    return [seq[1]^TransformationOnLevel(a, 1)];
  else
    return Concatenation([seq[1]^TransformationOnLevel(a, 1)],
                         seq{[2..Length(seq)]}^State(a, seq[1]));
  fi;
end);


# ###############################################################################
# ##
# #M  FixesLevel(<a>, <k>)
# ##
# InstallMethod(FixesLevel, "method for IsTreeHomomorphism and IsPosInt",
#               [IsTreeHomomorphism, IsPosInt],
# function(a, k)
#   if HasIsSphericallyTransitive(a) then
#     if IsSphericallyTransitive(a) then
#       return false; fi; fi;
#
#   if IsOne(PermOnLevel(a, k)) then
#     Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
#     Info(InfoAutomata, 3, "  a is not transitive on level", k);
#     Info(InfoAutomata, 3, "  a = ", a);
#     SetIsSphericallyTransitive(a, false);
#     return true;
#   else
#     return false;
#   fi;
# end);
#
#
# ###############################################################################
# ##
# #M  FixesVertex(<a>, <v>)
# ##
# InstallOtherMethod(FixesVertex,  "method for IsTreeHomomorphism and IsObject",
#                    [IsTreeHomomorphism, IsObject],
# function(a, v)
#   if HasIsSphericallyTransitive(a) then
#     if IsSphericallyTransitive(a) then
#       Info(InfoAutomata, 3, "FixesVertex(a, v): false");
#       Info(InfoAutomata, 3, "  IsSphericallyTransitive(a)");
#       Info(InfoAutomata, 3, "  a = ", a);
#       return false;
#     fi;
#   fi;
#
#   if v^a = v then
#     Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
#     Info(InfoAutomata, 3, "  a fixes vertex ", v);
#     Info(InfoAutomata, 3, "  a = ", a);
#     SetIsSphericallyTransitive(a, false);
#     return true;
#   else
#     return false;
#   fi;
# end);


###############################################################################
##
#M  State(<a>, <k>)
##
InstallMethod(State, [IsTreeHomomorphism, IsPosInt],
function(a, k)
  return States(a)[k];
end);

InstallMethod(State, [IsTreeHomomorphism and IsTreeHomomorphismRep, IsPosInt],
function(a, k)
  return a!.states[k];
end);


###############################################################################
##
#M  State(<a>, <v>)
##
InstallMethod(State, [IsTreeHomomorphism, IsList],
function(a, v)
  if Length(v) = 1 then
    return State(a, v[1]);
  else
    return State(State(a, v[1]), v{[2..Length(v)]});
  fi;
end);


###############################################################################
##
#M  States(<a>)
##
InstallMethod(States, [IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a)
  return a!.states;
end);


###############################################################################
##
#M  States(a, k)
##
InstallOtherMethod(States, "States(IsTreeHomomorphism, IsPosInt)",
                   [IsTreeHomomorphism, IsPosInt],
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
InstallMethod(Expand, [IsTreeHomomorphism, IsPosInt],
function(a, level)
  return TreeHomomorphism(States(a, level), TransformationOnLevel(a, level));
end);

InstallOtherMethod(Expand, [IsTreeHomomorphism, IsInt and IsZero],
function(a, level)
  return a;
end);


###############################################################################
##
#M  Expand(<a>)
##
InstallMethod(Expand, [IsTreeHomomorphism],
function(a)
  return Expand(a, 1);
end);


###############################################################################
##
#M  IsOne(<a>)
##
InstallMethod(IsOne, [IsTreeHomomorphism],
function(a)
  local s;

  if not IsOne(TransformationOnLevel(a, 1)) then
    return false;
  fi;

  for s in States(a) do
    if not IsOne(s) then
      return false;
    fi;
  od;

  return true;
end);


###############################################################################
##
#M  \=(<a1>, <a2>)
##
InstallMethod(\=, [IsTreeHomomorphism, IsTreeHomomorphism],
function(a1, a2)
  return TransformationOnLevel(a1, 1) = TransformationOnLevel(a2, 1) and
          States(a1) = States(a2);
end);


###############################################################################
##
#M  \<(<a1>, <a2>)
##
InstallMethod(\<, [IsTreeHomomorphism and IsTreeHomomorphismRep,
                   IsTreeHomomorphism and IsTreeHomomorphismRep],
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
InstallMethod(OneOp, [IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a)
  return Objectify(NewType(FamilyObj(a), IsTreeHomomorphism and IsTreeHomomorphismRep),
                   rec(states := List([1..a!.deg], i -> One(a!.states[1])),
                       perm := Transformation([1..a!.deg]),
                       deg := a!.deg));
end);


###############################################################################
##
#M  \*(<a1>, <a2>)
##
InstallMethod(\*, [IsTreeHomomorphism and IsTreeHomomorphismRep,
                   IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a1, a2)
  local a;
  a := Objectify(NewType(FamilyObj(a1), IsTreeHomomorphism and IsTreeHomomorphismRep),
        rec(states := List([1..a1!.deg], i -> a1!.states[i] * a2!.states[i^(a1!.perm)]),
            perm := a1!.perm * a2!.perm,
            deg := a1!.deg));
  SetIsActingOnBinaryTree(a, IsActingOnBinaryTree(a1));
  SetIsActingOnRegularTree(a, IsActingOnRegularTree(a1));
  return a;
end);


###############################################################################
##
#M  \[\](<a1>, <a2>)
##
InstallOtherMethod(\[\], [IsTreeHomomorphism, IsPosInt],
function(a, k)
  return State(a, k);
end);


# ###############################################################################
# ##
# #M  InverseOp(<a>)
# ##
# InstallMethod(InverseOp, "InverseOp(IsTreeHomomorphism and IsTreeHomomorphismRep)",
#               [IsTreeHomomorphism and IsTreeHomomorphismRep],
# function(a)
#   local inv;
#   inv := Objectify(NewType(FamilyObj(a), IsTreeHomomorphism and IsTreeHomomorphismRep),
#             rec(states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1),
#                 perm := a!.perm ^ -1,
#                 deg := a!.deg) );
#   SetIsActingOnBinaryTree(inv, IsActingOnBinaryTree(a));
#   SetIsActingOnRegularTree(inv, IsActingOnRegularTree(a));
#   return inv;
# end);
#
# InstallMethod(InverseOp, "InverseOp(IsTreeHomomorphism)", [IsTreeHomomorphism],
# function(a)
#   local states, inv_states, perm;
#   states := States(a);
#   perm := Inverse(Perm(a));
#   inv_states := List([1..Length(states)], i -> Inverse(states[i^perm]));
#   return TreeHomomorphism(inv_states, perm);
# end);


#E
