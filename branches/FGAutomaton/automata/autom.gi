#############################################################################
##
#W  autom.gi                 automata package                  Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##

Revision.autom_gi :=
  "@(#)$Id$";


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
#R  IsAutomFamilyRep
##
##  Any object from category AutomFamily which is created here, lies in a
##  category IsAutomFamilyRep.
##  Family of Autom object <a> contains all essential information about
##  (mathematical) automaton which generates group containing <a>:
##  it contains automaton, relators found, properties of automaton and group
##  generated by it, etc.
##  Also family contains group generated by states of underlying automaton.
##
DeclareRepresentation("IsAutomFamilyRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      [ "freegroup", "freegens",
                        "numstates", "deg", "trivstate",
                        "names", "automatonlist"]);


###############################################################################
##
#M  AutomFamily(<list>, <names>, <trivname>)
##
InstallMethod(AutomFamily, [IsList, IsList, IsString],
function (list, names, trivname)
  local deg, tmp, trivstate, numstates, numallstates, i, j, perm,
        freegroup, freegens, a, family;

  if not IsCorrectAutomatonList(list) then
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

  if numstates = 0 then
    Print("error in AutomFamily(IsList, IsList, IsString):\n  don't want to work with trivial automaton\n");
    return fail;
  fi;

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
    names[trivstate] := trivname;
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

  family!.automgens := [];
  for i in [1..Length(list)] do
    family!.automgens[i] := Objectify(
      NewType(family, IsAutom and IsAutomRep),
      rec(word := freegens[i],
          states := List([1..deg], j -> freegens[list[i][j]]),
          perm := list[i][deg+1],
          deg := deg) );
  od;

  return family;
end);


###############################################################################
##
#M  AutomFamily(<list>)
##
InstallOtherMethod(AutomFamily, [IsList],
function(list)
  if not IsCorrectAutomatonList(list) then
    Print("error in AutomFamily(IsList):\n  given list is not a correct list representing automaton\n");
    return fail;
  fi;
  return AutomFamily(list,
    List([1..Length(list)],
      i -> Concatenation(AutomataParameters.state_symbol, String(i))),
    AutomataParameters.identity_symbol);
end);


###############################################################################
##
#M  Degree(<fam>)
##
InstallOtherMethod(Degree, [IsAutomFamily],
function(fam)
  return fam!.deg;
end);


###############################################################################
##
#M  Autom(<word>, <fam>)
##
InstallMethod(Autom, [IsAssocWord, IsAutomFamily and IsAutomFamilyRep],
function(w, fam)
  local exp, wstates, curstate, newstate, curletter, newletter,
        nperm, i, j, perm;

  if Length(w) = 0 then
    return One(fam);
  elif Length(w) = 1 then
    if ExponentSyllable(w, 1) = 1 then
      return fam!.automgens[GeneratorSyllable(w, 1)];
    else
      return fam!.automgens[GeneratorSyllable(w, 1) + fam!.numstates];
    fi;
  else
    exp := ExpandExtRepOfWord(w, fam!.numstates);
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
      wstates[i] := WordByExpExtRep(wstates[i], w);
    od;

    return Objectify(NewType(fam, IsAutom and IsAutomRep),
            rec(word := w,
                states := wstates,
                perm := nperm,
                deg := fam!.deg) );
  fi;
end);


###############################################################################
##
#M  Autom(<word>, <a>)
##
InstallOtherMethod(Autom, [IsAssocWord, IsAutom],
function(w, a)
  return Autom(w, FamilyObj(a));
end);


###############################################################################
##
#M  Autom(<word>, <list>)
##
InstallOtherMethod(Autom, [IsAssocWord, IsList],
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
InstallMethod(PrintObj, [IsAutom],
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
#M  TopPerm(<a>)
##
InstallMethod(TopPerm, [IsAutom],
function(a)
    return a!.perm;
end);


###############################################################################
##
#M  Perm(<a>)
##
InstallOtherMethod(Perm, [IsAutom],
function(a)
    return a!.perm;
end);


# ###############################################################################
# ##
# #M  Perm(a, k)
# ##
# InstallMethod(Perm, [IsFGAutom, IsInt],
# function(a, k)
#     local dom, perm;
#
#     if k <= 0 then
#       Error("Perm(IsFGAutom, IsInt): level number is not positive\n");
#     fi;
#
#     dom := AsList(Tuples([1..Degree(a)], k));
#     perm := List(dom, s -> s ^ a);
#     perm := PermListList(dom, perm);
#
#     return perm;
# end);


###############################################################################
##
#M  Degree(<a>)
##
InstallOtherMethod(Degree, [IsAutom],
function(a)
    return a!.deg;
end);


###############################################################################
##
#M  Word(<a>)
##
InstallOtherMethod(Word, [IsAutom],
function(a)
    return a!.word;
end);


###############################################################################
##
#M  <a1> * <a2>
##
InstallMethod(\*, [IsAutom, IsAutom],
function(a1, a2)
    return Objectify(
        NewType(FamilyObj(a1), IsAutom and IsAutomRep),
        rec(word := a1!.word * a2!.word,
            states := List([1..a1!.deg], i -> a1!.states[i] * a2!.states[i^(a1!.perm)]),
            perm := a1!.perm * a2!.perm,
            deg := a1!.deg) );
end);


###############################################################################
##
#M  IsOne(a)
##
InstallOtherMethod(IsOne, [IsAutom],
function(a)
  local i, w, nw, d, to_check, checked, deb_i, perm, autlist, pos, istrivstate;

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
        if not istrivstate(StateOfWordInAutomatonList(v, j, autlist)) then
          return false;
        fi;
      od;
      return true;
    fi;
  end;

  return istrivstate(ExpandExtRepOfWord(a!.word, FamilyObj(a)!.numstates));

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
InstallMethod(\=, [IsAutom, IsAutom],
function(a1, a2)
  local d, checked_pairs, pos, aw1, aw2, np, i;

  d := a1!.deg;
  checked_pairs := [[a1!.word, a2!.word]];
  pos := 0;

  while Length(checked_pairs) <> pos do
    pos := pos + 1;
    aw1 := Autom(checked_pairs[pos][1], a1);
    aw2 := Autom(checked_pairs[pos][2], a2);

    if Perm(aw1) <> Perm(aw2) then
      return false;
    fi;

    for i in [1..d] do
      np := [aw1!.states[i], aw2!.states[i]];
      if not np in checked_pairs then
        checked_pairs := Concatenation(checked_pairs, [np]);
      fi;
    od;
  od;

  return true;
end);


###############################################################################
##
#M  a1 < a2
##
InstallMethod(\<, [IsAutom, IsAutom],
function(a1, a2)
  local d, checked_pairs, pos, aw1, aw2, np, i;

  d := a1!.deg;
  checked_pairs := [[a1!.word, a2!.word]];
  pos := 0;

  while Length(checked_pairs) <> pos do
    pos := pos + 1;
    aw1 := Autom(checked_pairs[pos][1], a1);
    aw2 := Autom(checked_pairs[pos][2], a2);

    if Perm(aw1) < Perm(aw2) then
      return true;
    elif Perm(aw1) > Perm(aw2) then
      return false;
    fi;

    for i in [1..d] do
      np := [aw1!.states[i], aw2!.states[i]];
      if not np in checked_pairs then
        checked_pairs := Concatenation(checked_pairs, [np]);
      fi;
    od;
  od;

  return false;
end);


###############################################################################
##
#M  InverseOp(<a>)
##
InstallMethod(InverseOp, [IsAutom],
function(a)
  return Objectify(NewType(FamilyObj(a), IsAutom and IsAutomRep),
            rec(word := a!.word ^ -1,
                states := List([1..a!.deg], i -> a!.states[i^(a!.perm^-1)]^-1),
                perm := a!.perm ^ -1,
                deg := a!.deg) );
end);


###############################################################################
##
#M  OneOp(<a>)
##
InstallMethod(OneOp, [IsAutom],
function(a)
    return One(FamilyObj(a));
end);


###############################################################################
##
#M  One(<fam>)
##
InstallOtherMethod(One, [IsAutomFamily],
function(fam)
    return Objectify(NewType(fam, IsAutom and IsAutomRep),
            rec(word := One(fam!.freegroup),
                states := List([1..fam!.deg], i -> One(fam!.freegroup)),
                perm := (),
                deg := fam!.deg)  );
end);


###############################################################################
##
#M  State(a, k)
##
InstallMethod(State, [IsAutom, IsInt],
function(a, k)
  if k < 1 or k > a!.deg then
    Print("error in State(IsAutom, IsInt): wrong vertex number\n");
  fi;
  return Autom(a!.states[k], a);
end);


###############################################################################
##
#M  StatesWords(<a>)
##
InstallMethod(StatesWords, [IsAutom],
function(a)
  return a!.states;
end);


# ###############################################################################
# ##
# #M  Projection(a, seq)
# ##
# InstallOtherMethod(Projection, [IsFGAutom, IsList],
# function(a, v)
#   if Length(v) = 0 then
#     return a;
#   fi;
#
#   if v[1]^a <> v[1] then
#     Error("Projection(IsFGAutom, IsList): given autmaton does not stabilize given vertex\n");
#   fi;
#
#   if Length(v) = 1 then
#     return Projection(a, v[1]);
#   fi;
#
#   return Projection(Projection(a, v[1]), v{[2..Length(v)]});
# end);
#
#
# ###############################################################################
# ##
# #M  k ^ a
# ##
# InstallOtherMethod(\^, [IsInt, IsFGAutom],
# function(k, a)
#     return k ^ Perm(a);
# end);
#
#
# ###############################################################################
# ##
# #M  \^(seq, a)
# ##
# InstallOtherMethod(\^, [IsList, IsFGAutom],
# function(seq, a)
#     local i, deg, img, cur;
#
#     deg := a!.Degree;
#     for i in seq do
#     if not IsInt(i) or i < 1 or i > deg then
#         Print("\^(IsList, IsFGAutom): ",
#             i, "is out of range 1..", deg, "\n");
#     fi; od;
#
#     if Length(seq) = 1 then return [seq[1]^a]; fi;
#
#     cur := a;
#     img := [];
#     for i in [1..Length(seq)] do
#         img[i] := seq[i]^Perm(cur);
#         cur := FGAutom(cur!.States[seq[i]], a);
#     od;
#
#     return img;
# end);
#
#
# ###############################################################################
# ##
# #M  IsActingOnBinaryTree(fam)
# ##
# InstallMethod(IsActingOnBinaryTree, [IsFGAutomFamily],
# function(fam)
#     return fam!.Degree = 2;
# end);
#
#
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











