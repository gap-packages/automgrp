#############################################################################
##
#W  automsg.gi               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  AutomatonSemigroup(<list>)
##
InstallMethod(AutomatonSemigroup, "for [IsList]", [IsList],
function (list)
  return AutomatonSemigroup(list, false);
end);


###############################################################################
##
#M  AutomatonSemigroup(<list>, <bind_vars>)
##
InstallMethod(AutomatonSemigroup, "for [IsList, IsBool]", [IsList, IsBool],
function (list, bind_vars)
  if not AG_IsCorrectAutomatonList(list, false) then
    Error("in AutomatonSemigroup(IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  # XXX
  return SemigroupOfAutomFamily(AutomFamily(list, bind_vars));
end);


###############################################################################
##
#M  AutomatonSemigroup(<list>, <names>)
##
InstallMethod(AutomatonSemigroup, "for [IsList, IsList]", [IsList, IsList],
function (list, names)
  if not AG_IsCorrectAutomatonList(list, false) then
    Error("error in AutomatonSemigroup(IsList, IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  # XXX
  return SemigroupOfAutomFamily(AutomFamily(list, names));
end);


###############################################################################
##
#M  AutomatonSemigroup(<list>, <names>, <bind_vars>)
##
InstallMethod(AutomatonSemigroup, "for [IsList, IsList, IsBool]",
              [IsList, IsList, IsBool],
function (list, names, bind_vars)
  if not AG_IsCorrectAutomatonList(list, false) then
    Error("error in AutomatonSemigroup(IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  #XXX
  return SemigroupOfAutomFamily(AutomFamily(list, names, bind_vars));
end);


###############################################################################
##
#M  AutomatonSemigroup(<string>)
#M  AutomatonSemigroup(<string>, <bind_vars>)
##
InstallMethod(AutomatonSemigroup, "for [IsString]", [IsString],
function(string)
    return AutomatonSemigroup(string, AG_Globals.bind_vars_autom_family);
end);
InstallMethod(AutomatonSemigroup, "AutomatonSemigroup(IsString, IsBool]", [IsString, IsBool],
function(string, bind_vars)
    local s;
    s := AG_ParseAutomatonString(string);
    return AutomatonSemigroup(s[2], s[1], bind_vars);
end);


###############################################################################
##
#M  AutomatonSemigroup(<A>)
#M  AutomatonSemigroup(<A>, <bind_vars>)
##
InstallMethod(AutomatonSemigroup, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  return AutomatonSemigroup(AutomatonList(A), A!.states);
end);

InstallMethod(AutomatonSemigroup, "for [IsMealyAutomaton, IsBool]", [IsMealyAutomaton, IsBool],
function(A, bind_vars)
  return AutomatonSemigroup(AutomatonList(A), A!.states, bind_vars);
end);


###############################################################################
##
#M  IsSelfSimilar(<G>)
##
InstallMethod(IsSelfSimilar, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  local g, i, res;
  res := true;
  for g in GeneratorsOfSemigroup(G) do
    for i in [1..UnderlyingAutomFamily(G)!.deg] do
      res := Section(g, i) in G;
      if res = fail then
        TryNextMethod();
      elif not res then
        return false;
      fi;
    od;
  od;
  return true;
end);

###############################################################################
##
#M  UnderlyingAutomFamily(<G>)
##
InstallMethod(UnderlyingAutomFamily, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return FamilyObj(GeneratorsOfSemigroup(G)[1]);
end);


# ###############################################################################
# ##
# #M  UseSubsetRelation(<G>)
# ##
# InstallMethod(UseSubsetRelation,
#               "for [IsAutomSemigroup, IsAutomSemigroup]",
#               [IsAutomSemigroup, IsAutomSemigroup],
# function(super, sub)
#   ## the full group is self similar, so if <super> is smaller than the full
#   ##  group then sub is smaller either
#   if HasIsGroupOfAutomFamily(super) then
#     if not IsGroupOfAutomFamily(super) then
#       SetIsGroupOfAutomFamily(sub, false); fi; fi;
#   TryNextMethod();
# end);


# ###############################################################################
# ##
# #M  __AG_SubgroupOnLevel(<G>, <gens>, <level>)
# ##
# InstallMethod(__AG_SubgroupOnLevel, [IsAutomGroup,
#                                  IsList and IsTreeAutomorphismCollection,
#                                  IsPosInt],
# function(G, gens, level)
#   local overgroup;
#
#   if IsEmpty(gens) or (Length(gens) = 1 and IsOne(gens[1])) then
#     return TrivialSubgroup(G);
#   fi;
#
#   if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
#     overgroup := G;
#   else
#     overgroup := GroupOfAutomFamily(UnderlyingAutomFamily(G));
#   fi;
#
#   return SubgroupNC(overgroup, gens);
# end);
#
# InstallOtherMethod(__AG_SubgroupOnLevel, [IsAutomGroup, IsList and IsEmpty, IsPosInt],
# function(G, gens, level)
#   return TrivialSubgroup(G);
# end);
#
# InstallMethod(__AG_SubgroupOnLevel, [IsTreeAutomorphismGroup,
#                                  IsList and IsAutomCollection,
#                                  IsPosInt],
# function(G, gens, level)
#   local overgroup;
#
#   overgroup := GroupOfAutomFamily(FamilyObj(gens[1]));
#
#   if Length(gens) = 1 and IsOne(gens[1]) then
#     return TrivialSubgroup(overgroup);
#   fi;
#
#   return SubgroupNC(overgroup, gens);
# end);
#
# InstallMethod(__AG_SimplifyGroupGenerators, [IsList and IsAutomCollection],
# function(gens)
#   local words, fam;
#
#   if IsEmpty(gens) then
#     return [];
#   fi;
#
#   fam := FamilyObj(gens[1]);
#   words := FreeGeneratorsOfGroup(Group(List(gens, a -> a!.word)));
#
#   if fam!.use_rws and not IsEmpty(words) then
#     words := AG_ReducedForm(fam!.rws, words);
#     words := FreeGeneratorsOfGroup(Group(words));
#   fi;
#
#   return List(words, w -> Autom(w, fam));
# end);


###############################################################################
##
#M  DegreeOfTree(<G>)
##
InstallMethod(DegreeOfTree, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return DegreeOfTree(UnderlyingAutomFamily(G));
end);

InstallMethod(TopDegreeOfTree, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return DegreeOfTree(UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, "for [IsAutomatonSemigroup]",
              [IsAutomatonSemigroup],
function(G)
  Print("AutomatonSemigroup(\"", String(G), "\")");
end);


#############################################################################
##
#M  String(<G>)
##
InstallMethod(String, "for [IsAutomSemigroup]", [IsAutomSemigroup],
function(G)
  local i, gens, formatone, s;

  formatone := function(a)
    return Concatenation(String(a), " = ", String(Decompose(a)));
  end;

  if IsMonoid(G) then
    gens := GeneratorsOfMonoid(G);
  else
    gens := GeneratorsOfSemigroup(G);
  fi;

  s := "";
  for i in [1..Length(gens)] do
    Append(s, formatone(gens[i]));
    if i <> Length(gens) then
      Append(s, ", ");
    fi;
  od;

  return s;
end);


###############################################################################
##
#M  Display(<G>)
##
InstallMethod(Display, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  local i, gens, printone;

  printone := function(a)
    Print(a, " = ", Decompose(a));
  end;

  gens := GeneratorsOfSemigroup(G);
  if gens = [] then Print("< >"); fi;
  if Length(gens) = 1 then
    Print("< "); printone(gens[1]); Print(" >");
  else
    Print("< "); printone(gens[1]); Print(", \n");
    for i in [2..Length(gens)-1] do
      Print("  "); printone(gens[i]); Print(", \n");
    od;
    Print("  "); printone(gens[Length(gens)]); Print(" >");
  fi;
end);


###############################################################################
##
#M  ViewObj(<G>)
##
InstallMethod(ViewObj, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  local i, gens;
  gens := List(GeneratorsOfSemigroup(G), g -> Word(g));
  if gens = [] then Print("< >"); fi;
  Print("< ");
  for i in [1..Length(gens)-1] do
    if IsOne(gens[i]) then
      Print(AG_Globals.identity_symbol, ", ");
    else
      Print(gens[i], ", ");
    fi;
  od;
  if IsOne(gens[Length(gens)]) then
    Print(AG_Globals.identity_symbol, " >");
  else
    Print(gens[Length(gens)], " >");
  fi;
end);


###############################################################################
##
#M  IsTrivial(G)
##
InstallMethod(IsTrivial, "for [IsAutomSemigroup]", [IsAutomSemigroup],
function (G)
  local g;
  for g in GeneratorsOfSemigroup(G) do
    if not IsOne(g) then return false; fi;
  od;
  return true;
end);



###############################################################################
##
#M  Size(G)
##
InstallMethod(Size, "for [IsAutomSemigroup]", [IsAutomSemigroup],
function (G)
  local g;
  if IsTrivial(G) then
    Info(InfoAutomGrp, 3, "Size(G): 1, G is trivial");
    return 1;
  fi;

  for g in Iterator(G) do od;

  return Size(G);
#  TryNextMethod();
end);


# ###############################################################################
# ##
# #M  \= (<G>, <H>)
# ##
# InstallMethod(\=, "for [IsAutomGroup, IsAutomGroup]",
#               IsIdenticalObj, [IsAutomGroup, IsAutomGroup],
# function(G, H)
#   local fgens1, fgens2, fam;
#
#   if HasIsGroupOfAutomFamily(G) and HasIsGroupOfAutomFamily(H) then
#     if IsGroupOfAutomFamily(G) <> IsGroupOfAutomFamily(H) then
#       Info(InfoAutomGrp, 3, "G = H: false, exactly one is GroupOfAutomFamily");
#       return false;
#     fi;
#     if IsGroupOfAutomFamily(G) then
#       Info(InfoAutomGrp, 3, "G = H: true, both are GroupOfAutomFamily");
#       return true;
#     fi;
#   fi;
#
#   fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
#   fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
#   fam := UnderlyingAutomFamily(G);
#
#   if fam!.rws <> fail then
#     fgens1 := AsSet(AG_ReducedForm(fam!.rws, fgens1));
#     fgens2 := AsSet(AG_ReducedForm(fam!.rws, fgens2));
#   fi;
#
#   if GroupWithGenerators(fgens1) = GroupWithGenerators(fgens2) then
#     Info(InfoAutomGrp, 3, "G = H: true, by subgroups of free group");
#     return true;
#   fi;
#
#   TryNextMethod();
# end);


# ###############################################################################
# ##
# #M  IsSubset (<G>, <H>)
# ##
# InstallMethod(IsSubset, "for [IsAutomGroup, IsAutomGroup]",
#               IsIdenticalObj, [IsAutomGroup, IsAutomGroup],
# function(G, H)
#   local h, fam, fgens1, fgens2;
#
#   if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
#     Info(InfoAutomGrp, 3, "IsSubgroup(G, H): true");
#     Info(InfoAutomGrp, 3, "  G is GroupOfAutomFamily");
#     return true;
#   fi;
#
#   fgens1 := List(GeneratorsOfGroup(G), g -> Word(g));
#   fgens2 := List(GeneratorsOfGroup(H), g -> Word(g));
#   fam := UnderlyingAutomFamily(G);
#
#   if fam!.rws <> fail then
#     fgens1 := AsSet(AG_ReducedForm(fam!.rws, fgens1));
#     fgens2 := AsSet(AG_ReducedForm(fam!.rws, fgens2));
#   fi;
#
#   if IsSubgroup(GroupWithGenerators(fgens1), GroupWithGenerators(fgens2)) then
#     Info(InfoAutomGrp, 3, "IsSubgroup(G, H): true");
#     Info(InfoAutomGrp, 3, "  by subgroups of free group");
#     return true;
#   fi;
#
#   TryNextMethod();
# end);


###############################################################################
##
#M  <g> in <G>
##
InstallMethod(\in, "for [IsAutom, IsAutomGroup]",
              [IsAutom, IsAutomSemigroup],
function(g, G)
  local fam, fgens, w;

  if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
    return true;
  fi;

  fgens := List(GeneratorsOfSemigroup(G), g -> Word(g));
  w := Word(g);

  fam := UnderlyingAutomFamily(G);

  if fam!.rws <> fail then
    fgens := AsSet(AG_ReducedForm(fam!.rws, fgens));
    w := AG_ReducedForm(fam!.rws, w);
  fi;

  if w in SemigroupByGenerators(fgens) then
    Info(InfoAutomGrp, 3, "g in G: true");
    Info(InfoAutomGrp, 3, "  by elements of free group");
    Info(InfoAutomGrp, 3, "  g = ", g, "; G = ", G);
    return true;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  Random(<G>)
##
InstallMethodWithRandomSource(Random, "for a random source and [IsAutomSemigroup]",
              [IsRandomSource, IsAutomSemigroup],
function(rs, G)
  local w, monoid, F, gens, pi;

  if IsAutomatonSemigroup(G) then
    monoid := UnderlyingFreeMonoid(G);

    if IsTrivial(monoid) then
      w := One(monoid);
    else
      while true do
        w := Random(rs, monoid);
        if not IsOne(w) then
          break;
        fi;
      od;
    fi;
    return Autom(w, UnderlyingAutomFamily(G));
  else
    gens := GeneratorsOfSemigroup(G);
    F := FreeGroup(Length(gens));
    pi := GroupHomomorphismByImagesNC(F,                      UnderlyingFreeGroup(G),
                                      GeneratorsOfGroup(F),   List(gens, Word)        );
    return Autom( Random( rs, SemigroupByGenerators( GeneratorsOfGroup(F)))^pi, UnderlyingAutomFamily(G));
  fi;
end);


###############################################################################
##
#M  UnderlyingFreeMonoid( <G> )
##
InstallMethod(UnderlyingFreeMonoid, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return UnderlyingFreeMonoid(UnderlyingAutomFamily(G));
end);

###############################################################################
##
#M  UnderlyingFreeGroup( <G> )
##
InstallMethod(UnderlyingFreeGroup, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return UnderlyingFreeGroup(UnderlyingAutomFamily(G));
end);

###############################################################################
##
#M  UnderlyingFreeGenerators( <G> )
##
InstallMethod(UnderlyingFreeGenerators, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return List(GeneratorsOfSemigroup(G), g -> Word(g));
end);


# ###############################################################################
# ##
# #M  UnderlyingFreeSubgroup(<G>)
# ##
# InstallMethod(UnderlyingFreeSubgroup, "for [IsAutomGroup]",
#               [IsAutomGroup],
# function(G)
#   local f;
#   if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
#     return UnderlyingFreeGroup(G);
#   fi;
#   f := Subgroup(UnderlyingFreeGroup(G), UnderlyingFreeGenerators(G));
#   if f = UnderlyingFreeGroup(G) then
#     SetIsGroupOfAutomFamily(G, true);
#   fi;
#   return f;
# end);


###############################################################################
##
#M  UnderlyingFreeGroup( <G> )
##
InstallMethod(UnderlyingFreeGroup, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return UnderlyingAutomFamily(G)!.freegroup;
end);


###############################################################################
##
#M  UnderlyingFreeGenerators( <G> )
##
InstallMethod(UnderlyingFreeGenerators, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  return List(GeneratorsOfSemigroup(G), g -> Word(g));
end);


InstallMethod(SphericalIndex, "for IsAutomSemigroup",
              [IsAutomSemigroup],
function(G)
  return SphericalIndex(GeneratorsOfSemigroup(G)[1]);
end);
InstallMethod(DegreeOfTree, "for IsAutomSemigroup",
              [IsAutomSemigroup],
function(G)
  return UnderlyingAutomFamily(G)!.deg;
end);
InstallMethod(TopDegreeOfTree, "for IsAutomSemigroup",
              [IsAutomSemigroup],
function(G)
  return UnderlyingAutomFamily(G)!.deg;
end);


###############################################################################
##
#M  UnderlyingAutomaton(<G>)
##
InstallMethod(UnderlyingAutomaton, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  local fam, numstates, automatonlist, d, i, j;
  fam := UnderlyingAutomFamily(G);
  numstates := fam!.numstates;
# if you do the next 2 operations in one "List", it will remove unbinded spaces
  automatonlist := List(fam!.automatonlist);
  Apply(automatonlist, x -> ShallowCopy(x));
  d := fam!.deg;

# in case we have 1 in the list we move it to the numstates+1 postion
  if Length(automatonlist)=2*numstates+1 then
    for i in [1..numstates] do
      for j in [1..d] do
        if automatonlist[i][j]=2*numstates+1 then automatonlist[i][j] := numstates+1; fi;
      od;
    od;
    automatonlist[numstates+1] := List([1..d], x -> numstates+1);
    Add(automatonlist[numstates+1], automatonlist[2*numstates+1][d+1]);
    numstates := numstates+1;
  fi;
  return MealyAutomaton(automatonlist{[1..numstates]});
end);


###############################################################################
##
#M  IsAutomatonSemigroup(<G>)
##
InstallMethod(IsAutomatonSemigroup, "for [IsAutomSemigroup]",
              [IsAutomSemigroup],
function(G)
  if not HasIsAutomatonSemigroup(G) then return false; fi;
end);


###############################################################################
##
#M  SemigroupOfAutomFamily(<G>)
##
InstallMethod(SemigroupOfAutomFamily, "for [IsAutomSemigroup]",
                   [IsAutomSemigroup],
function(G)
  return SemigroupOfAutomFamily(UnderlyingAutomFamily(G));
end);


#E
