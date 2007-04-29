#############################################################################
##
#W  automfam.gi              automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsAutomFamilyRep
##
##  Any object from category AutomFamily which is created here, lies in a
##  category IsAutomFamilyRep.
##  Family of Autom object <a> contains all essential information about
##  (mathematical) automaton which generates group containing <a>:
##  it contains automaton, properties of automaton and group generated by it,
##  etc.
##  Also family contains group generated by states of underlying automaton.
##
DeclareRepresentation("IsAutomFamilyRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      [ "freegroup",      # IsAutom objects store words from this group
                        "freegens",       # list [f1, f2, ..., fn, f1^-1, ..., fn^-1, 1]
                                          # where f1..fn are generators of freegroup,
                                          # n is numstates; 1 is stored if and only if
                                          # trivstate is not zero
                        "numstates",      # number of non-trivial generating states
                        "deg",
                        "trivstate",      # 0 or 2*numstates+1
                        "names",          # list of non-trivial generating states
                        "automatonlist",  # the automaton table, states correspond to freegens
                        "oldstates",      # mapping from states in the original table used to
                                          # define the group to the states in automatonlist:
                                          # Autom(fam!.freegens[oldtstates[k]], fam) is the element
                                          # which corresponds to k-th state in the original automaton
                        "rws",            # rewriting system
                        "use_rws"         # whether to use rewriting system in multiplication
                      ]);


###############################################################################
##
#M  AutomFamily(<list>, <names>, <bind_global>)
##
InstallOtherMethod(AutomFamily, "AutomFamily(IsList, IsList, IsBool)",
              [IsList, IsList, IsBool],
function (list, names, bind_global)
  local deg, tmp, trivstate, numstates, numallstates, i, j, perm,
        freegroup, freegens, a, family, oldstates;

  if not IsCorrectAutomatonList(list, true) then
    Print("error in AutomFamily(IsList, IsList, IsString):\n  given list is not a correct list representing automaton\n");
    return fail;
  fi;

# 1. make a local copy of arguments, since they will be modified and put into the result

  list := StructuralCopy(list);
  names := StructuralCopy(names);
  deg := Length(list[1]) - 1;

# 2. Reduce automaton, find trivial state, permute states

  tmp := ReducedAutomatonInList(list);
  list := tmp[1];
  oldstates := tmp[3];
  names := List(tmp[2], x->names[x]);

  trivstate := 0;
  for i in [1..Length(list)] do
    if IsTrivialStateInList(i, list) then
      trivstate := i;
    fi;
  od;

  numallstates := Length(list);
  if trivstate = 0 then
    numstates := Length(list);
  else
    numstates := Length(list) - 1;
  fi;

  if trivstate <> 0 then
    for i in [1..Length(oldstates)] do
      if oldstates[i] = trivstate then
        oldstates[i] := 2*numstates + 1;
      fi;
    od;
  fi;

#  if numstates = 0 then
#    Print("error in AutomFamily(IsList, IsList, IsString):\n  don't want to work with trivial automaton\n");
#    return fail;
#  fi;

  # First move trivial state to the end of list
  if trivstate <> 0 then
    if trivstate <> numstates + 1 then
      perm := PermListList([1..Length(list)],
        Concatenation(  [1..(trivstate-1)],
                        [(trivstate+1)..Length(list)],
                        [trivstate] )
      );
      list := PermuteStatesInList(list, perm^-1);
      names := Permuted(names, perm^-1);
    fi;
    trivstate := Length(list);
    names[trivstate] := AutomataParameters.identity_symbol;
  fi;

  # Now add inverses of states and move trivial state to the end
  for i in [1..numstates] do
    list[i+numallstates] := [];
    perm := list[i][deg+1];
    list[i+numallstates][deg+1] := perm^-1;
    for j in [1..deg] do
      list[i+numallstates][j] := list[i][j^(perm^-1)];
      if list[i+numallstates][j] <> trivstate then
        list[i+numallstates][j] := list[i+numallstates][j] + numallstates;
      fi;
    od;
  od;

  if trivstate <> 0 then
    perm := PermListList([1..Length(list)],
      Concatenation([1..numstates],
                    [numstates+2..2*numstates+1],
                    [trivstate])
    );
    list := PermuteStatesInList(list, perm^-1);\
    trivstate := Length(list);
  fi;

# 3. Create FreeGroup and FreeGens

  freegroup := FreeGroup(names{[1..numstates]});
  freegens := ShallowCopy(FreeGeneratorsOfFpGroup(freegroup));
  for i in [1..numstates] do
    freegens[i+numstates] := freegens[i]^-1;
  od;
  if trivstate <> 0 then
    freegens[trivstate] := One(freegroup);
  fi;

# 4. Create family

  family := NewFamily("AutomFamily",
                      IsAutom,
                      IsAutom,
                      IsAutomFamily and IsAutomFamilyRep);

  family!.deg := deg;
  family!.numstates := numstates;
  family!.trivstate := trivstate;
  family!.names := names{[1..numstates]};
  family!.freegroup := freegroup;
  family!.freegens := freegens;
  family!.automatonlist := list;
  family!.oldstates := oldstates;
  family!.use_rws := false;
  family!.rws := fail;

  family!.automgens := [];
  for i in [1..Length(list)] do
    family!.automgens[i] := Objectify(
      NewType(family, IsAutom and IsAutomRep),
      rec(word := freegens[i],
          states := List([1..deg], j -> freegens[list[i][j]]),
          perm := list[i][deg+1],
          deg := deg) );
    # XXX
    SetAutomatonList(family!.automgens[i], list);
    SetAutomatonListInitialState(family!.automgens[i], i);
    IsActingOnBinaryTree(family!.automgens[i]);
  od;

  if bind_global then
    for i in [1..family!.numstates] do
      # I don't make it read'n'write intentionally, in order
      # to avoid accidental overwriting some variable.
      # XXX
      if IsBoundGlobal(family!.names[i]) then
        UnbindGlobal(family!.names[i]);
      fi;
      BindGlobal(family!.names[i], family!.automgens[i]);
      MakeReadWriteGlobal(family!.names[i]);
    od;
    #BindGlobal(AutomataParameters.identity_symbol, One(family));
    #MakeReadWriteGlobal(AutomataParameters.identity_symbol);
  fi;

  return family;
end);


###############################################################################
##
#M  AutomFamily(<list>)
##
InstallOtherMethod(AutomFamily, "method for IsList",
                   [IsList],
function(list)
  if not IsCorrectAutomatonList(list, true) then
    Print("error in AutomFamily(IsList):\n  given list is not a correct list representing automaton\n");
    return fail;
  fi;
  return AutomFamily(list,
    List([1..Length(list)],
      i -> Concatenation(AutomataParameters.state_symbol, String(i))),
    AutomataParameters.bind_vars_autom_family);
end);


###############################################################################
##
#M  AutomFamily(<list>, <names>)
##
InstallMethod(AutomFamily, [IsList, IsList],
function(list, names)
  if not IsCorrectAutomatonList(list, true) then
    Print("error in AutomFamily(IsList, IsList):\n  given list is not a correct list representing automaton\n");
    return fail;
  fi;
  return AutomFamily(list, names, AutomataParameters.bind_vars_autom_family);
end);


###############################################################################
##
#M  AutomFamilyNoBindGlobal(<list>)
##
InstallOtherMethod(AutomFamilyNoBindGlobal, "method for IsList", [IsList],
function(list)
  if not IsCorrectAutomatonList(list, true) then
    Print("error in AutomFamilyNoBindGlobal(IsList):\n",
          "  given list is not a correct list representing automaton\n");
    return fail;
  fi;
  return AutomFamily(list,
    List([1..Length(list)],
      i -> Concatenation(AutomataParameters.state_symbol, String(i))), false);
end);


###############################################################################
##
#M  AutomFamilyNoBindGlobal(<list>, <names>)
##
InstallMethod(AutomFamilyNoBindGlobal,
              "AutomFamilyNoBindGlobal(IsList, IsList)", [IsList, IsList],
function(list, names)
  if not IsCorrectAutomatonList(list, true) then
    Print("error in AutomFamilyNoBindGlobal(IsList):\n",
          "  given list is not a correct list representing automaton\n");
    return fail;
  fi;
  return AutomFamily(list, names, false);
end);


###############################################################################
##
#M  DualAutomFamily(<fam>)
##
InstallMethod(DualAutomFamily, "method for IsAutomFamily",
              [IsAutomFamily],
function(fam)
  local list, dual;
  list := [1..fam!.numstates];
  if fam!.trivstate <> 0 then
    Add(list, fam!.trivstate);
  fi;
  list := MinimalSubAutomatonInlist(list, fam!.automatonlist)[1];
  if not HasDualInList(list) then
    return 0;
  fi;
  dual := AutomFamily(DualAutomatonList(list),
    List([1..DegreeOfTree(fam)], i ->
      Concatenation(AutomataParameters.state_symbol_dual, String(i))));
  SetDualAutomFamily(dual, fam);
  return dual;
end);


###############################################################################
##
#M  DegreeOfTree(<fam>)
##
InstallMethod(DegreeOfTree, "method for IsAutomFamily",
              [IsAutomFamily],
function(fam)
  return fam!.deg;
end);


###############################################################################
##
#M  One(<fam>)
##
InstallOtherMethod(One, "One(IsAutomFamily)", [IsAutomFamily],
function(fam)
  local one;
  one := Objectify(NewType(fam, IsAutom and IsAutomRep),
          rec(word := One(fam!.freegroup),
              states := List([1..fam!.deg], i -> One(fam!.freegroup)),
              perm := (),
              deg := fam!.deg)  );
  SetIsActingOnBinaryTree(one, fam!.deg = 2);
  return one;
end);


###############################################################################
##
#M  GroupOfAutomFamily(<fam>)
##
InstallMethod(GroupOfAutomFamily, "GroupOfAutomFamily(IsAutomFamily)",
              [IsAutomFamily],
function(fam)
  local g;
  if fam!.numstates > 0 then
    g := GroupWithGenerators(fam!.automgens{[1..fam!.numstates]});
  else
    g := Group(One(fam));
  fi;
  SetUnderlyingAutomFamily(g, fam);
  SetIsGroupOfAutomFamily(g, true);
  # XXX
  SetGeneratingAutomatonList(g, fam!.automatonlist);
  SetAutomatonList(g, fam!.automatonlist);
  SetAutomatonListInitialStatesGenerators(g, [1..fam!.numstates]);
  SetDegreeOfTree(g, fam!.deg);
  SetIsActingOnBinaryTree(g, fam!.deg = 2);
  return g;
end);


###############################################################################
##
#M  IsActingOnBinaryTree(<fam>)
##
InstallMethod(IsActingOnBinaryTree, "IsActingOnBinaryTree(IsAutomFamily)",
              [IsAutomFamily],
function(fam)
    return fam!.deg = 2;
end);


###############################################################################
##
#M  AbelImagesGenerators(<fam>)
##
InstallMethod(AbelImagesGenerators, "AbelImagesGenerators(IsAutomFamily)",
              [IsAutomFamily],
function(fam)
  return AbelImageAutomatonInList(fam!.automatonlist);
end);


###############################################################################
##
#M  DiagonalActionOp(<fam>, <n>)
##
InstallMethod(DiagonalActionOp, "DiagonalActionOp(IsAutomFamily, IsPosInt)",
              [IsAutomFamily, IsPosInt],
function(fam, n)
  local names, list, states, dlist;
  list := fam!.automatonlist;
  states := [1..fam!.numstates];
  names := fam!.names;
  if fam!.trivstate <> 0 then
    Add(states, fam!.trivstate);
    Add(names, "e");
  fi;
  dlist := MinimalSubAutomatonInlist(states, list)[1];
  return AutomGroup(DiagonalActionInList(dlist, n, names)[1],
    DiagonalActionInList(dlist, n, names)[2]);
end);


###############################################################################
##
#M  DiagonalAction(<obj>)
##
InstallOtherMethod(DiagonalAction, "DiagonalAction(IsObject)", [IsObject],
function(obj)
  return DiagonalAction(obj, 2);
end);


###############################################################################
##
#M  MultAutomAlphabet(<fam>, <n>)
##
InstallMethod(MultAutomAlphabetOp, "MultAutomAlphabetOp(IsAutomFamily, IsPosInt)",
              [IsAutomFamily, IsPosInt],
function(fam, n)
  local list, states, dlist;
  list := fam!.automatonlist;
  states := [1..fam!.numstates];
  if fam!.trivstate <> 0 then Add(states, fam!.trivstate); fi;
  dlist := MinimalSubAutomatonInlist(states, list)[1];
  return AutomGroup(MultAlphabetInList(dlist, n));
end);


###############################################################################
##
#M  MultAutomAlphabet(<obj>)
##
InstallOtherMethod(MultAutomAlphabet, "MultAutomAlphabet(IsObject)", [IsObject],
function(obj)
  return MultAutomAlphabet(obj, 2);
end);


#############################################################################
##
#M  GeneratorsOfOrderTwo(<fam>)
##
InstallOtherMethod(GeneratorsOfOrderTwo, "MultAutomAlphabet(IsObject)", [IsObject],
function(fam)
  local g,G,res,i;
  G:=GroupOfAutomFamily(fam);
  res:=[];
  for i in [1..fam!.numstates] do
    if IsOne(GeneratorsOfGroup(G)[i]^2) then Add(res,i); fi;
  od;
  return res;
end);

#E
