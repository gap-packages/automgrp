#############################################################################
##
#W  selfsimsg.gi             automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  SelfSimilarSemigroup(<list>)
##
InstallMethod(SelfSimilarSemigroup, "SelfSimilarSemigroup(IsList)", [IsList],
function (list)
  return SelfSimilarSemigroup(list, false);
end);


###############################################################################
##
#M  SelfSimilarSemigroup(<list>, <bind_vars>)
##
InstallMethod(SelfSimilarSemigroup, "SelfSimilarSemigroup(IsList, IsBool)", [IsList, IsBool],
function (list, bind_vars)
  if not AG_IsCorrectRecurList(list, false) then
    Error("in SelfSimilarSemigroup(IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  # XXX
  return SemigroupOfSelfSimFamily(SelfSimFamily(list, bind_vars));
end);


###############################################################################
##
#M  SelfSimilarSemigroup(<list>, <names>)
##
InstallMethod(SelfSimilarSemigroup, "SelfSimilarSemigroup(IsList, IsList)", [IsList, IsList],
function (list, names)
  if not AG_IsCorrectRecurList(list, false) then
    Error("error in SelfSimilarSemigroup(IsList, IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  # XXX
  return SemigroupOfSelfSimFamily(SelfSimFamily(list, names));
end);


###############################################################################
##
#M  SelfSimilarSemigroup(<list>, <names>, <bind_vars>)
##
InstallMethod(SelfSimilarSemigroup, "SelfSimilarSemigroup(IsList, IsList, IsBool)",
              [IsList, IsList, IsBool],
function (list, names, bind_vars)
  if not AG_IsCorrectRecurList(list, false) then
    Error("error in SelfSimilarSemigroup(IsList):\n",
          "  given list is not a correct list representing automaton\n");
  fi;

  #XXX
  return SemigroupOfSelfSimFamily(SelfSimFamily(list, names, bind_vars));
end);


###############################################################################
##
#M  SelfSimilarSemigroup(<string>)
#M  SelfSimilarSemigroup(<string>, <bind_vars>)
##
InstallMethod(SelfSimilarSemigroup, "SelfSimilarSemigroup(IsString)", [IsString],
function(string)
    return SelfSimilarSemigroup(string, AG_Globals.bind_vars_autom_family);
end);
InstallMethod(SelfSimilarSemigroup, "SelfSimilarSemigroup(IsString, IsBool)", [IsString, IsBool],
function(string, bind_vars)
    local s;
    s := AG_ParseAutomatonStringFR(string);
    return SelfSimilarSemigroup(s[2], s[1], bind_vars);
end);


###############################################################################
##
#M  UnderlyingSelfSimFamily(<G>)
##
InstallMethod(UnderlyingSelfSimFamily, "UnderlyingSelfSimFamily(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return FamilyObj(GeneratorsOfSemigroup(G)[1]);
end);




###############################################################################
##
#M  DegreeOfTree(<G>)
##
InstallMethod(DegreeOfTree, "DegreeOfTree(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return DegreeOfTree(UnderlyingSelfSimFamily(G));
end);

InstallMethod(TopDegreeOfTree, "DegreeOfTree(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return DegreeOfTree(UnderlyingSelfSimFamily(G));
end);


###############################################################################
##
#M  PrintObj(<G>)
##
InstallMethod(PrintObj, "PrintObj(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
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
InstallMethod(ViewObj, "ViewObj(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
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
InstallMethod(IsTrivial, "for [IsSelfSimSemigroup]", [IsSelfSimSemigroup],
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
InstallMethod(Size, "Size(IsSelfSimSemigroup)", [IsSelfSimSemigroup],
function (G)
  local g;
  if IsTrivial(G) then
    Info(InfoAutomGrp, 3, "Size(G): 1, G is trivial");
    return 1;
  fi;

  TryNextMethod();
end);




###############################################################################
##
#M  Random(<G>)
##
InstallMethod(Random, "Random(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
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

  return SelfSim(w, UnderlyingSelfSimFamily(G));
end);


###############################################################################
##
#M  UnderlyingFreeMonoid( <G> )
##
InstallMethod(UnderlyingFreeMonoid, "UnderlyingFreeMonoid(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return UnderlyingFreeMonoid(UnderlyingSelfSimFamily(G));
end);

###############################################################################
##
#M  UnderlyingFreeGroup( <G> )
##
InstallMethod(UnderlyingFreeGroup, "UnderlyingFreeGroup(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return UnderlyingFreeGroup(UnderlyingSelfSimFamily(G));
end);

###############################################################################
##
#M  UnderlyingFreeGenerators( <G> )
##
InstallMethod(UnderlyingFreeGenerators, "UnderlyingFreeGenerators(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return List(GeneratorsOfSemigroup(G), g -> Word(g));
end);




###############################################################################
##
#M  UnderlyingFreeGroup( <G> )
##
InstallMethod(UnderlyingFreeGroup, "UnderlyingFreeGroup(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return UnderlyingSelfSimFamily(G)!.freegroup;
end);


###############################################################################
##
#M  UnderlyingFreeGenerators( <G> )
##
InstallMethod(UnderlyingFreeGenerators, "UnderlyingFreeGenerators(IsSelfSimSemigroup)",
              [IsSelfSimSemigroup],
function(G)
  return List(GeneratorsOfSemigroup(G), g -> Word(g));
end);


InstallMethod(SphericalIndex, "for IsSelfSimSemigroup",
              [IsSelfSimSemigroup],
function(G)
  return SphericalIndex(GeneratorsOfSemigroup(G)[1]);
end);
InstallMethod(DegreeOfTree, "for IsSelfSimSemigroup",
              [IsSelfSimSemigroup],
function(G)
  return UnderlyingSelfSimFamily(G)!.deg;
end);
InstallMethod(TopDegreeOfTree, "for IsSelfSimSemigroup",
              [IsSelfSimSemigroup],
function(G)
  return UnderlyingSelfSimFamily(G)!.deg;
end);


#E
