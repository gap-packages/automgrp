#############################################################################
##
#W  autom.gi                 automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsAutomRep
##
##  This is how IsAutom object is stored in GAP:
##  IsAutom object is a thing of kind "w = (w_1, w_2, ..., w_d)\pi", where
##    deg = d - arity of tree;
##    perm = \pi - permutation on first level;
##    w, w_1, ..., w_d - elements of free group representing elements of
##      automata group;
##    word = w;
##    states = [w_1, ..., w_d].
##
DeclareRepresentation("IsAutomRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["word", "states", "perm", "deg"]);


InstallGlobalFunction($AG_CreateAutom,
function(family, word, states, perm, invertible)
  local a, cat;

  if invertible then
    cat := IsInvertibleAutom and IsAutomRep;

    if not AG_IsInvertibleTransformation(perm) then
      Error(perm, " is not invertible");
    else
      perm := AG_PermFromTransformation(perm);
    fi;
  else
    cat := IsAutom and IsAutomRep;
  fi;

  a := Objectify(NewType(family, cat),
                 rec(word := word,
                     states := states,
                     perm := perm,
                     deg := family!.deg));

  SetIsActingOnBinaryTree(a, a!.deg = 2);

  return a;
end);

###############################################################################
##
#M  Autom(<word>, <fam>)
##
InstallMethod(Autom, "method for IsAssocWord and IsAutomFamily",
              [IsAssocWord, IsAutomFamily],
function(w, fam)
  local exp, wstates, curstate, newstate, curletter, newletter,
        nperm, i, j, perm, a, wtmp, reduced, invertible;

  if fam!.use_rws then
    w := ReducedForm(fam!.rws, w);
  fi;

  if Length(w) = 0 then
    return One(fam);
  elif Length(w) = 1 then
    if ExponentSyllable(w, 1) = 1 then
      return fam!.automgens[GeneratorSyllable(w, 1)];
    else
      return fam!.automgens[GeneratorSyllable(w, 1) + fam!.numstates];
    fi;
  fi;

  # TODO
  exp := LetterRepAssocWord(w);
  for i in [1..Length(exp)] do
    if exp[i] < 0 then exp[i] := -exp[i] + fam!.numstates; fi;
  od;
  wstates := [];
  nperm := ();
  for i in [1..Length(exp)] do
    nperm := nperm * fam!.automatonlist[exp[i]][fam!.deg+1];
  od;

  for i in [1..fam!.deg] do
    wstates[i] := [];
    perm:=();

    for j in [1..Length(exp)] do
      newstate := fam!.automatonlist[exp[j]][i^perm];
      if newstate <> fam!.trivstate then
        if newstate > fam!.numstates then
          newstate := -(newstate - fam!.numstates);
        fi;
        if Length(wstates[i]) > 0 and wstates[i][Length(wstates[i])] = -newstate then
          Remove(wstates[i], Length(wstates[i]));
        else
          Add(wstates[i], newstate);
        fi;
      fi;
      perm := perm * fam!.automatonlist[exp[j]][fam!.deg+1];
    od;
    if fam!.use_rws and Length(wstates[i]) > 0 then
      wstates[i] := ReducedForm(fam!.rws, wstates[i]);
    fi;
    if Length(wstates[i]) > 0 then
      wstates[i] := AssocWordByLetterRep(FamilyObj(w), wstates[i]);
    else
      wstates[i] := One(fam!.freegroup);
    fi;
  od;

  invertible := true;
  if not fam!.isgroup then
    for i in exp do
      if i <= fam!.numstates and not IsInvertibleAutom(fam!.automgens[i]) then
        invertible := false;
        break;
      fi;
    od;
  fi;

  return $AG_CreateAutom(fam, w, wstates, nperm, invertible);
end);


###############################################################################
##
#M  Autom(<word>, <a>)
##
InstallMethod(Autom, "method for IsAssocWord and IsAutom", [IsAssocWord, IsAutom],
function(w, a)
  return Autom(w, FamilyObj(a));
end);


InstallMethod(MappedWord, [IsAssocWord,
                           IsList and IsAssocWordCollection,
                           IsList and IsAutomCollection],
function(w, fgens, agens)
  local img;
  img := MappedWord(w, fgens, List(agens, a -> a!.word));
  return Autom(img, FamilyObj(agens[1]));
end);


###############################################################################
##
#M  Autom(<word>, <list>)
##
InstallOtherMethod(Autom, "method for IsAssocWord and IsList",
                   [IsAssocWord, IsList],
function(w, list)
  local fam;
  fam := AutomFamily(list);
  if fam = fail then
    return fail;
  fi;
  return Autom(w, fam);
end);


###############################################################################
##
#M  PrintObj(<a>)
##
InstallMethod(PrintObj, "method for IsAutom",
              [IsAutom],
function (a)
  local deg, printword, i;

  printword := function(w)
    if IsOne(w) then Print(AG_Globals.identity_symbol);
    else Print(w); fi;
  end;

  if true then
    View(a);
    return;
  fi;

  deg := a!.deg;
  printword(a!.word);
  Print(" = (");
  for i in [1..deg] do
    printword(a!.states[i]);
    if i <> deg then Print(", "); fi;
  od;
  Print(")");
  if not IsOne(a!.perm) then AG_PrintTransformation(a!.perm); fi;
end);


###############################################################################
##
#M  ViewObj(<a>)
##
InstallMethod(ViewObj, "method for IsAutom",
              [IsAutom],
function (a)
  if IsOne(a!.word) then Print(AG_Globals.identity_symbol);
  else Print(a!.word); fi;
end);


###############################################################################
##
#M  String(<a>)
##
InstallMethod(String, "method for IsAutom",
              [IsAutom],
function (a)
  if IsOne(a!.word) then return AG_Globals.identity_symbol;
  else return String(a!.word); fi;
end);


###############################################################################
##
#M  Perm(<a>)
##
InstallOtherMethod(Perm, "method for IsAutom", [IsAutom],
function(a)
    return a!.perm;
end);


###############################################################################
##
#M  Word(<a>)
##
InstallMethod(Word, "method for IsAutom", [IsAutom],
function(a)
    return a!.word;
end);


###############################################################################
##
#M  <a1> * <a2>
##
InstallMethod(\*, "\*(IsAutom, IsAutom)", [IsAutom, IsAutom],
function(a1, a2)
    local a, i, fam, word, states;

    fam := FamilyObj(a1);
    word := a1!.word * a2!.word;

    if fam!.use_rws then
      word := ReducedForm(fam!.rws, word);
    fi;

    if IsOne(word) then
      return One(a1);
    fi;

    states := List([1..a1!.deg], i -> a1!.states[i] * a2!.states[i^(a1!.perm)]);

    if fam!.use_rws then
      for i in [1..a1!.deg] do
        states[i] := ReducedForm(fam!.rws, states[i]);
      od;
    fi;

    return $AG_CreateAutom(FamilyObj(a1), word, states, a1!.perm * a2!.perm,
                           IsInvertibleAutom(a1) and IsInvertibleAutom(a2));
end);


###############################################################################
##
#M  IsOne(a)
##
InstallOtherMethod(IsOne, "IsOne(IsAutom)", [IsAutom],
function(a)
  local i, w, nw, d, to_check, checked, deb_i, perm, autlist, pos, istrivstate, exp, G, trivstate;

  if IsOne(a!.word) then return true; fi;

  G:=GroupOfAutomFamily(FamilyObj(a));
  if G <>fail and HasIsContracting(G) and IsContracting(G) and FamilyObj(a)!.use_contraction = true  then
    return IsOneContr(a);
  fi;

  d := a!.deg;
  autlist := FamilyObj(a)!.automatonlist;
  trivstate := FamilyObj(a)!.trivstate;
  checked := [];

  istrivstate := function(v)
    local i,j,perm;

    if IsEmpty(v) then
      return true;
    fi;

    if v in checked then
      return true;
    else
      perm := ();
      for i in [1..Length(v)] do perm := perm * autlist[v[i]][d+1]; od;
      if perm <> () then return false; fi;
      Add(checked, v);
      for j in [1..d] do
        if not istrivstate(AG_WordStateInList(v, j, autlist, true, trivstate)) then
          return false;
        fi;
      od;
      return true;
    fi;
  end;

  exp := LetterRepAssocWord(a!.word);
  for i in [1..Length(exp)] do
    if exp[i] < 0 then
      exp[i] := -exp[i] + FamilyObj(a)!.numstates;
    fi;
  od;

  return istrivstate(exp);
end);


###############################################################################
##
#M  a1 = a2
##
## TODO
InstallMethod(\=, "\=(IsAutom, IsAutom)", IsIdenticalObj, [IsAutom, IsAutom],
function(a1, a2)
  local areequalstates, exp, i, d, checked, autlist, G, trivstate;

  G:=GroupOfAutomFamily(FamilyObj(a1));
  if G <> fail and HasIsContracting(G) and IsContracting(G) and UseContraction(G) then
    return IsOneContr(a1*a2^-1);
  fi;

  d := a1!.deg;
  checked := [];
  autlist := FamilyObj(a1)!.automatonlist;
  trivstate := FamilyObj(a1)!.trivstate;

  areequalstates := function(p)
    local i, j, perm1, perm2;

    if p[1] = p[2] then
      return true;
    fi;

    if p in checked then
      return true;
    else
      perm1 := ();
      perm2 := ();

      for i in [1..Length(p[1])] do
        perm1 := perm1 * autlist[p[1][i]][d+1];
      od;
      for i in [1..Length(p[2])] do
        perm2 := perm2 * autlist[p[2][i]][d+1];
      od;

      if perm1 <> perm2 then
        return false;
      fi;

      AddSet(checked, p);
      for j in [1..d] do
        if not areequalstates([AG_WordStateInList(p[1], j, autlist, true, trivstate),
                               AG_WordStateInList(p[2], j, autlist, true, trivstate)])
        then
          return false;
        fi;
      od;
      return true;
    fi;
  end;

  exp := [LetterRepAssocWord(a1!.word), LetterRepAssocWord(a2!.word)];
  for i in [1..Length(exp[1])] do
    if exp[1][i] < 0 then exp[1][i] := -exp[1][i] + FamilyObj(a1)!.numstates; fi;
  od;
  for i in [1..Length(exp[2])] do
    if exp[2][i] < 0 then exp[2][i] := -exp[2][i] + FamilyObj(a2)!.numstates; fi;
  od;
  return areequalstates(exp);
end);


###############################################################################
##
#M  a1 < a2
##
InstallMethod(\<, "\<(IsAutom, IsAutom)", IsIdenticalObj, [IsAutom, IsAutom],
function(a1, a2)
  local d, checked, pos, aw1, aw2, p, np, i, exp, perm1, perm2, autlist, cmp;

  d := a1!.deg;
  autlist := FamilyObj(a1)!.automatonlist;
  exp := [LetterRepAssocWord(a1!.word), LetterRepAssocWord(a2!.word)];
  for i in [1..Length(exp[1])] do
    if exp[1][i] < 0 then exp[1][i] := -exp[1][i] + FamilyObj(a1)!.numstates; fi;
  od;
  for i in [1..Length(exp[2])] do
    if exp[2][i] < 0 then exp[2][i] := -exp[2][i] + FamilyObj(a2)!.numstates; fi;
  od;
  checked := [exp];
  pos := 0;

  while Length(checked) <> pos do
    pos := pos + 1;
    p := checked[pos];
    perm1 := ();
    perm2 := ();
    for i in [1..Length(p[1])] do perm1 := perm1 * autlist[p[1][i]][d+1]; od;
    for i in [1..Length(p[2])] do perm2 := perm2 * autlist[p[2][i]][d+1]; od;
    cmp := AG_TrCmp(perm1, perm2, d);
    if cmp < 0 then
      return true;
    elif cmp > 0 then
      return false;
    fi;
    for i in [1..d] do
      np := [AG_WordStateInList(p[1], i, autlist, false, 0),
             AG_WordStateInList(p[2], i, autlist, false, 0)];
      if not np in checked then
        Add(checked, np);
      fi;
    od;
  od;

  return false;
end);


###############################################################################
##
#M  InverseOp(<a>)
##
InstallMethod(InverseOp, "InverseOp(IsInvertibleAutom)", [IsInvertibleAutom],
function(a)
  local i, inv, fam, word, states;

  fam := FamilyObj(a);
  word := a!.word ^ -1;
  if fam!.use_rws then
    word := ReducedForm(fam!.rws, word);
    if IsOne(word) then
      return One(a);
    fi;
  fi;

  states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1);

  if fam!.use_rws then
    for i in [1..a!.deg] do
      states[i] := ReducedForm(fam!.rws, states[i]);
    od;
  fi;

  return $AG_CreateAutom(FamilyObj(a), word, states, a!.perm^-1, true);
end);


###############################################################################
##
#M  OneOp(<a>)
##
InstallMethod(OneOp, "OneOp(IsAutom)", [IsAutom],
function(a)
    return One(FamilyObj(a));
end);


###############################################################################
##
#M  StatesWords(<a>)
##
InstallMethod(StatesWords, "StatesWords(IsAutom)", [IsAutom],
function(a)
  return a!.states;
end);


###############################################################################
##
#M  Sections(a)
##
InstallMethod(Sections, "Sections(IsAutom)", [IsAutom],
function(a)
  return List(a!.states, s -> Autom(s, a));
end);


###############################################################################
##
#M  Section(a, k)
##
InstallOtherMethod(Section, "Section(IsAutom, IsPosInt)", [IsAutom, IsPosInt],
function(a, k)
  if k > a!.deg then
    Error("in Section(IsAutom, IsPosInt): invalid vertex ", k);
  fi;
  return Autom(a!.states[k], a);
end);


###############################################################################
##
#M  Section(a, seq)
##
## TODO
InstallMethod(Section, "Section(IsAutom, IsList)", [IsAutom, IsList],
function(a, v)
  if Length(v) = 0 then
    return a;
  fi;

  if Length(v) = 1 then
    return Section(a, v[1]);
  fi;

  return Section(Section(a, v[1]), v{[2..Length(v)]});
end);


###############################################################################
##
#M  k ^ a
##
InstallOtherMethod(\^, "\^(IsPosInt, IsAutom)", [IsPosInt, IsAutom],
function(k, a)
    return k ^ Perm(a);
end);


###############################################################################
##
#M  seq ^ a
##
InstallOtherMethod(\^, "\^(IsList, IsAutom)", [IsList, IsAutom],
function(seq, a)
    local i, deg, img, cur;

    deg := DegreeOfTree(a);
    for i in seq do
      if not IsInt(i) or i < 1 or i > deg then
        Print("\^(IsList, IsFGAutom): ",
              i, "is out of range 1..", deg, "\n");
        return seq;
      fi;
    od;

    if Length(seq) = 0 then return []; fi;
    if Length(seq) = 1 then return [seq[1]^Perm(a)]; fi;

    cur := LetterRepAssocWord(Word(a));
    for i in [1..Length(cur)] do
      if cur[i] < 0 then cur[i] := -cur[i]+FamilyObj(a)!.numstates; fi;
    od;
    cur := [cur, Perm(a)];

    img := [];
    for i in [1..Length(seq)] do
        img[i] := seq[i]^cur[2];
        cur := AG_WordStateAndPermInList(cur[1], seq[i],
                                         FamilyObj(a)!.automatonlist);
    od;

    return img;
end);


###############################################################################
##
#M  PermOnLevelOp(a, k)
##
## TODO
InstallMethod(PermOnLevelOp, "PermOnLevelOp(IsAutom, IsPosInt)",
              [IsInvertibleAutom, IsPosInt],
function(a, k)
  local dom, perm;

  if k = 1 then
    return a!.perm;
  fi;

  dom := AsList(Tuples([1.. a!.deg], k));
  perm := List(dom, s -> s ^ a);
  perm := PermListList(dom, perm);

  return perm;
end);

InstallMethod(TransformationOnFirstLevel, [IsAutom],
function(a)
  return a!.perm;
end);


###############################################################################
##
#M  IsActingOnBinaryTree(<a>)
##
InstallMethod(IsActingOnBinaryTree, "IsActingOnBinaryTree(IsAutom)",
              [IsAutom],
function(a)
    return a!.deg = 2;
end);


# ###############################################################################
# ##
# #M  Decompose(a)
# ##
# InstallMethod(Decompose, [IsFGAutom],
# function(a)
#   local deg, listrep, list, names, i, j, pf;
#
#   listrep := ListRep(a);
#   deg := Degree(a);
#   names := listrep.names;
#   list := listrep.list;
#
#   pf := function(w)
#     if IsOne(w) then
#       Print(AG_Globals.identity_symbol);
#     else
#       Print(w);
#     fi;
#   end;
#
#   for i in [1..Length(list)] do
#     pf(names[i]);
#     Print(" = (");
#     for j in [1..deg] do
#       pf(names[list[i][j]]);
#       if j <> deg then
#         Print(", ");
#       fi;
#     od;
#     if not IsOne(list[i][deg+1]) then
#       Print(")", list[i][deg+1], "\n");
#     else
#       Print(")\n");
#     fi;
#   od;
# end);
#
#
# ###############################################################################
# ##
# #M  DecomposeRen(a)
# ##
# InstallMethod(DecomposeRen, [IsFGAutom],
# function(a)
#   local letters, deg, listrep, list, states, names, i, j, pf;
#
#   listrep := ListRep(a);
#   deg := Degree(a);
#   states := listrep.names;
#   list := listrep.list;
#   names := [];
#   for i in [1..Length(list)] do
#     names[i] := Concatenation("s", String(i));
#   od;
#
#   pf := function(w)
#     if IsOne(w) then
#       Print(AG_Globals.identity_symbol);
#     else
#       Print(w);
#     fi;
#   end;
#
#   for i in [1..Length(list)] do
#     Print(names[i]);
#     Print(" = (");
#     for j in [1..deg] do
#       Print(names[list[i][j]]);
#       if j <> deg then
#         Print(", ");
#       fi;
#     od;
#     if not IsOne(list[i][deg+1]) then
#       Print(")", list[i][deg+1], "\n");
#     else
#       Print(")\n");
#     fi;
#   od;
#   for i in [1..Length(list)] do
#     Print(names[i], " = "); pf(states[i]); Print("\n");
#   od;
# end);
#
#
# ###############################################################################
# ##
# #M  ListRep(a)
# ##
# InstallMethod(ListRep, [IsFGAutom],
# function(a)
#   local deg, pos, states, list_comp, word, aut, i;
#
#   deg := Degree(a);
#   states := [a!.Word];
#   pos := 0;
#   list_comp := [];
#
#   while pos <> Length(states) do
#     pos := pos + 1;
#     word := states[pos];
#     aut := FGAutom(word, FamilyObj(a));
#     for i in [1..deg] do
#       if not aut!.Sections[i] in states then
#         Add(states, aut!.Sections[i]);
#       fi;
#     od;
#
#     Add(list_comp, Concatenation(List(aut!.Sections, w -> Position(states, w)), [aut!.Perm]));
#   od;
#
#   return rec(  list   := list_comp,
#               names := states  );
# end);
#
#
# ###############################################################################
# ##
# #M  StabilizesPath(a, path)
# ##
# InstallMethod(StabilizesPath, [IsFGAutom, IsList],
# function(a, path)
#   local len, checked_words, cur_state, cur_pos;
#
#   checked_words := [];
#   cur_state := a;
#   cur_pos := 1;
#   len := Length(path);
#
# ##  TODO: error checking
#
#   while true do
#     if cur_pos = 1 and Word(cur_state) in checked_words then
#         return true;
#     fi;
#
#     if path[cur_pos]^cur_state <> path[cur_pos] then
#       return false;
#     fi;
#
#     if cur_pos = 1 then
#       Add(checked_words, Word(cur_state)); fi;
#
#     cur_state := Projection(cur_state, path[cur_pos]);
#
#     if cur_pos < len then
#       cur_pos := cur_pos + 1;
#     else cur_pos := 1; fi;
#   od;
# end);


###############################################################################
##
#M  AbelImage(<a>)
##
InstallMethod(AbelImage, "AbelImage(IsAutom)",
              [IsAutom],
function(a)
  local abels, w, i;
  w := LetterRepAssocWord(Word(a));
  for i in [1..Length(w)] do
    if w[i] < 0 then w[i] := -w[i]+FamilyObj(a)!.numstates; fi;
  od;
  abels := AG_AbelImagesGenerators(FamilyObj(a));
  if not IsEmpty(w) then
    return Sum(List(w, x -> abels[x]));
  else
    return Zero(abels[1]);
  fi;
end);


InstallMethod(SphericalIndex, "SphericalIndex(IsAutom)", [IsAutom],
function(a)
  # XXX check uses of SphericalIndex everywhere
  return rec(start := [], period := [a!.deg]);
end);

# XXX check uses of this everywhere
InstallMethod(DegreeOfTree, "DegreeOfTree(IsAutom)", [IsAutom],
function(a)
  return a!.deg;
end);

# XXX check uses of this everywhere
InstallMethod(TopDegreeOfTree, "TopDegreeOfTree(IsAutom)", [IsAutom],
function(a)
  return a!.deg;
end);


###############################################################################
##
#M  CanEasilyTestSphericalTransitivity(<a>)
##
InstallTrueMethod(CanEasilyTestSphericalTransitivity,
                  IsActingOnBinaryTree and IsAutom);


###############################################################################
##
#M  IsSphericallyTransitive(<a>)
##
InstallMethod(IsSphericallyTransitive, "IsSphericallyTransitive(IsAutom)",
              [IsInvertibleAutom],
function(a)
  local w, i, ab, abs;

  if IsOne(Word(a)) then
    Info(InfoAutomGrp, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomGrp, 3, "  IsOne(Word(a)): a = ", a);
    return false;
  fi;

  TryNextMethod();
end);


#########################################################################
##
#M  Order(<a>)
##
InstallOtherMethod(Order, "Order(IsInvertibleAutom)", true,
                   [IsInvertibleAutom],
function(a)
  local ord_loc;
  if IsGeneratedByBoundedAutomaton(GroupOfAutomFamily(FamilyObj(a))) then
    return OrderUsingSections(a,infinity);
  fi;
  if IsActingOnBinaryTree(a) and IsSphericallyTransitive(a) then
    return infinity;
  fi;
  ord_loc := OrderUsingSections(a,10);
  if ord_loc <> fail then
    return ord_loc;
  fi;
  TryNextMethod();
end);


#########################################################################
##
#M  IsTransitiveOnLevel( <a>, <lev> )
##
InstallMethod(IsTransitiveOnLevel, "IsTransitiveOnLevel(IsInvertibleAutom,IsPosInt)",
              [IsInvertibleAutom, IsPosInt],
function(a,lev)
  return Length(OrbitPerms([PermOnLevel(a, lev)], 1)) = a!.deg^lev;
end);


#E
