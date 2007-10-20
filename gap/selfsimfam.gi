#############################################################################
##
#W  selfsimfam.gi            automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.0
##
#Y  Copyright (C) 2003 - 2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsSelfSimFamilyRep
##
##  Any object from category SelfSimFamily which is created here, lies in a
##  category IsSelfSimFamilyRep.
##  Family of SelfSim object  < a >  contains all essential information about
##  (mathematical) automaton which generates group containing  < a > :
##  it contains automaton, properties of automaton and group generated by it,
##  etc.
##  Also family contains group generated by states of underlying automaton.
##
DeclareRepresentation("IsSelfSimFamilyRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      [ "freegroup",      # IsSelfSim objects store words from this group
                        "freegens",       # list [f1, f2, ..., fn, f1^-1, ..., fn^-1, 1]
                                          # where f1..fn are generators of freegroup,
                                          # n is numstates; 1 is stored if and only if
                                          # trivstate is not zero.
                                          # Some fi^-1 may be missing if corresponding
                                          # generator is not invertible (but the list still
                                          # has the length of 2n + 1).
                        "numstates",      # number of non - trivial generating states
                        "deg",
                        "trivstate",      # 0 or 2*numstates + 1
                        "isgroup",        # whether all generators are invertible
                        "names",          # list of non - trivial generating states
                        "recurlist",      # the automaton table, states correspond to freegens
                        "oldstates",      # mapping from states in the original table used to
                                          # define the group to the states in recurlist:
                                          # SelfSim(fam!.freegens[oldtstates[k]], fam) is the element
                                          # which corresponds to k-th state in the original automaton
                        "rws",            # rewriting system
                        "use_rws",        # whether to use rewriting system in multiplication
                        "use_contraction" # whether to use contraction in IsOne
                      ]);


BindGlobal("AG_FixRecurList",
function(list, oldstates, names)
  local i, j, k, reduced, deg, isgroup, numstates, perm, trivstate, trivstates, new_trivstates;

  deg := Length(list[1]) - 1;
  isgroup := true;
  trivstate := 0;
  trivstates := [];
  numstates := Length(list);

  # convert list to a "canonical" form

  for i in [1..numstates] do
    for j in [1..deg] do
      if not IsList(list[i][j]) then list[i][j] := [list[i][j]]; fi;
    od;
  od;

  # find if there are any "obviously" trivial states

  repeat
    new_trivstates := [];
    #  find new trivial states (new ones may appear in every iteration)
    for i in [1..Length(list)] do
      if (not i in trivstates) and AG_IsObviouslyTrivialStateInList(i, list) then
        Add(new_trivstates, i);
        numstates := numstates - 1;
      fi;
    od;

    for trivstate in new_trivstates do
      for i in [1..Length(list)] do
        for j in [1..deg] do
      #  remove trivstate from everywhere
          list[i][j] := Filtered(list[i][j], x -> AbsInt(x) <> trivstate);
      #  freely reduce words
          repeat
            reduced := true;
            for k in [1..Length(list[i][j]) - 1] do
              if list[i][j][k] = -list[i][j][k + 1] then
                Remove(list[i][j], k);
                Remove(list[i][j], k);
                reduced := false;
                break;
              fi;
            od;
          until reduced;
        od;
      od;
    od;
    Append(trivstates, new_trivstates);
  until new_trivstates = [];

  # move trivial state to the end
  Sort(trivstates);
  trivstates := Reversed(trivstates);

  for trivstate in trivstates do
    for i in [1..Length(list)] do
      for j in [1..deg] do
    #  remove trivstate from everywhere
        Apply(list[i][j], function(x)
                            if x > trivstate then return x - 1;
                            elif x < -trivstate then return x + 1;
                            fi;
                            return x;
                          end);
      od;
    od;

    for i in [1..Length(oldstates)] do
      if oldstates[i] = trivstate then
        oldstates[i] := 2*numstates + 1;
      elif oldstates[i] > trivstate then
        oldstates[i] := oldstates[i] - 1;
      fi;
    od;
    Remove(list, trivstate);
    Remove(names, trivstate);
  od;

  if trivstates <> [] then
    trivstate := 2*numstates + 1;
    list[trivstate] := List([1..deg], k -> []);
    list[trivstate][deg + 1] := ();
  fi;


  # add inverses of states
  for i in [1..numstates] do
    if AG_IsInvertibleStateInList(i, list) then
      list[i + numstates] := [];

      list[i][deg + 1] := AG_PermFromTransformation(list[i][deg + 1]);

      perm := list[i][deg + 1];
      list[i + numstates][deg + 1] := perm^-1;
      for j in [1..deg] do
        list[i + numstates][j] := -Reversed(list[i][j^(perm^-1)]);
      od;
    else
      isgroup := false;
      if AG_IsInvertibleTransformation(list[i][deg + 1]) then
        list[i][deg + 1] := AG_PermFromTransformation(list[i][deg + 1]);
      fi;
    fi;
  od;

  return [list, numstates, trivstate, isgroup];
end);


###############################################################################
##
#M  SelfSimFamily( <list>, <names>, <bind_vars> )
##
InstallMethod(SelfSimFamily, "for [IsList, IsList, IsBool]",
              [IsList, IsList, IsBool],
function (list, names, bind_global)
  local deg, tmp, trivstate, numstates, i,
        freegroup, freegens, a, family, oldstates,
        isgroup;

  if not AG_IsCorrectRecurList(list, false) then
    Error("in SelfSimFamily(IsList, IsList, IsString):\n",
          "  given list is not a correct list representing self-similar group\n");
  fi;

# 1. make a local copy of arguments, since they will be modified and put into the result

  list := StructuralCopy(list);
  names := StructuralCopy(names);
  deg := Length(list[1]) - 1;

# 2. Find trivial states, permute states

  oldstates := [1..Length(list)];
  tmp := AG_FixRecurList(list, oldstates, names);
  list := tmp[1];
  numstates := tmp[2];
  trivstate := tmp[3];
  isgroup := tmp[4];

# 3. Create FreeGroup and FreeGens

  freegroup := FreeGroup(names);
  freegens := ShallowCopy(FreeGeneratorsOfFpGroup(freegroup));
  for i in [1..numstates] do
    if IsBound(list[i + numstates]) then
      freegens[i + numstates] := freegens[i]^-1;
    fi;
  od;
  if trivstate <> 0 then
    freegens[trivstate] := One(freegroup);
  fi;

# 4. Create family

  if isgroup then
    family := NewFamily("SelfSimFamily",
                        IsInvertibleSelfSim,
                        IsInvertibleSelfSim,
                        IsSelfSimFamily and IsSelfSimFamilyRep);
  else
    family := NewFamily("SelfSimFamily",
                        IsSelfSim,
                        IsSelfSim,
                        IsSelfSimFamily and IsSelfSimFamilyRep);
  fi;

  family!.isgroup := isgroup;
  family!.deg := deg;
  family!.numstates := numstates;
  family!.trivstate := trivstate;
  family!.names := names;
  family!.freegroup := freegroup;
  family!.freegens := freegens;
  family!.recurlist := list;
  family!.oldstates := oldstates;
  family!.use_rws := false;
  family!.rws := fail;
  family!.use_contraction := false;

  SetIsActingOnBinaryTree(family, deg = 2);
  SetDegreeOfTree(family, deg);
  SetTopDegreeOfTree(family, deg);

  family!.recurgens := [];
  for i in [1..Length(list)] do
    if IsBound(list[i]) then
      family!.recurgens[i]  :=
        $AG_CreateSelfSim(family, freegens[i],
                        List([1..deg], j -> AssocWordByLetterRep(FamilyObj(freegens[1]), list[i][j])),
                        list[i][deg + 1],
                        i > numstates or IsBound(list[i + numstates]));
    fi;
  od;

  # XXX It's evil to bind global names, consider AssignGeneratorVariables
  # XXX Check whether names are actually valid names for variables
  if bind_global then
    for i in [1..family!.numstates] do
      if IsBoundGlobal(family!.names[i]) then
        UnbindGlobal(family!.names[i]);
      fi;
      BindGlobal(family!.names[i], family!.recurgens[i]);
      MakeReadWriteGlobal(family!.names[i]);
    od;
    #BindGlobal(AG_Globals.identity_symbol, One(family));
    #MakeReadWriteGlobal(AG_Globals.identity_symbol);
  fi;

  return family;
end);


###############################################################################
##
#M  SelfSimFamily( <list> )
##
InstallMethod(SelfSimFamily, "for [IsList]", [IsList],
function(list)
  return SelfSimFamily(list, false);
end);


###############################################################################
##
#M  SelfSimFamily( <list>, <bind_vars> )
##
InstallMethod(SelfSimFamily, "for [IsList, IsBool]", [IsList, IsBool],
function(list, bind_vars)
  if not AG_IsCorrectRecurList(list, false) then
    Error("in SelfSimFamily(IsList):\n",
          "  given list is not a correct list representing self-similar group\n");
  fi;

  return SelfSimFamily(list,
                     List([1..Length(list)],
                          i -> Concatenation(AG_Globals.state_symbol, String(i))),
                     bind_vars);
end);


###############################################################################
##
#M  SelfSimFamily( <list>, <names> )
##
InstallMethod(SelfSimFamily, "for [IsList, IsList]", [IsList, IsList],
function(list, names)
  if not AG_IsCorrectRecurList(list, false) then
    Error("in SelfSimFamily(IsList, IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  return SelfSimFamily(list, names, AG_Globals.bind_vars_autom_family);
end);



###############################################################################
##
#M  One( <fam> )
##
InstallOtherMethod(One, "for [IsSelfSimFamily]", [IsSelfSimFamily],
function(fam)
  return $AG_CreateSelfSim(fam, One(fam!.freegroup),
                         List([1..fam!.deg], i -> One(fam!.freegroup)),
                         (), true);
end);


###############################################################################
##
#M  GroupOfSelfSimFamily( <fam> )
##
InstallMethod(GroupOfSelfSimFamily, "for [IsSelfSimFamily]",
              [IsSelfSimFamily],
function(fam)
  local g;

  if not fam!.isgroup then
    return fail;
  fi;

  if fam!.numstates > 0 then
    g := GroupWithGenerators(fam!.recurgens{[1..fam!.numstates]});
  else
    g := Group(One(fam));
  fi;

  SetUnderlyingSelfSimFamily(g, fam);
  SetIsGroupOfSelfSimFamily(g, true);
  # XXX
  SetGeneratingRecurList(g, fam!.recurlist);
  SetRecurList(g, fam!.recurlist);
  SetDegreeOfTree(g, fam!.deg);
  SetTopDegreeOfTree(g, fam!.deg);
  SetIsActingOnBinaryTree(g, fam!.deg = 2);

  return g;
end);

###############################################################################
##
#M  SemigroupOfSelfSimFamily( <fam> )
##
InstallMethod(SemigroupOfSelfSimFamily, "for [IsSelfSimFamily]",
              [IsSelfSimFamily],
function(fam)
  local g;

  if fam!.trivstate <> 0 then
    if fam!.numstates = 0 then
      g := SemigroupByGenerators([One(fam!.recurgens[fam!.trivstate])]);
    else
      g := MonoidByGenerators(fam!.recurgens{[1..fam!.numstates]});
    fi;
  else
    g := SemigroupByGenerators(fam!.recurgens{[1..fam!.numstates]});
  fi;

  SetUnderlyingSelfSimFamily(g, fam);

  # XXX
  SetGeneratingRecurList(g, fam!.recurlist);
  SetRecurList(g, fam!.recurlist);

  SetDegreeOfTree(g, fam!.deg);
  SetTopDegreeOfTree(g, fam!.deg);
  SetIsActingOnBinaryTree(g, fam!.deg = 2);

  return g;
end);


###############################################################################
##
#M  UnderlyingFreeMonoid( <G> )
##
InstallMethod(UnderlyingFreeMonoid, "for [IsSelfSimFamily]",
              [IsSelfSimFamily],
function(fam)
  local monoid;

  if fam!.numstates <> 0 then
    monoid := MonoidByGenerators(GeneratorsOfGroup(fam!.freegroup));
    SetSize(monoid, infinity);
  else
    monoid := MonoidByGenerators(fam!.freegens[1]);
    SetSize(monoid, 1);
  fi;

  return monoid;
end);

###############################################################################
##
#M  UnderlyingFreeGroup( <G> )
##
InstallMethod(UnderlyingFreeGroup, "for [IsSelfSimFamily]",
              [IsSelfSimFamily],
function(fam)
  return fam!.freegroup;
end);


###############################################################################
##
#M  IsObviouslyFiniteState( <G> )
##
##  returns `true' if there are no words longer than 1 in the wreath recursion
InstallMethod(IsObviouslyFiniteState, "for [IsSelfSimFamily]",
              [IsSelfSimFamily],
function(fam)
  local list, g, i;
  list := fam!.recurlist;
  for g in list do
    for i in [1..fam!.deg] do
      if Length(g[i]) > 1 then return false; fi;
    od;
  od;
  IsFiniteState(GroupOfSelfSimFamily(fam));
  return true;
end);


#############################################################################
##
#M  GeneratorsOfOrderTwo( <fam> )
##
InstallOtherMethod(GeneratorsOfOrderTwo, "for [IsObject]", [IsSelfSimFamily],
function(fam)
  if not fam!.isgroup then
    Error("not all generators of the family are invertible");
  fi;
  return Filtered(GeneratorsOfGroup(GroupOfSelfSimFamily(fam)), g -> IsOne(g^2));
end);

#E
