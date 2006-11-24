#############################################################################
##
#W  listops.gd             automata package                    Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#F  IsCorrectAutomatonList( <list> )
##
##  Checks whether the list is correct list to define automaton, i.e.:
##  [[a_11,...,a_1n,p_1],[a_21,...,a_2n,p_2],...,[a_m1...a_mn,p_m]],
##  where n >= 2, m >= 1, a_ij are IsInt in [1..m], and all p_i are
##  in SymmetricalGroup(n).
##
InstallGlobalFunction(IsCorrectAutomatonList,
function(list)
  local len, deg, i, j;

  if not IsDenseList(list) then
    return false;
  fi;

  len := Length(list);
  if len = 0 then
    return false;
  fi;

  for i in [1..len] do
    if not IsDenseList(list[i]) then
      return false;
    fi;
    if Length(list[i]) <> Length(list[1]) then
      return false;
    fi;
  od;

  deg := Length(list[1]) - 1;
  if deg < 2 then
    return false;
  fi;

  for i in [1..len] do
    for j in [1..deg] do
      if not IsInt(list[i][j]) then
        return false;
      fi;
      if list[i][j] > len or list[i][j] < 1 then
        return false;
      fi;
    od;
    if not list[i][deg + 1] in SymmetricGroup(deg) then
      return false;
    fi;
  od;

  return true;
end);


###############################################################################
##
#F  ConnectedStatesInList(state, list)
##
##  Returns list of states which are reachable from given state,
##  it does not check correctness of arguments
##
InstallGlobalFunction(ConnectedStatesInList,
function(state, list)
  local i, s, d, to_check, checked;

  d := Length(list[1]) - 1;

  to_check := [state];
  checked := [];

  while Length(to_check) <> 0 do
    for s in to_check do
      for i in [1..d] do
        if (not list[s][i] in checked) and (not list[s][i] in to_check)
        then
          to_check := Union(to_check, [list[s][i]]);
        fi;
      od;
      checked := Union(checked, [s]);
      to_check := Difference(to_check, [s]);
    od;
  od;

  return checked;
end);


###############################################################################
##
#F  IsTrivialStateInList( <state>, <list>)
##
##  Checks whether given state is trivial.
##  Does not check correctness of arguments.
##
InstallGlobalFunction(IsTrivialStateInList,
function(state, list)
  local i, s, d, to_check, checked;

  d := Length(list[1]) - 1;
  to_check := [state];
  checked := [];

  while Length(to_check) <> 0 do
    for s in to_check do
      for i in [1..d] do
        if not IsOne(list[s][d+1]) then
          return false;
        fi;
        if (not list[s][i] in checked) and (not list[s][i] in to_check)
        then
          to_check := Union(to_check, [list[s][i]]);
        fi;
      od;
      checked := Union(checked, [s]);
      to_check := Difference(to_check, [s]);
    od;
  od;

  return true;
end);


###############################################################################
##
#F  AreEquivalentStatesInList( <state1>, <state2>, <list> )
##
##  Checks whether two given states are equivalent.
##  Does not check correctness of arguments.
##
InstallGlobalFunction(AreEquivalentStatesInList,
function(state1, state2, list)
  local d, checked_pairs, pos, s1, s2, np, i;

  d := Length(list[1]) - 1;
  checked_pairs := [[state1, state2]];
  pos := 0;

  while Length(checked_pairs) <> pos do
    pos := pos + 1;
    s1 := checked_pairs[pos][1];
    s2 := checked_pairs[pos][2];

    if list[s1][d+1] <> list[s2][d+1] then
      return false;
    fi;

    for i in [1..d] do
      np := [list[s1][i], list[s2][i]];
      if not np in checked_pairs then
        checked_pairs := Concatenation(checked_pairs, [np]);
      fi;
    od;
  od;

  return true;
end);


###############################################################################
##
#F  AreEquivalentStatesInLists( <state1>, <state2>, <list1>, <list2>)
##
##  Checks whether two given states in different lists are equivalent.
##  Does not check correctness of arguments.
##
InstallGlobalFunction(AreEquivalentStatesInLists,
function(state1, state2, list1, list2)
  local d, checked_pairs, pos, s1, s2, np, i;

  d := Length(list1[1]) - 1;
  checked_pairs := [[state1, state2]];
  pos := 0;

  while Length(checked_pairs) <> pos do
    pos := pos + 1;
    s1 := checked_pairs[pos][1];
    s2 := checked_pairs[pos][2];

    if list1[s1][d+1] <> list2[s2][d+1] then
      return false;
    fi;

    for i in [1..d] do
      np := [list1[s1][i], list2[s2][i]];
      if not np in checked_pairs then
        checked_pairs := Concatenation(checked_pairs, [np]);
      fi;
    od;
  od;

  return true;
end);


###############################################################################
##
#F  ReducedAutomatonInList( <list> )
##
##  Returns [new_list, list_of_states] where new_list is a new list which
##  represents reduced form of given automaton, i-th elmt of list_of_states
##  is the number of i-th state of new automaton in the old one.
##
##  First state of returned list is always first state of given one.
##  It does not remove trivial state, so it's not really "reduced automaton",
##  it just removes equivalent states.
##  TODO: write such function which removes trivial state
##
##  Does not check correctness of list.
##
InstallGlobalFunction(ReducedAutomatonInList,
function(list)
  local   i, n, triv_states, equiv_classes, checked_states, s, s1, s2,
          eq_cl, eq_cl_1, eq_cl_2, are_equiv, eq_cl_reprs,
          new_states, new_list, deg,
          reduced_automaton, state, states_reprs;

  n := Length(list);
  triv_states := [];
  equiv_classes := [];
  checked_states := [];
  deg := Length(list[1]) - 1;

  for s in [1..n] do
      if IsTrivialStateInList(s, list) then
          triv_states := Union(triv_states, [s]);
      fi;
  od;

  equiv_classes:=[triv_states];
  for s1 in Difference([1..n], triv_states) do
  for s2 in Difference([s1+1..n], triv_states) do
    are_equiv := AreEquivalentStatesInList(s1, s2, list);

    if s1 in checked_states then
      for eq_cl in equiv_classes do
        if s1 in eq_cl then
          eq_cl_1 := StructuralCopy(eq_cl);
          break; fi; od;
    else
      equiv_classes := Union(equiv_classes, [[s1]]);
      eq_cl_1 := [s1];
      checked_states := Union(checked_states, [s1]);
    fi;
    if s2 in checked_states then
      for eq_cl in equiv_classes do
        if s2 in eq_cl then
          eq_cl_2 := StructuralCopy(eq_cl);
          break; fi; od;
    else
      equiv_classes := Union(equiv_classes, [[s2]]);
      eq_cl_2 := [s2];
      checked_states := Union(checked_states, [s2]);
    fi;

    if are_equiv then
      equiv_classes := Difference(equiv_classes, [eq_cl_1, eq_cl_2]);
      equiv_classes := Union(equiv_classes, [Union(eq_cl_1, eq_cl_2)]);
    fi;
  od;
  od;
  states_reprs := [1..n];
  for eq_cl in equiv_classes do
    for s in eq_cl do
      states_reprs[s] := Minimum(eq_cl);
    od;
  od;


  new_states := Set(states_reprs);
  new_list := [];

  for s in new_states do
    state := [];
    state[deg+1] := list[s][deg+1];
    for i in [1..deg] do
      state[i] := Position(new_states, states_reprs[list[s][i]]);
    od;
    new_list := Concatenation(new_list, [state]);
  od;

  return [new_list, new_states];
end);


###############################################################################
##
#F  MinimalSubAutomatonInlist(<states>, <list>)
##
##  Returns list representation of automaton given by <list> which is minimal
##  subatomaton of automaton containing states <states>.
##
##  Does not check correctness of list.
##
InstallGlobalFunction(MinimalSubAutomatonInlist,
function(states, list)
  local s, new_states, state, new_list, i, deg;

  new_states := [];
  for s in states do
    new_states := Union(new_states, ConnectedStatesInList(s, list));
  od;

  new_list := [];
  deg := Length(list[1]) - 1;

  for s in new_states do
    state := [];
    for i in [1..deg] do
      state[i] := Position(new_states, list[s][i]);
    od;
    state[deg+1] := list[s][deg+1];
    new_list := Concatenation(new_list, [state]);
  od;

  return [new_list, new_states];
end);


###############################################################################
##
#F  PermuteStatesInList(<list>, <perm>)
##
##  Does not check correctness of arguments.
##
InstallGlobalFunction(PermuteStatesInList,
function(list, perm)
  local new_list, i, j, deg;

  deg := Length(list[1]) - 1;
  new_list := [];
  for i in [1..Length(list)] do
    new_list[i^perm] := [];
    for j in [1..deg] do
      new_list[i^perm][j] := list[i][j]^perm;
    od;
    new_list[i^perm][deg+1] := list[i][deg+1];
  od;

  return new_list;
end);


###############################################################################
##
#F  WordStateInList(<w>, <s>, <list>)
##
##  It's ProjectWord from selfs.g
##  Does not check correctness of arguments.
##
InstallGlobalFunction(WordStateInList,
function(w, s, list)
  local i, perm, d, proj;
  d := Length(list[1])-1;
  proj := [];
  perm := ();
  for i in [1..Length(w)] do
    Add(proj, list[w[i]][s^perm]);
    perm := perm * list[w[i]][d+1];
  od;
  return proj;
end);


###############################################################################
##
#F  WordStateAndPermInList(<w>, <s>, <list>)
##
##  Does not check correctness of arguments.
##
InstallGlobalFunction(WordStateAndPermInList,
function(w, s, list)
  local i, perm, perm_res, new_state, d, proj;
  d := Length(list[1])-1;
  proj := [];
  perm := ();
  perm_res := ();
  for i in [1..Length(w)] do
    new_state := list[w[i]][s^perm];
    Add(proj, new_state);
    perm := perm * list[w[i]][d+1];
    perm_res := perm_res * list[new_state][d+1];
  od;
  return [proj, perm_res];
end);


###############################################################################
##
#F  ImageOfVertexInList(<list>, <init>, <vertex>)
##
##  Does not check correctness of arguments.
##
InstallGlobalFunction(ImageOfVertexInList,
function(list, s, seq)
  local deg, img, x;

  deg := Length(list[1]) - 1;
  img := [];
  for x in seq do
      Add(img, x^list[s][deg+1]);
      s := list[s][x];
  od;

  return img;
end);


###############################################################################
##
#F  DiagonalActionInList(<list>, <n>)
##
InstallGlobalFunction(DiagonalActionInList,
function(list, n, names)
  local d, nlist, nd, nalph, nstates, nperm,
        i, j, k, letter, n_letter, n_state, state,
        nnames;

  d := Length(list[1]) - 1;
  nd := d ^ n;
  nalph := Tuples([1..d], n);
  nstates := Tuples([1..Length(list)], n);
  nlist := List([1..Length(nstates)], i -> []);
  nnames := List(nstates, s->List(s, i->names[i]));

  for i in [1..Length(nlist)] do
    nperm := [];
    state := nstates[i];
    for j in [1..nd] do
      letter := nalph[j];
      n_letter := [];
      n_state := [];
      for k in [1..n] do
        n_letter[k] := letter[k]^list[state[k]][d+1];
        n_state[k] := list[state[k]][letter[k]];
      od;
      nperm[j] := n_letter;
      nlist[i][j] := Position(nstates, n_state);
    od;
    nlist[i][nd+1] := PermListList(nalph, nperm);
  od;

  nnames := List(nnames, l->Concatenation(l));
  return [nlist, nnames];
end);


###############################################################################
##
#F  MultAlphabetInList(<list>, <n>)
##
InstallGlobalFunction(MultAlphabetInList,
function(list, n)
  local d, nlist, nd, nalph, nperm,
        i, j, k, letter, n_letter, st;

  d := Length(list[1]) - 1;
  nd := d ^ n;
  nalph := Tuples([1..d], n);
  nlist := List(list, i -> []);

  for i in [1..Length(nlist)] do
    nperm := [];
    for j in [1..Length(nalph)] do
      letter := nalph[j];
      n_letter := [];
      st := i;
      for k in [1..n] do
        Add(n_letter, letter[k]^list[st][d+1]);
        st := list[st][letter[k]];
      od;
      nlist[i][j] := st;
      nperm[j] := n_letter;
    od;
    nlist[i][nd+1] := PermListList(nalph, nperm);
  od;

  return nlist;
end);


###############################################################################
##
#F  HasDualInList(<list>)
##
InstallGlobalFunction(HasDualInList,
function(list)
  local i, j, p, d, n;
  d := Length(list[1]) - 1;
  n := Length(list);
  for i in [1..d] do
    p := [];
    for j in [1..n] do
      p[j] := list[j][i];
    od;
    if PermListList([1..n], p) = fail then
      return false;
    fi;
  od;
  return true;
end);


###############################################################################
##
#F  DualAutomatonList(<list>)
##
InstallGlobalFunction(DualAutomatonList,
function(list)
  local dual, d, n;
  d := Length(list[1]) - 1;
  n := Length(list);
  return List([1..d], i -> Concatenation(List([1..n], j -> i^list[j][d+1]),
    [PermList(List([1..n], j -> list[j][i]))]));
end);


###############################################################################
##
#F  HasDualOfInverseInList(<list>)
##
InstallGlobalFunction(HasDualOfInverseInList,
function(list)
  return HasDualInList(InverseAutomatonList(list));
end);


###############################################################################
##
#F  InverseAutomatonList(<list>)
##
InstallGlobalFunction(InverseAutomatonList,
function(list)
  local inv, d, i;
  d := Length(list[1]) - 1;
  inv := List(list, l -> Permuted(l, l[d+1]));
  for i in [1..Length(list)] do inv[i][d+1] := inv[i][d+1]^-1; od;
  return inv;
end);


#E
