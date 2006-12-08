#############################################################################
##
#W  autom.gi                 automata package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
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


###############################################################################
##
#M  Autom(<word>, <fam>)
##
InstallMethod(Autom, "method for IsAssocWord and IsAutomFamily",
              [IsAssocWord, IsAutomFamily],
function(w, fam)
  local exp, wstates, curstate, newstate, curletter, newletter,
        nperm, i, j, perm, a;

  if Length(w) = 0 then
    return One(fam);
  elif Length(w) = 1 then
    if ExponentSyllable(w, 1) = 1 then
      return fam!.automgens[GeneratorSyllable(w, 1)];
    else
      return fam!.automgens[GeneratorSyllable(w, 1) + fam!.numstates];
    fi;
  else
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
          Add(wstates[i], newstate);
        fi;
        perm := perm * fam!.automatonlist[exp[j]][fam!.deg+1];
      od;
      for j in [1..Length(wstates[i])] do
        if wstates[i][j] > fam!.numstates then
          wstates[i][j] := -(wstates[i][j] - fam!.numstates); fi;
      od;
      wstates[i] := AssocWordByLetterRep(FamilyObj(w), wstates[i]);
    od;

    a := Objectify(NewType(fam, IsAutom and IsAutomRep),
            rec(word := w,
                states := wstates,
                perm := nperm,
                deg := fam!.deg) );
    SetIsActingOnBinaryTree(a, fam!.deg = 2);

    return a;
  fi;
end);


###############################################################################
##
#M  Autom(<word>, <a>)
##
InstallOtherMethod(Autom, "method for IsAssocWord and IsAutom",
                   [IsAssocWord, IsAutom],
function(w, a)
  return Autom(w, FamilyObj(a));
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
        if IsOne(w) then Print(AutomataParameters.identity_symbol);
        else Print(w); fi;
    end;

    deg := a!.deg;
    printword(a!.word);
    Print(" = (");
    for i in [1..deg] do
        printword(a!.states[i]);
        if i <> deg then Print(", "); fi;
    od;
    Print(")");
    if not IsOne(a!.perm) then Print(a!.perm); fi;
end);


###############################################################################
##
#M  ViewObj(<a>)
##
InstallMethod(ViewObj, "method for IsAutom",
              [IsAutom],
function (a)
  if IsOne(a!.word) then Print(AutomataParameters.identity_symbol);
  else Print(a!.word); fi;
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
#M  DegreeOfTree(<a>)
##
InstallMethod(DegreeOfTree, "method for IsAutom", [IsAutom],
function(a)
    return a!.deg;
end);


###############################################################################
##
#M  Word(<a>)
##
InstallOtherMethod(Word, "method for IsAutom", [IsAutom],
function(a)
    return a!.word;
end);


###############################################################################
##
#M  <a1> * <a2>
##
InstallMethod(\*, "\*(IsAutom, IsAutom)", [IsAutom, IsAutom],
function(a1, a2)
    local a;
    a := Objectify(
        NewType(FamilyObj(a1), IsAutom and IsAutomRep),
        rec(word := a1!.word * a2!.word,
            states := List([1..a1!.deg], i -> a1!.states[i] * a2!.states[i^(a1!.perm)]),
            perm := a1!.perm * a2!.perm,
            deg := a1!.deg) );
    SetIsActingOnBinaryTree(a, a1!.deg = 2);
    return a;
end);


###############################################################################
##
#M  IsOne(a)
##
InstallOtherMethod(IsOne, "IsOne(IsAutom)", [IsAutom],
function(a)
  local i, w, nw, d, to_check, checked, deb_i, perm, autlist, pos, istrivstate, exp;

  if IsOne(a!.word) then return true; fi;

  d := a!.deg;
  autlist := FamilyObj(a)!.automatonlist;
#  to_check := [ExpandExtRepOfWord(a!.word, FamilyObj(a)!.numstates)];
  checked := [];
#  deb_i := 0;
#  pos := 0;

  istrivstate := function(v)
    local i,j,perm;
    if v in checked then
      return true;
    else
      perm := ();
      for i in [1..Length(v)] do perm := perm * autlist[v[i]][d+1]; od;
      if perm <> () then return false; fi;
      Add(checked, v);
      for j in [1..d] do
        if not istrivstate(WordStateInList(v, j, autlist)) then
          return false;
        fi;
      od;
      return true;
    fi;
  end;

  exp := LetterRepAssocWord(a!.word);
  for i in [1..Length(exp)] do
    if exp[i] < 0 then exp[i] := -exp[i] + FamilyObj(a)!.numstates; fi;
  od;
  if istrivstate(exp) then
    Append(FamilyObj(a)!.relators, checked);
    return true;
  else
    return false;
  fi;

#   while Length(to_check) > pos do
#     pos := pos + 1;
#     w := to_check[pos];
#     Print(pos, " : ", Length(to_check), "\n");
# #       deb_i := deb_i + 1;
# #       Print(deb_i, "\n");
#
#     perm := ();
#     for i in [1..Length(w)] do
#       perm := perm * autlist[w[i]][d+1];
#     od;
#     if not IsOne(perm) then
#       return false;
#     fi;
#
#     for i in [1..d] do
#       nw := StateOfWordInAutomatonList(w, i, autlist);
#       if Length(nw) <> 0 then
#         if not nw in checked then
#           if not nw in to_check then
#             Add(to_check, nw);
#           fi;
#         fi;
#       fi;
#     od;
#     Add(checked, w);
#   od;
#
#   return true;
end);


###############################################################################
##
#M  a1 = a2
##
## TODO
InstallMethod(\=, "\=(IsAutom, IsAutom)", IsIdenticalObj, [IsAutom, IsAutom],
function(a1, a2)
  local areequalstates, exp, i, d, checked, autlist;

  d := a1!.deg;
  checked := [];
  autlist := FamilyObj(a1)!.automatonlist;

  areequalstates := function(p)
    local i, j, perm1, perm2;
    if p in checked then
      return true;
    else
      perm1 := ();
      perm2 := ();
      for i in [1..Length(p[1])] do perm1 := perm1 * autlist[p[1][i]][d+1]; od;
      for i in [1..Length(p[2])] do perm2 := perm2 * autlist[p[2][i]][d+1]; od;
      if perm1 <> perm2 then return false; fi;
      Add(checked, p);
      for j in [1..d] do
        if not areequalstates([WordStateInList(p[1], j, autlist),
                               WordStateInList(p[2], j, autlist)])
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

#   local d, checked_pairs, pos, aw1, aw2, np, i;
#
#   d := a1!.deg;
#   checked_pairs := [[a1!.word, a2!.word]];
#   if checked_pairs[1][1] = checked_pairs[1][2] then
#     return true;
#   fi;
#   pos := 0;
#
#   while Length(checked_pairs) <> pos do
#     pos := pos + 1;
#     aw1 := Autom(checked_pairs[pos][1], a1);
#     aw2 := Autom(checked_pairs[pos][2], a2);
#
#     if Perm(aw1) <> Perm(aw2) then
#       return false;
#     fi;
#
#     for i in [1..d] do
#       np := [aw1!.states[i], aw2!.states[i]];
#       if not np in checked_pairs then
#         checked_pairs := Concatenation(checked_pairs, [np]);
#       fi;
#     od;
#   od;
#
#   for i in [1..Length(checked_pairs)] do
#     if checked_pairs[i][1] <> checked_pairs[i][2] then
#       Add(FamilyObj(a1)!.relators,
#         checked_pairs[i][1]*checked_pairs[i][2]^-1);
#     fi;
#   od;
#   return true;
end);


###############################################################################
##
#M  a1 < a2
##
InstallMethod(\<, "\<(IsAutom, IsAutom)", IsIdenticalObj, [IsAutom, IsAutom],
function(a1, a2)
  local d, checked, pos, aw1, aw2, p, np, i, exp, perm1, perm2, autlist;

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
    if perm1 < perm2 then
      return true;
    elif perm1 > perm2 then
      return false;
    fi;
    for i in [1..d] do
      np := [WordStateInList(p[1], i, autlist), WordStateInList(p[2], i, autlist)];
      if not np in checked then
        Add(checked, np);
      fi;
    od;
  od;

  return false;

#   local d, checked_pairs, pos, aw1, aw2, np, i;
#
#   d := a1!.deg;
#   checked_pairs := [[a1!.word, a2!.word]];
#   pos := 0;
#
#   while Length(checked_pairs) <> pos do
#     pos := pos + 1;
#     aw1 := Autom(checked_pairs[pos][1], a1);
#     aw2 := Autom(checked_pairs[pos][2], a2);
#
#     if Perm(aw1) < Perm(aw2) then
#       return true;
#     elif Perm(aw1) > Perm(aw2) then
#       return false;
#     fi;
#
#     for i in [1..d] do
#       np := [aw1!.states[i], aw2!.states[i]];
#       if not np in checked_pairs then
#         Add(checked_pairs, np);
#       fi;
#     od;
#   od;
#
#   return false;
end);


###############################################################################
##
#M  InverseOp(<a>)
##
InstallMethod(InverseOp, "InverseOp(IsAutom)", [IsAutom],
function(a)
  local inv;
  inv := Objectify(NewType(FamilyObj(a), IsAutom and IsAutomRep),
            rec(word := a!.word ^ -1,
                states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1),
                perm := a!.perm ^ -1,
                deg := a!.deg) );
  SetIsActingOnBinaryTree(inv, a!.deg = 2);
  return inv;
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
#M  State(a, k)
##
InstallOtherMethod(State, "State(IsAutom, IsPosInt)", [IsAutom, IsPosInt],
function(a, k)
  if k > a!.deg then
    Print("error in State(IsAutom, IsPosInt): wrong vertex number\n");
    return fail;
  fi;
  return Autom(a!.states[k], a);
end);


###############################################################################
##
#M  State(a, seq)
##
## TODO
InstallMethod(State, "State(IsAutom, IsList)", [IsAutom, IsList],
function(a, v)
  if Length(v) = 0 then
    return a;
  fi;

  if Length(v) = 1 then
    return State(a, v[1]);
  fi;

  return State(State(a, v[1]), v{[2..Length(v)]});
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

    if HasAutomatonList(a) then
      return ImageOfVertexInList( AutomatonList(a),
                                  AutomatonListInitialState(a),
                                  seq );
    fi;

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
        cur := WordStateAndPermInList(cur[1], seq[i],
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
              [IsAutom, IsPosInt],
function(a, k)
    local dom, perm;

    dom := AsList(Tuples([1..DegreeOfTree(a)], k));
    perm := List(dom, s -> s ^ a);
    perm := PermListList(dom, perm);

    return perm;
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
# #M  Expand(a)
# ##
# InstallMethod(Expand, [IsFGAutom],
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
#       Print(AutomataParameters.identity_symbol);
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
# #M  ExpandRen(a)
# ##
# InstallMethod(ExpandRen, [IsFGAutom],
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
#       Print(AutomataParameters.identity_symbol);
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
#       if not aut!.States[i] in states then
#         Add(states, aut!.States[i]);
#       fi;
#     od;
#
#     Add(list_comp, Concatenation(List(aut!.States, w -> Position(states, w)), [aut!.Perm]));
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
  abels := AbelImagesGenerators(FamilyObj(a));
  if not IsEmpty(w) then
    return Sum(List(w, x -> abels[x]));
  else
    return Zero(abels[1]);
  fi;
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
              [IsAutom],
function(a)
  local w, i, ab, abs;

  if IsOne(Word(a)) then
    Info(InfoAutomata, 3, "IsSphericallyTransitive(a): false");
    Info(InfoAutomata, 3, "  IsOne(Word(a)): a = ", a);
    return false;
  fi;

  TryNextMethod();
end);


###############################################################################
##
#M  Order(<a>)
##
InstallMethod(Order, "Order(IsAutom)",
              [IsAutom],
function(a)
  if IsOne(a) then return 1; fi;
  if CanEasilyTestSphericalTransitivity(a) and
      IsSphericallyTransitive(a) then return infinity; fi;
  TryNextMethod();
end);


###############################################################################
##
#M  <l1> * <l2>
##
InstallOtherMethod(\*, "", [IsList, IsList], 50,
function(a1, a2)
    local d, prod;
    d := Length(a1) - 1;
    prod := List([1..d], i -> a1[i] * a2[i^a1[d+1]]);
    Add(prod, a1[d+1]*a2[d+1]);
    return prod;
end);


###############################################################################
##
#M  InverseOp(<l>)
##
InstallOtherMethod(InverseOp, "", [IsList], 50,
function(l)
  local inv, d;
  d := Length(l) - 1;
  inv := List([1..d], i -> l[i^(l[d+1]^-1)]^-1);
  Add(inv, l[d+1]^-1);
  return inv;
end);


###############################################################################
##
#M  One(<l>)
##
InstallOtherMethod(OneOp, "", [IsList], 50,
function(l)
  local one, d;
  d := Length(l) - 1;
  one := List([1..d], i -> One(l[1]));
  Add(one, ());
  return one;
end);


#E
