#############################################################################
##
#W  treehom.gi                 automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
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
##  AG_CreatedTreeHomomorphismFamilies
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

  sph_ind := AG_ReducedSphericalIndex(sph_ind);
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
  fam!.top_deg := AG_TopDegreeInSphericalIndex(sph_ind);

  AddSet(AG_CreatedTreeHomomorphismFamilies.ind, sph_ind);
  Add(AG_CreatedTreeHomomorphismFamilies.fam, fam);

  return fam;
end);

###############################################################################
##
#M  TreeHomomorphism (<states>, <tr>)
##
InstallMethod(TreeHomomorphism,
              [IsList and IsTreeHomomorphismCollection, IsObject],
function(states, perm)
  local top_deg, bot_deg, ind, fam, a;

  if not IsPerm(perm) and not IsTransformation(perm) then
    Error("The second argument ",perm, "must be a permutation or transformation");
  fi;

  if perm^-1<>fail and
     ForAll(states, IsTreeAutomorphism)
  then
    return TreeAutomorphism(states, AG_PermFromTransformation(perm));
  fi;

  top_deg := Length(states);

  if IsPerm(perm) then
    if not IsOne(perm) and top_deg < Maximum(MovedPoints(perm)) then
      Error("The root permutation ", perm, " must move only points from 1 to the degree ", top_deg, " of the tree");
    fi;
  else
    if not IsOne(perm) and top_deg < DegreeOfTransformation(perm) then
      Error("The root transformation ", perm, " must move only points from 1 to the degree ", top_deg, " of the tree");
    fi;
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
InstallMethod(TreeHomomorphism, [IsObject, IsObject, IsTransformation],
  function(a1, a2, perm) return TreeHomomorphism([a1, a2], perm); end);
InstallMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsTransformation],
  function(a1, a2, a3, perm) return TreeHomomorphism([a1, a2, a3], perm); end);
InstallMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsTransformation],
  function(a1, a2, a3, a4, perm) return TreeHomomorphism([a1, a2, a3, a4], perm); end);
InstallMethod(TreeHomomorphism, [IsObject, IsObject, IsPerm],
  function(a1, a2, perm) return TreeHomomorphism([a1, a2], perm); end);
InstallMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, perm) return TreeHomomorphism([a1, a2, a3], perm); end);
InstallMethod(TreeHomomorphism, [IsObject, IsObject, IsObject, IsObject, IsPerm],
  function(a1, a2, a3, a4, perm) return TreeHomomorphism([a1, a2, a3, a4], perm); end);

###############################################################################
##
#M  ViewObj(<a>)
##
InstallMethod(ViewObj, [IsTreeHomomorphism],
function (a)
    local deg, printword, i, perm, states;

    states := Sections(a);
    deg := Length(states);
    perm := TransformationOnLevel(a, 1);

    Print("(");
    for i in [1..deg] do
        View(states[i]);
        if i <> deg then Print(", "); fi;
    od;
    Print(")");
    if not IsOne(perm) then
      AG_PrintTransformation(perm);
    fi;
end);

###############################################################################
##
#M  PrintObj(<a>)
##
InstallMethod(PrintObj, "for [IsTreeHomomorphism and IsTreeHomomorphismRep]",
                             [IsTreeHomomorphism and IsTreeHomomorphismRep],
function (a)
    local deg, i, states, perm;

    states := Sections(a);
    deg := Length(states);
    perm := TransformationOnLevel(a, 1);

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
    if not IsOne(perm) then
      AG_PrintTransformation(perm);
    fi;
end);


###############################################################################
##
#M  String(<a>)
##
InstallMethod(String, "for [IsTreeHomomorphism]", [IsTreeHomomorphism],
function (a)
    local deg, printword, i, perm, states, str;

    states := Sections(a);
    deg := Length(states);
    perm := TransformationOnLevel(a, 1);
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


###############################################################################
##
#M  TransformationOnLevel (<a>, <k>)
##
InstallMethod(TransformationOnLevelOp, "for [IsTreeHomomorphism, IsPosInt]",
              [IsTreeHomomorphism, IsPosInt],
function(a, k)
  local states, top, first_level, i, j, d1, d2, permuted, p;

  if k = 1 then
    return TransformationOnFirstLevel(a);
  fi;

  # TODO: it is unnesessarily greedy, it could check whether there
  # are trivial permutations below
  d1 := DegreeOfTree(a);
  d2 := 1;
  for i in [2 .. k] do
    d2 := d2 * DegreeOfLevel(a, i);
  od;
  states := Sections(a);
  top := TransformationOnFirstLevel(a);
  first_level := List(states, s -> TransformationOnLevel(s, k-1));
  permuted := [];
  for i in [1..d1] do
    for j in [1..d2] do
      permuted[d2*(i-1) + j] := d2*(i^top - 1) + j^first_level[i];
    od;
  od;

#  p := PermList(permuted);
#  if p = fail then
#    p := Transformation(permuted);
#  fi;
#  return p;

  return Transformation(permuted);
end);

InstallMethod(TransformationOnFirstLevel, [IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a)
  return AsTransformation(a!.perm);
end);


###############################################################################
##
#M  k ^ a
##
InstallMethod(\^, "for [IsPosInt, IsTreeHomomorphism]", [IsPosInt, IsTreeHomomorphism],
function(k, a)
    return k ^ TransformationOnLevel(a, 1);
end);

###############################################################################
##
#M  seq ^ a
##
InstallMethod(\^, "for [IsList, IsTreeHomomorphism]", [IsList, IsTreeHomomorphism],
function(seq, a)
  if Length(seq) = 0 then
    return [];
  elif Length(seq) = 1 then
    return [seq[1]^TransformationOnLevel(a, 1)];
  else
    return Concatenation([seq[1]^TransformationOnLevel(a, 1)],
                         seq{[2..Length(seq)]}^Section(a, seq[1]));
  fi;
end);


# ###############################################################################
# ##
# #M  FixesLevel(<a>, <k>)
# ##
# InstallMethod(FixesLevel, "for [IsTreeHomomorphism, IsPosInt]",
#               [IsTreeHomomorphism, IsPosInt],
# function(a, k)
#   if HasIsSphericallyTransitive(a) then
#     if IsSphericallyTransitive(a) then
#       return false; fi; fi;
#
#   if IsOne(PermOnLevel(a, k)) then
#     Info(InfoAutomGrp, 3, "IsSphericallyTransitive(a): false");
#     Info(InfoAutomGrp, 3, "  a is not transitive on level", k);
#     Info(InfoAutomGrp, 3, "  a = ", a);
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
# InstallOtherMethod(FixesVertex,  "for [IsTreeHomomorphism, IsObject]",
#                    [IsTreeHomomorphism, IsObject],
# function(a, v)
#   if HasIsSphericallyTransitive(a) then
#     if IsSphericallyTransitive(a) then
#       Info(InfoAutomGrp, 3, "FixesVertex(a, v): false");
#       Info(InfoAutomGrp, 3, "  IsSphericallyTransitive(a)");
#       Info(InfoAutomGrp, 3, "  a = ", a);
#       return false;
#     fi;
#   fi;
#
#   if v^a = v then
#     Info(InfoAutomGrp, 3, "IsSphericallyTransitive(a): false");
#     Info(InfoAutomGrp, 3, "  a fixes vertex ", v);
#     Info(InfoAutomGrp, 3, "  a = ", a);
#     SetIsSphericallyTransitive(a, false);
#     return true;
#   else
#     return false;
#   fi;
# end);


###############################################################################
##
#M  Section(<a>, <k>)
##
InstallMethod(Section, [IsTreeHomomorphism, IsPosInt],
function(a, k)
  return Sections(a)[k];
end);

InstallMethod(Section, [IsTreeHomomorphism and IsTreeHomomorphismRep, IsPosInt],
function(a, k)
  return a!.states[k];
end);


###############################################################################
##
#M  Section(<a>, <v>)
##
InstallMethod(Section, [IsTreeHomomorphism, IsList],
function(a, v)
  if Length(v) = 1 then
    return Section(a, v[1]);
  else
    return Section(Section(a, v[1]), v{[2..Length(v)]});
  fi;
end);


###############################################################################
##
#M  Sections(<a>)
##
InstallMethod(Sections, [IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a)
  return a!.states;
end);


###############################################################################
##
#M  Sections(a, k)
##
InstallMethod(Sections, "for [IsTreeHomomorphism, IsPosInt]",
                   [IsTreeHomomorphism, IsPosInt],
function(a, level)
  if level = 1 then
    return Sections(a);
  else
    return Concatenation(List(Sections(a), s -> Sections(s, level-1)));
  fi;
end);

InstallMethod(Sections, "for [IsTreeHomomorphism, IsInt and IsZero]", [IsTreeHomomorphism, IsInt and IsZero],
function(a, level)
  return [a];
end);


###############################################################################
##
#M  Decompose(<a>, <k>)
##
InstallMethod(Decompose, "for [IsTreeHomomorphism, IsPosInt]",
              [IsTreeHomomorphism, IsPosInt],
function(a, level)
  return TreeHomomorphism(Sections(a, level), TransformationOnLevel(a, level));
end);

InstallMethod(Decompose, [IsTreeHomomorphism, IsInt and IsZero],
function(a, level)
  return a;
end);


###############################################################################
##
#M  Decompose(<a>)
##
InstallMethod(Decompose, "for [IsTreeHomomorphism]",
              [IsTreeHomomorphism],
function(a)
  return Decompose(a, 1);
end);


###############################################################################
##
#M  IsOne(<a>)
##
InstallMethod(IsOne, "for [IsTreeHomomorphism]",
              [IsTreeHomomorphism],
function(a)
  local s;

  if not IsOne(TransformationOnLevel(a, 1)) then
    return false;
  fi;

  for s in Sections(a) do
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
# TODO: can lead to infinite recursion
InstallMethod(\=, "for [IsTreeHomomorphism, IsTreeHomomorphism]", ReturnTrue,
              [IsTreeHomomorphism, IsTreeHomomorphism],
function(a1, a2)
  return TransformationOnLevel(a1, 1) = TransformationOnLevel(a2, 1) and
          Sections(a1) = Sections(a2);
end);


###############################################################################
##
#M  \<(<a1>, <a2>)
##
InstallMethod(\<, [IsTreeHomomorphism and IsTreeHomomorphismRep,
                   IsTreeHomomorphism and IsTreeHomomorphismRep],
function(a1, a2)
  return AG_TreeHomomorphismCmp(a1, a2) < 0;
end);


###############################################################################
##
##  AG_TreeHomomorphismCmp(a1, a2)
##
##  Global function to be used from IsTreeAutomomorphism too
##
InstallGlobalFunction(AG_TreeHomomorphismCmp,
function(a1, a2)
  local i, cmp;

  cmp := AG_TrCmp(a1!.perm, a2!.perm, a1!.deg);

  if cmp < 0 then
    return -1;
  elif cmp > 0 then
    return 1;
  fi;

  for i in [1..a1!.deg] do
    if a1!.states[i] < a2!.states[i] then
      return -1;
    elif a1!.states[i] > a2!.states[i] then
      return 1;
    fi;
  od;

  return 0;
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
  return Section(a, k);
end);


###############################################################################
##
#M  Representative( <word>, <fam> )
##
InstallMethod(Representative, "for [IsAssocWord, IsTreeHomomorphismFamily]",
              [IsAssocWord, IsTreeHomomorphismFamily],
function( word, fam )
  if IsAutomFamily( fam ) then return Autom( word, fam );
  elif IsSelfSimFamily( fam ) then return SelfSim( word, fam );
  else Error("the family <fam> must be either IsAutomFamily or IsSelfSimFamily");
  fi;
end);


###############################################################################
##
#M  Representative( <word>, <a> )
##
InstallMethod(Representative, "for [IsAssocWord, IsTreeHomomorphism]",
              [IsAssocWord, IsTreeHomomorphism],
function( word, a )
  local fam;
  fam := FamilyObj(a);
  if IsAutomFamily( fam ) then return Autom( word, fam );
  elif IsSelfSimFamily( fam ) then return SelfSim( word, fam );
  else Error("the homomorphism <a> must be either from IsAutomFamily or from IsSelfSimFamily");
  fi;
end);


# ###############################################################################
# ##
# #M  InverseOp(<a>)
# ##
# InstallMethod(InverseOp, "for [IsTreeHomomorphism and IsTreeHomomorphismRep]",
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
# InstallMethod(InverseOp, "for [IsTreeHomomorphism]", [IsTreeHomomorphism],
# function(a)
#   local states, inv_states, perm;
#   states := Sections(a);
#   perm := Inverse(Perm(a));
#   inv_states := List([1..Length(states)], i -> Inverse(states[i^perm]));
#   return TreeHomomorphism(inv_states, perm);
# end);





#E
