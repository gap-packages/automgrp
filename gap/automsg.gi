#############################################################################
##
#W  automsg.gi               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  AutomSemigroup(<list>)
##
InstallMethod(AutomSemigroup, "AutomSemigroup(IsList)", [IsList],
function (list)
  return AutomSemigroup(list, false);
end);


###############################################################################
##
#M  AutomSemigroup(<list>, <bind_vars>)
##
InstallMethod(AutomSemigroup, "AutomSemigroup(IsList, IsBool)", [IsList, IsBool],
function (list, bind_vars)
  if not AG_IsCorrectAutomatonList(list, false) then
    Error("in AutomSemigroup(IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  # XXX
  return SemigroupOfAutomFamily(AutomFamily(list, bind_vars));
end);


###############################################################################
##
#M  AutomSemigroup(<list>, <names>)
##
InstallMethod(AutomSemigroup, "AutomSemigroup(IsList, IsList)", [IsList, IsList],
function (list, names)
  if not AG_IsCorrectAutomatonList(list, false) then
    Error("error in AutomSemigroup(IsList, IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  # XXX
  return SemigroupOfAutomFamily(AutomFamily(list, names));
end);


###############################################################################
##
#M  AutomSemigroup(<list>, <names>, <bind_vars>)
##
InstallMethod(AutomSemigroup, "AutomSemigroup(IsList, IsList, IsBool)",
              [IsList, IsList, IsBool],
function (list, names, bind_vars)
  if not AG_IsCorrectAutomatonList(list, false) then
    Error("error in AutomSemigroup(IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  #XXX
  return SemigroupOfAutomFamily(AutomFamily(list, names, bind_vars));
end);


###############################################################################
##
#M  AutomSemigroup(<string>)
#M  AutomSemigroup(<string>, <bind_vars>)
##
InstallMethod(AutomSemigroup, "AutomSemigroup(IsString)", [IsString],
function(string)
    return AutomSemigroup(string, AG_Globals.bind_vars_autom_family);
end);
InstallMethod(AutomSemigroup, "AutomSemigroup(IsString, IsBool)", [IsString, IsBool],
function(string, bind_vars)
    local s;
    s := AG_ParseAutomatonString(string);
    return AutomSemigroup(s[2], s[1], bind_vars);
end);


###############################################################################
##
#M  AutomSemigroup(<A>)
#M  AutomSemigroup(<A>, <bind_vars>)
##
InstallMethod(AutomSemigroup, "AutomSemigroup(IsAutomaton)", [IsAutomaton],
function(A)
  return AutomSemigroup(AutomatonList(A), A!.states);
end);

InstallMethod(AutomSemigroup, "AutomSemigroup(IsAutomaton, IsBool)", [IsAutomaton, IsBool],
function(A, bind_vars)
  return AutomSemigroup(AutomatonList(A), A!.states, bind_vars);
end);


###############################################################################
##
#M  UnderlyingAutomFamily(<G>)
##
InstallMethod(UnderlyingAutomFamily, "UnderlyingAutomFamily(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  return FamilyObj(GeneratorsOfSemigroup(G)[1]);
end);


# ###############################################################################
# ##
# #M  UseSubsetRelation(<G>)
# ##
# InstallMethod(UseSubsetRelation,
#               "UseSubsetRelation(IsAutomSemigroup, IsAutomSemigroup)",
#               [IsAutomSemigroup, IsAutomSemigroup],
# function(super, sub)
#   ## the full group is self similar, so if <super> is smaller than the full
#   ##  group then sub is smaller either
#   if HasIsGroupOfAutomFamily(super) then
#     if not IsGroupOfAutomFamily(super) then
#       SetIsGroupOfAutomFamily(sub, false); fi; fi;
# InstallTrueMethod(IsFractal, IsFractalByWords);
#   TryNextMethod();
# end);


# ###############################################################################
# ##
# #M  $AG_SubgroupOnLevel(<G>, <gens>, <level>)
# ##
# InstallMethod($AG_SubgroupOnLevel, [IsAutomGroup,
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
# InstallMethod($AG_SubgroupOnLevel, [IsAutomGroup, IsList and IsEmpty, IsPosInt],
# function(G, gens, level)
#   return TrivialSubgroup(G);
# end);
#
# InstallMethod($AG_SubgroupOnLevel, [IsTreeAutomorphismGroup,
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
# InstallMethod($AG_SimplifyGroupGenerators, [IsList and IsAutomCollection],
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
#     words := ReducedForm(fam!.rws, words);
#     words := FreeGeneratorsOfGroup(Group(words));
#   fi;
#
#   return List(words, w -> Autom(w, fam));
# end);


###############################################################################
##
#M  DegreeOfTree(<G>)
##
InstallMethod(DegreeOfTree, "DegreeOfTree(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  return DegreeOfTree(UnderlyingAutomFamily(G));
end);

InstallMethod(TopDegreeOfTree, "DegreeOfTree(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  return DegreeOfTree(UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, "PrintObj(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  local i, gens, printone;

  printone := function(a)
    Print(a, " = ", Expand(a));
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
InstallMethod(ViewObj, "ViewObj(IsAutomSemigroup)",
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
#M  Size(G)
##
InstallMethod(Size, "Size(IsAutomSemigroup)", [IsAutomSemigroup],
function (G)
  local f;
  if IsTrivial(G) then
    Info(InfoAutomGrp, 3, "Size(G): 1, G is trivial");
    return 1;
  fi;
  TryNextMethod();
end);


# ###############################################################################
# ##
# #M  \= (<G>, <H>)
# ##
# InstallMethod(\=, "\=(IsAutomGroup, IsAutomGroup)",
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
#     fgens1 := AsSet(ReducedForm(fam!.rws, fgens1));
#     fgens2 := AsSet(ReducedForm(fam!.rws, fgens2));
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
# InstallMethod(IsSubset, "IsSubset(IsAutomGroup, IsAutomGroup)",
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
#     fgens1 := AsSet(ReducedForm(fam!.rws, fgens1));
#     fgens2 := AsSet(ReducedForm(fam!.rws, fgens2));
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


# ###############################################################################
# ##
# #M  <g> in <G>)
# ##
# InstallMethod(\in, "\in(IsAutom, IsAutomGroup)",
#               [IsAutom, IsAutomGroup],
# function(g, G)
#   local fam, fgens, w;
#
#   if HasIsGroupOfAutomFamily(G) and IsGroupOfAutomFamily(G) then
#     return true;
#   fi;
#
#   fgens := List(GeneratorsOfGroup(G), g -> Word(g));
#   w := Word(g);
#
#   fam := UnderlyingAutomFamily(G);
#
#   if fam!.rws <> fail then
#     fgens := AsSet(ReducedForm(fam!.rws, fgens));
#     w := ReducedForm(fam!.rws, w);
#   fi;
#
#   if w in GroupWithGenerators(fgens) then
#     Info(InfoAutomGrp, 3, "g in G: true");
#     Info(InfoAutomGrp, 3, "  by elements of free group");
#     Info(InfoAutomGrp, 3, "  g = ", g, "; G = ", G);
#     return true;
#   fi;
#
#   TryNextMethod();
# end);


###############################################################################
##
#M  Random(<G>)
##
InstallMethod(Random, "Random(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  local w, monoid;

  # XXX! only for whole group
  monoid := UnderlyingFreeMonoid(G);

  if IsTrivial(monoid) then
    w := One(monoid);
  else
    while true do
      w := Random(monoid);
      if not IsOne(w) then
        break;
      fi;
    od;
  fi;

  return Autom(w, UnderlyingAutomFamily(G));
end);


###############################################################################
##
#M  UnderlyingFreeMonoid( <G> )
##
InstallMethod(UnderlyingFreeMonoid, "UnderlyingFreeMonoid(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  return UnderlyingFreeMonoid(UnderlyingAutomFamily(G));
end);

###############################################################################
##
#M  UnderlyingFreeGroup( <G> )
##
InstallMethod(UnderlyingFreeGroup, "UnderlyingFreeGroup(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  return UnderlyingFreeGroup(UnderlyingAutomFamily(G));
end);

###############################################################################
##
#M  UnderlyingFreeGenerators( <G> )
##
InstallMethod(UnderlyingFreeGenerators, "UnderlyingFreeGenerators(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  return List(GeneratorsOfSemigroup(G), g -> Word(g));
end);


# ###############################################################################
# ##
# #M  UnderlyingFreeSubgroup(<G>)
# ##
# InstallMethod(UnderlyingFreeSubgroup, "UnderlyingFreeSubgroup(IsAutomGroup)",
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
#
#
# ###############################################################################
# ##
# #M  IndexInFreeGroup(<G>)
# ##
# InstallMethod(IndexInFreeGroup, "IndexInFreeGroup(IsAutomGroup)",
#               [IsAutomGroup],
# function(G)
#   return IndexInWholeGroup(UnderlyingFreeSubgroup(G));
# end);


###############################################################################
##
#M  UnderlyingFreeGroup( <G> )
##
InstallMethod(UnderlyingFreeGroup, "UnderlyingFreeGroup(IsAutomSemigroup)",
              [IsAutomSemigroup],
function(G)
  return UnderlyingAutomFamily(G)!.freegroup;
end);


###############################################################################
##
#M  UnderlyingFreeGenerators( <G> )
##
InstallMethod(UnderlyingFreeGenerators, "UnderlyingFreeGenerators(IsAutomSemigroup)",
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
InstallMethod(UnderlyingAutomaton, "UnderlyingAutomFamily(IsAutomGroup)",
              [IsAutomSemigroup],
function(G)
  local fam,numstates,automatonlist,d,i,j;
  fam:=UnderlyingAutomFamily(G);
  numstates:=fam!.numstates;
# if you do the next 2 operations in one "List", it will remove unbinded spaces
  automatonlist:=List(fam!.automatonlist);
  Apply(automatonlist,x->ShallowCopy(x));
  d:=fam!.deg;

# in case we have 1 in the list we move it to the numstates+1 postion
  if Length(automatonlist)=2*numstates+1 then
    for i in [1..numstates] do
      for j in [1..d] do
        if automatonlist[i][j]=2*numstates+1 then automatonlist[i][j]:=numstates+1; fi;
      od;
    od;
    automatonlist[numstates+1]:=List([1..d],x->numstates+1);
    Add(automatonlist[numstates+1],automatonlist[2*numstates+1][d+1]);
    numstates:=numstates+1;
  fi;
  return Automaton(automatonlist{[1..numstates]});
end);

#E
