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
InstallMethod(UnderlyingSelfSimFamily, "for [IsSelfSimSemigroup]",
              [IsSelfSimSemigroup],
function(G)
  Print("GeneratorsOfSemigroup(G) :",GeneratorsOfSemigroup(G),"\n");
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


###############################################################################
##
#M  IsSelfSimilarSemigroup(<G>)
##
##  Returns `true' if generators of <G> coincide with generators of the family
InstallMethod(IsSelfSimilarSemigroup, [IsSelfSimSemigroup],
function(G)
  local fam;
  fam := UnderlyingSelfSimFamily(G);
  return fam!.numstates = 0 or
         GeneratorsOfSemigroup(G) = fam!.recurgens{[1..fam!.numstates]};
end);



###############################################################################
##
#M  IsFiniteState(<G>)
##
InstallMethod(IsFiniteState, "for [IsSelfSimSemigroup]",
              [IsSelfSimSemigroup],
function(G)
  local states, MealyAutomatonLocal, aut_list, gens, images, H, g, hom_function,\
        inv_hom_function, hom, free_groups_hom, inv_free_groups_hom, inv_hom,\
        gens_in_freegrp, images_in_freegrp, preimages_in_freegrp, F, pi, pi_bar,\
        preimage_in_freegrp;

  MealyAutomatonLocal:=function(g)
    local cur_state;
    if g!.word in states then return Position(states, g!.word); fi;
    Add(states,g!.word);
    cur_state := Length(states);
    aut_list[cur_state] := List([1..g!.deg], x -> MealyAutomatonLocal(Section(g, x)));
    Add(aut_list[cur_state], g!.perm);
    return cur_state;
  end;

  states := [];
  aut_list := [];
  gens := GeneratorsOfSemigroup(G);
  images := [];

  for g in gens do
    Add(images, MealyAutomatonLocal(g));
  od;


  H := AutomatonSemigroup(aut_list);
  SetUnderlyingAutomSemigroup(G, H);

  images := UnderlyingAutomFamily(H)!.oldstates{images};

# preimages of generators of G in UnderlyingFreeGroup(G)
  gens_in_freegrp := List(GeneratorsOfSemigroup(G), Word);

# preimages of generators of a subgroup of H isomorphic to G in UnderlyingFreeGroup(H)
  images_in_freegrp := List(UnderlyingAutomFamily(H)!.automgens{images}, Word);


  preimage_in_freegrp:=function(x)
    local w;
    if IsOne(x!.word) then
      return states[ Position( UnderlyingAutomFamily(H)!.oldstates, UnderlyingAutomFamily(H)!.trivstate)];
    fi;
    w:=LetterRepAssocWord(x!.word)[1];
    if w>0 then
      return states[ Position( UnderlyingAutomFamily(H)!.oldstates, w)];
    else
      return states[ Position( UnderlyingAutomFamily(H)!.oldstates, -w+UnderlyingAutomFamily(H)!.numstates)];
    fi;
  end;

# preimages of generators of H in UnderlyingFreeGroup(G)
  preimages_in_freegrp := List(GeneratorsOfSemigroup(H), x -> preimage_in_freegrp(x));



  if IsSelfSimilarSemigroup(G) then
    free_groups_hom:=
       GroupHomomorphismByImagesNC( Group(gens_in_freegrp), UnderlyingFreeGroup(H),
                                    gens_in_freegrp, images_in_freegrp );

    inv_free_groups_hom:=
       GroupHomomorphismByImagesNC( UnderlyingFreeGroup(H), UnderlyingFreeGroup(G),
                                    UnderlyingFreeGenerators(H), preimages_in_freegrp );

    hom_function:=function(a)
      return Autom(Image(free_groups_hom,a!.word),UnderlyingAutomFamily(H));
    end;

    inv_hom_function:= function(b)
      return SelfSim(Image(inv_free_groups_hom,b!.word),UnderlyingSelfSimFamily(G));
    end;

    hom := MappingByFunction(G,SemigroupByGenerators(UnderlyingAutomFamily(H)!.automgens{images}),hom_function, inv_hom_function);

    SetMonomorphismToAutomatonSemigroup(G, hom);
  else
    F:=FreeGroup(Length(GeneratorsOfSemigroup(G)));
    #SetCoveringFreeGroup(G, F);

#        pi
#    F ------> G ----> UnderlyingFreeGroup(H)
#      -------------->
#            pi_bar

    pi:=GroupHomomorphismByImages(F,                     Group(gens_in_freegrp),
                                  GeneratorsOfGroup(F),  gens_in_freegrp);

    pi_bar:=GroupHomomorphismByImages(F,                     UnderlyingFreeGroup(H),
                                      GeneratorsOfGroup(F),  images_in_freegrp);

    hom_function:=function(g)
      return Autom(Image(pi_bar,PreImagesRepresentative(pi,g!.word)),UnderlyingAutomFamily(H));
    end;


    inv_hom_function:= function(b)
      return SelfSim(Image(pi,PreImagesRepresentative(pi_bar,b!.word)),UnderlyingSelfSimFamily(G));
    end;

    hom := MappingByFunction(G,SemigroupByGenerators(UnderlyingAutomFamily(H)!.automgens{images}), hom_function, inv_hom_function);

    SetMonomorphismToAutomatonSemigroup(G, hom);
  fi;


  return true;
end);


###############################################################################
##
#M  UnderlyingAutomSemigroup(<G>)
##
InstallMethod(UnderlyingAutomSemigroup, "for [IsSelfSimSemigroup]",
              [IsSelfSimSemigroup],
function(G)
  if IsFiniteState(G) then return UnderlyingAutomSemigroup(G); fi;
end);


###############################################################################
##
#M  MonomorphismToAutomatonSemigroup(<G>)
##
InstallMethod(MonomorphismToAutomatonSemigroup, "for [IsSelfSimSemigroup]",
              [IsSelfSimSemigroup],
function(G)
  if IsFiniteState(G) then return MonomorphismToAutomatonSemigroup(G); fi;
end);


#E
