#############################################################################
##
#W  automaton.gi              automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsMealyAutomatonRep
##
DeclareRepresentation("IsMealyAutomatonRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["table",     # transitions: table[i][j] is the state automaton goes to after processing letter j
                                    # if it was in state i
                       "perms",     # output: perms[i] is the output function at state i. It is either IsPerm or IsTransformation
                       "trans",     # images of elements of perms: i^perms[j] = trans[j][i]
                       "alphabet",  # by default it's [1..degree]; may be something different e.g. after taking "cross product"
                                    # it's used for pretty printing, internally only [1..degree] is used
                       "degree",    # Length(alphabet)
                       "states",    # names of the states
                       "n_states",  # Length(states), Length(table)
                       ]);
BindGlobal("AG_AutomatonFamily", NewFamily("AutomatonFamily", IsMealyAutomaton, IsMealyAutomaton, IsMealyAutomatonFamily));


BindGlobal("AG_IsInvertible",
function(t)
  return RankOfTransformation(t) = DegreeOfTransformation(t);
end);


BindGlobal("_AG_CreateAutomaton",
function(table, states, alphabet)
  local a, s, i, n_states, invertible, degree, perms;

  if not AG_IsCorrectAutomatonList(table, false) then
    Error("'", table, "' is not a correct table representing a finite automaton");
  fi;

  if states = fail then
    states := List([1..Length(table)], i -> Concatenation(AG_Globals.state_symbol, String(i)));
  else
    if Length(states) <> Length(table) then
      Error("number of state names is not equal to the number of states");
    fi;
    if Length(Set(states)) <> Length(states) then
      Error("duplicated states names");
    fi;
    states := List(states, s -> String(s));
  fi;

  if alphabet = fail then
    alphabet := [1 .. Length(table[1])-1];
  else
    if Length(alphabet) <> Length(table[1]) - 1 then
      Error("number of letters in alphabet does not agree with the automaton table");
    fi;
    alphabet := StructuralCopy(alphabet);
  fi;

  n_states := Length(table);
  degree := Length(alphabet);
  perms := List(table, s -> s[degree+1]);
  table := List(table, s -> s{[1..degree]});
  invertible := true;

  for i in [1..n_states] do
    if not IsPerm(perms[i]) and not AG_IsInvertible(perms[i]) then
      invertible := false;
      break;
    fi;
  od;

  if not invertible then
    for i in [1..n_states] do
      if IsPerm(perms[i]) then
        perms[i] := Transformation(List([1..degree], j -> j^perms[i]));
      fi;
    od;
  else
    for i in [1..n_states] do
      if not IsPerm(perms[i]) then
        perms[i] := PermList(ImageListOfTransformation(perms[i]));
      fi;
    od;
  fi;

  a := Objectify(NewType(AG_AutomatonFamily, IsMealyAutomaton and IsMealyAutomatonRep),
                 rec(table := table,
                     perms := perms,
                     trans := List([1..n_states], i -> List([1..degree], j -> j^perms[i])),
                     states := states,
                     n_states := n_states,
                     alphabet := alphabet,
                     degree := degree));

  SetIsInvertible(a, invertible);

  return a;
end);


BindGlobal("__AG_PrintPerm",
function(p)
  if IsPerm(p) then
    Print(p);
  else
    Print(ImageListOfTransformation(p));
  fi;
end);

BindGlobal("__AG_PermString",
function(p)
  if IsPerm(p) then
    return String(p);
  else
    return String(ImageListOfTransformation(p));
  fi;
end);



InstallMethod(MealyAutomaton, [IsList, IsList, IsList],
function(table, states, alphabet)
  return _AG_CreateAutomaton(table, states, alphabet);
end);

InstallMethod(MealyAutomaton, [IsList, IsList],
function(table, states)
  return _AG_CreateAutomaton(table, states, fail);
end);

InstallMethod(MealyAutomaton, [IsList],
function(table)
  return _AG_CreateAutomaton(table, fail, fail);
end);

InstallMethod(MealyAutomaton, [IsString],
function(string)
  local ret;
  ret := AG_ParseAutomatonString(string);
  return MealyAutomaton(ret[2], ret[1]);
end);


InstallMethod(MealyAutomaton, [IsTreeHomomorphism],
function(a)
  return MealyAutomaton([a]);
end);

InstallMethod(MealyAutomaton, [IsList and IsTreeHomomorphismCollection],
function(tree_hom_list)
  return MealyAutomaton(tree_hom_list, false);
end);

###############################################################################
##
##
##
InstallMethod(MealyAutomaton, [IsList, IsObject],
function(tree_hom_list, name_func)
  local a, states, names, MealyAutomatonLocal, aut_list;

  MealyAutomatonLocal := function(g)
    local cur_state;
    if g in states then return Position(states, g); fi;
    Add(states, g);
    if IsFunction(name_func) then
      Add(names, name_func(g));
    elif name_func = true then
      Add(names, Concatenation("<", String(g), ">"));
    fi;
    cur_state := Length(states);
    aut_list[cur_state] := List([1..g!.deg], x -> MealyAutomatonLocal(Section(g, x)));
    Add(aut_list[cur_state], g!.perm);
    return cur_state;
  end;

  names := [];
  states := [];
  aut_list := [];
  for a in tree_hom_list do
    MealyAutomatonLocal(a);
  od;

  if not IsEmpty(names) then
    return MealyAutomaton(aut_list, names);
  else
    return MealyAutomaton(aut_list);
  fi;
end);

InstallMethod(MealyAutomaton, [IsSelfSim],
function(a)
  local states, MealyAutomatonLocal, aut_list;

  MealyAutomatonLocal := function(g)
    local cur_state;
    if g!.word in states then return Position(states, g!.word); fi;
    Add(states, g!.word);
    cur_state := Length(states);
    aut_list[cur_state] := List([1..g!.deg], x -> MealyAutomatonLocal(Section(g, x)));
    Add(aut_list[cur_state], g!.perm);
    return cur_state;
  end;

  states := [];
  aut_list := [];
  MealyAutomatonLocal(a);
  return MealyAutomaton(aut_list);
end);


InstallMethod(SetStateName, [IsMealyAutomaton, IsInt, IsString],
function(aut, k, name)
  local new_names;
  if k < 1 or k > aut!.n_states then
    Error("wrong state number ", k);
  fi;
  new_names := List(aut!.states);
  new_names[k] := name;
  SetStateNames(aut, new_names);
end);

InstallMethod(SetStateNames, [IsMealyAutomaton, IsList],
function(aut, names)
  if not IsDenseList(names) or Length(names) <> aut!.n_states or
     not ForAll(names, IsString) or Length(AsSet(names)) <> aut!.n_states
  then
    Error("invalid state names list, it must be a dense list of strings of length ",
          aut!.n_states, " without duplicates");
  fi;
  aut!.states := MakeImmutable(List(names));
end);


InstallMethod(Display, [IsMealyAutomaton and IsMealyAutomatonRep],
function(a)
  local i, j;

  for i in [1..a!.n_states] do
    Print(a!.states[i], " = (");
    for j in [1..a!.degree] do
      Print(a!.states[a!.table[i][j]]);
      if j <> a!.degree then
        Print(", ");
      fi;
    od;
    Print(")");
    if not IsOne(a!.perms[i]) then
      __AG_PrintPerm(a!.perms[i]);
    fi;
    if i <> a!.n_states then
      Print(", ");
    fi;
  od;
end);

InstallMethod(String, [IsMealyAutomaton and IsMealyAutomatonRep],
function(a)
  local i, j, str;
  str := "";
  for i in [1..a!.n_states] do
    Append(str,Concatenation(String(a!.states[i]), " = ("));
    for j in [1..a!.degree] do
      Append(str,String(a!.states[a!.table[i][j]]));
      if j <> a!.degree then
        Append(str,", ");
      fi;
    od;
    Append(str, ")");
    if not IsOne(a!.perms[i]) then
      Append(str,__AG_PermString(a!.perms[i]));
    fi;
    if i <> a!.n_states then
      Append(str,", ");
    fi;
  od;
  return str;
end);

InstallMethod(ViewObj, [IsMealyAutomaton],
function(a)
  Print("<automaton>");
end);


InstallMethod(PrintObj, [IsMealyAutomaton],
function(a)
  Print("MealyAutomaton(\"",String(a),"\")");
end);


BindGlobal("AG_AutomatonTransform",
function(a, q, x)
  local i, j, nq, nx, t;

  nq := Length(q);
  nx := Length(x);

  for i in [1..nq] do
    for j in [1..nx] do
      t := x[j];
      x[j] := a!.trans[q[i]][t];
      q[i] := a!.table[q[i]][t];
    od;
  od;
end);


# InstallMethod(TransitionFunction, [IsMealyAutomaton and IsMealyAutomatonRep],
# function(a)
#   local func, table;
#
#   table := a!.table;
#
#   func := function(Q, X)
#
#   end;
#
#   return func;
# end);


InstallMethod(AutomatonList, [IsMealyAutomaton],
function(a)
  return List([1..a!.n_states], i -> Concatenation(a!.table[i], [a!.perms[i]]));
end);


InstallMethod(NumberOfStates, [IsMealyAutomaton],
function(A)
  return A!.n_states;
end);


InstallMethod(SizeOfAlphabet, [IsMealyAutomaton],
function(A)
  return A!.degree;
end);


InstallMethod(AG_MinimizedAutomatonList, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  return AG_AddInversesList(List(AutomatonList(A), x -> List(x)));
end);


InstallGlobalFunction(MinimizationOfAutomatonTrack,
function(a)
  local min_aut;
  min_aut := AG_MinimizationOfAutomatonListTrack(List(AutomatonList(a), x -> List(x)));
  return [MealyAutomaton(min_aut[1], a!.states{min_aut[2]}), min_aut[2], min_aut[3]];
end);


InstallGlobalFunction(MinimizationOfAutomaton,
function(a)
  local min_aut;
  min_aut := AG_MinimizationOfAutomatonListTrack(List(AutomatonList(a), x -> List(x)));
  return MealyAutomaton(min_aut[1], a!.states{min_aut[2]});
end);


# this is the method which uses PolynomialDegreeOfGrowthOfUnderlyingAutomaton
#InstallMethod(IsOfPolynomialGrowth, "for [IsMealyAutomaton]", true,
#              [IsMealyAutomaton],
#function(A)
#  local G, res;
#  G := AutomatonGroup(A);
#  res := IsGeneratedByAutomatonOfPolynomialGrowth(G);
#  if res then
#    SetPolynomialDegreeOfGrowth(A, PolynomialDegreeOfGrowthOfUnderlyingAutomaton(G));
#  fi;
#  SetIsBounded(A, IsGeneratedByBoundedAutomaton(G));
#  return res;
#end);


InstallMethod(IsOfPolynomialGrowth, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  local i, d, ver, nstates, cycles, cycle_of_vertex,
        IsNewCycle, known_vertices, aut_list, HasPolyGrowth,
        cycle_order, next_cycles, cur_cycles, cur_path, cycles_of_level,
        lev, ContainsTrivState, s;

  IsNewCycle := function(C)
    local i, l, cur_cycle, long_cycle;

    l := [2..Length(C)];
    Add(l, 1);
    long_cycle := PermList(l);

    for cur_cycle in cycles do
      if Intersection(cur_cycle, C) <> [] then
#        if Length(C)<>Length(cur_cycle) then return fail; fi;
#        for i in [0..Length(C)-1] do
#          if cur_cycle=Permuted(C, long_cycle^i) then return false; fi;
#        od;
        Info(InfoAutomGrp, 5, "cycle1=", cur_cycle, "cycle2=", C);
        return fail;
      fi;
    od;

    return true;
  end;

#  Example:
#  cycles = [[1, 2, 4], [3, 5, 6], [7]]
#  cur_cycles = [1, 3] (the first and the third cycles)
#  cycle_order = [[2, 3], [3], []] (means 1 -> 2 -> 3,  1 -> 3)

  HasPolyGrowth := function(v)
    local i, v_next, is_new, C, ver;
#    Print("v=", v, "\n");
    Add(cur_path, v);
    for i in [1..d] do
      v_next := aut_list[v][i];
      if not (v_next in known_vertices or v_next = nstates+1) then
        if v_next in cur_path then
          C := cur_path{[Position(cur_path, v_next)..Length(cur_path)]};
          is_new := IsNewCycle(C);
          if is_new = fail then
            return false;
          fi;

          Add(cycles, C);
          Add(cycle_order, []);
          for ver in C do
#              Print("next_cycles = ", next_cycles);
            UniteSet(cycle_order[Length(cycles)], next_cycles[ver]);
            cycle_of_vertex[ver] := Length(cycles);
            next_cycles[ver] := [Length(cycles)];
          od;
        else
          if not HasPolyGrowth(v_next) then
            return false;
          fi;
          if cycle_of_vertex[v] = 0 then
            UniteSet(next_cycles[v], next_cycles[v_next]);
          elif cycle_of_vertex[v] <> cycle_of_vertex[v_next] then
            UniteSet(cycle_order[cycle_of_vertex[v]], next_cycles[v_next]);
            Info(InfoAutomGrp, 5, "v=", v, "; v_next=", v_next);
            Info(InfoAutomGrp, 5, "cycle_order (local) = ", cycle_order);
          fi;
        fi;
      elif v_next in known_vertices then
        if cycle_of_vertex[v]=0 then
          UniteSet(next_cycles[v], next_cycles[v_next]);
        elif cycle_of_vertex[v] = cycle_of_vertex[v_next] then
          return false;
        else
          UniteSet(cycle_order[cycle_of_vertex[v]], next_cycles[v_next]);
        fi;

      fi;
    od;

    Remove(cur_path);
    Add(known_vertices, v);
    return true;
  end;


  aut_list := AG_MinimizationOfAutomatonList(List(AutomatonList(A), x -> List(x)));

# below we put the trivial state to the last position in the aut_list
  ContainsTrivState := false;

  for s in [1..Length(aut_list)] do
    if AG_IsTrivialStateInList(s, aut_list) then
      ContainsTrivState := true;
      if s < Length(aut_list) then
        aut_list := AG_PermuteStatesInList(aut_list, (s, Length(aut_list)));
      fi;
      break;
    fi;
  od;

  if not ContainsTrivState then
    SetIsBounded(A, false);
    return false;
  fi;

  nstates := Length(aut_list) - 1;
  d := A!.degree;
  cycles := [];
  cycle_of_vertex := List([1..nstates], x -> 0);  #if vertex i is in cycle j, then cycle_of_vertex[i]=j
  next_cycles := List([1..nstates], x -> []); #if vertex i is not in a cycle, next_cycles[i] stores the list of cycles, that can be reached immediately (with no cycles in between) from this vertex
  known_vertices := [];
  cur_path := [];
  cycle_order := [];

  while Length(known_vertices) < nstates do
    ver := Difference([1..nstates], known_vertices)[1];
    if not HasPolyGrowth(ver) then
      SetIsBounded(A, false);
      return false;
    fi;
  od;

# Now we find the longest chain in the poset of cycles
  cycles_of_level := [[]];
  for i in [1..Length(cycles)] do
    if cycle_order[i] = [] then
      Add(cycles_of_level[1], i);
    fi;
  od;

  lev := 1;

  while cycles_of_level[Length(cycles_of_level)] <> [] do
    Add(cycles_of_level, []);
    for i in [1..Length(cycles)] do
      if Intersection(cycles_of_level[lev], cycle_order[i]) <> [] then
        Add(cycles_of_level[lev+1], i);
      fi;
    od;
    lev := lev+1;
  od;

  if lev<=2 then
    SetIsBounded(A, true);
  else
    SetIsBounded(A, false);
  fi;
  SetPolynomialDegreeOfGrowth(A, lev-2);
  Info(InfoAutomGrp, 5, "Cycles = ", cycles);
  Info(InfoAutomGrp, 5, "cycle_order = ", cycle_order);
  Info(InfoAutomGrp, 5, "next_cycles = ", next_cycles);
  return true;
end);




InstallMethod(IsBounded, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  IsOfPolynomialGrowth(A);
  return IsBounded(A);
end);


InstallMethod(PolynomialDegreeOfGrowth, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  local res;

  res := IsOfPolynomialGrowth(A);

  if not res then
    Info(InfoAutomGrp, 1, "Error: the automaton <A> has exponential growth");
    return fail;
  fi;

  return PolynomialDegreeOfGrowth(A);
end);


InstallMethod(DualAutomaton, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  local list, dual_list, states, d, n;

  list := AutomatonList(A);
  d := Length(list[1]) - 1;
  n := Length(list);
  dual_list := List([1..d], i -> Concatenation(List([1..n], j -> i^list[j][d+1]),
                                               [Transformation(List([1..n], j -> list[j][i]))]));
  states := List([1..d], i -> Concatenation(AG_Globals.state_symbol_dual, String(i)));

  return MealyAutomaton(dual_list, states);
end);


InstallMethod(InverseAutomaton, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  local list, inv_list, states, n;

  if not IsInvertible(A) then
    Error("MealyAutomaton <A> is not invertible");
  fi;

  list := AutomatonList(A);
  n := Length(list);
  inv_list := AG_InverseAutomatonList(list);
  states := List([1..n], i -> Concatenation(AG_Globals.state_symbol, String(i)));

  return MealyAutomaton(inv_list, states);
end);


InstallMethod(Inverse, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  return InverseAutomaton(A);
end);


###############################################################################
##
#M  \^
##
##  Constructs the power <power> of an automaton, where <power> can be negative as well
##

InstallMethod(\^, "for [IsMealyAutomaton, IsCyclotomic]", [IsMealyAutomaton, IsCyclotomic],
function(A, power)
  if power>0 then
    TryNextMethod();
  elif power=0 then
    return MealyAutomaton([Concatenation(List([1..A!.degree],x->1),[()])]);
  else
    return InverseAutomaton(A)^-power;
  fi;
end);



###############################################################################
##
#M  \/
##
##  Constructs the power <power> of an automaton, where <power> can be negative as well
##

InstallMethod(\/, "for [IsMealyAutomaton, IsMealyAutomaton]", [IsMealyAutomaton, IsMealyAutomaton],
function(A1, A2)
  return A1*A2^-1;
end);




InstallMethod(IsBireversible, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  return IsInvertible(A) and IsInvertible(DualAutomaton(A)) and
         IsInvertible(DualAutomaton(InverseAutomaton(A)));
end);


InstallMethod(IsReversible, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  return IsInvertible(DualAutomaton(A));
end);


InstallMethod(IsIRAutomaton, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  return IsInvertible(A) and IsInvertible(DualAutomaton(A));
end);


InstallMethod(MDReduction, "for [IsMealyAutomaton]",
              [IsMealyAutomaton],
function(A)
  local B, DB, MDB;
  B:=MinimizationOfAutomaton(A);
  DB:=DualAutomaton(B);
  MDB:=MinimizationOfAutomaton(DB);
  while NumberOfStates(MDB)<NumberOfStates(DB) do
    B:=MDB;
    DB:=DualAutomaton(B);
    MDB:=MinimizationOfAutomaton(DB);
  od;
  return [B,MDB];
end);


InstallMethod(IsMDTrivial, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  local MDT;
  MDT:=MDReduction(A);
  if NumberOfStates(MDT[1])=1 then
    return true;
  fi;
  return false;
end);


InstallMethod(IsMDReduced, "for [IsMealyAutomaton]", true,
              [IsMealyAutomaton],
function(A)
  local B, DB, MDB;
  B:=MinimizationOfAutomaton(A);
  if NumberOfStates(B)<NumberOfStates(A) then
    return false;
  else
    DB:=DualAutomaton(B);
    MDB:=MinimizationOfAutomaton(DB);
    if NumberOfStates(MDB)<NumberOfStates(DB) then
      return false;
    fi;
  fi;
  return true;
end);


###############################################################################
##
#M  \*
##
##  Constructs a product of two noninitial automata
##
InstallMethod(\*, "for [IsMealyAutomaton, IsMealyAutomaton]", [IsMealyAutomaton, IsMealyAutomaton],
function(A1, A2)
  local n, m, d, i, j, aut_list, states;

  d := A1!.degree;
  if d <> A2!.degree then
    Error("The cardinalities of alphabets in <A1> and <A2> do not coincide");
  fi;

  n := A1!.n_states;
  m := A2!.n_states;
  aut_list := [];
  for i in [1..n] do
    for j in [1..m] do
#     (i, j)                                < ->     m*(i-1)+j
#     (Int((x-1)/m)+1, ((x-1) mod m) + 1 ) < ->     x
      Add(aut_list, Concatenation(List([1..d], x -> m*(A1!.table[i][x]-1) + A2!.table[j][x^A1!.perms[i]]), [A1!.perms[i]*A2!.perms[j]]));
    od;
  od;
  states := List([1..n*m], i -> Concatenation(AG_Globals.state_symbol, String(i)));
  return MealyAutomaton(aut_list, states);
end);


InstallMethod(IsTrivial, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  # XXX trivial transformation
  return AutomatonList(MinimizationOfAutomaton(A)) = [Concatenation(List([1..A!.degree], x -> 1), [()])];
end);


InstallMethod(DisjointUnion, "for [IsMealyAutomaton, IsMealyAutomaton]", [IsMealyAutomaton, IsMealyAutomaton],
function(A, B)
  local n, m, aut_list, states, perms, tableA, tableB;

  if A!.degree <> B!.degree then
    Error("The cardinalities of alphabets in <A> and <B> do not coincide");
  fi;

  n := A!.n_states;
  m := B!.n_states;
  tableA := List(A!.table, x -> List(x));
  tableB := List(B!.table, x -> List(x));
  Append(tableA, List(tableB, x -> List(x, y -> y+n)));
  perms := Concatenation(A!.perms, B!.perms);

  aut_list := List([1..n+m], i -> Concatenation(tableA[i], [perms[i]]));

  states := List([1..n+m], i -> Concatenation(AG_Globals.state_symbol, String(i)));

  return MealyAutomaton(aut_list, states);
end);


InstallMethod(AreEquivalentAutomata, "for [IsMealyAutomaton, IsMealyAutomaton]", [IsMealyAutomaton, IsMealyAutomaton],
function(A, B)
  local n, m, i, j, aut_list, found, Am, Bm, C, equiv_statesB;

  if A!.degree <> B!.degree then
    return false;
  fi;

  Am := MinimizationOfAutomaton(A);
  Bm := MinimizationOfAutomaton(B);
  n := Am!.n_states;
  m := Bm!.n_states;
  if m <> n then
    return false;
  fi;

  C := DisjointUnion(Am, Bm);
  aut_list := AutomatonList(C);

  equiv_statesB := [];

  for i in [1..n] do
    found := false;
    for j in [n+1..n+m] do
      if (not j in equiv_statesB) and AG_AreEquivalentStatesInList(i, j, aut_list) then
        found := true;
        Add(equiv_statesB, j);
        break;
      fi;
    od;
    if not found then
      return false;
    fi;
  od;

  return true;
end);


InstallMethod(SubautomatonWithStates, "for [IsMealyAutomaton, IsList]", [IsMealyAutomaton, IsList],
function(A, states)
  local G, d, i, g, perm, subautom_list, newsubautom_list;

  G := AutomatonList(A);
  d := A!.degree;

# first we add all states of <states> in the list
  for g in states do
    for i in [1..d] do
      if not (G[g][i] in states) then
        Add(states, G[g][i]);
      fi;
    od;
  od;

  Sort(states);
  subautom_list := G{states};
  newsubautom_list := [];

  for g in subautom_list do
    perm := g[d+1];
    g := List(g{[1..d]}, x -> Position(states, x));
    Add(g, perm);
    Add(newsubautom_list, g);
  od;

  return MealyAutomaton(newsubautom_list, A!.states{states});
end);



InstallMethod(AutomatonNucleus, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  local IsElemInNucleus, G, tmp, d, Nucl, i;

  IsElemInNucleus := function(g)
    local i, res;
    if g in tmp then
      for i in [Position(tmp, g)..Length(tmp)] do
        if not (tmp[i] in Nucl) then Add(Nucl, tmp[i]); fi;
      od;
      return g=tmp[1];
    fi;
    Add(tmp, g);
    res := false; i := 1;
    while (not res) and i<=d do
      res := IsElemInNucleus(G[g][i]);
      i := i+1;
    od;
    Remove(tmp);
    return res;
  end;

  G := AutomatonList(A);
  d := A!.degree;

  Nucl := [];
# first add elements of cycles
  for i in [1..Length(G)] do
    tmp := [];
    if not (i in Nucl) then IsElemInNucleus(i); fi;
  od;

  return SubautomatonWithStates(A, Nucl);
end);


InstallMethod(AdjacencyMatrix, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  local i, s, d, M, aut_list;
  aut_list := AutomatonList(A);
  M:=List([1..A!.n_states],x->List([1..A!.n_states],x->0));
  d := A!.degree;
  for s in [1..A!.n_states] do
    for i in [1..d] do
      M[s][aut_list[s][i]]:=M[s][aut_list[s][i]]+1;
    od;
  od;
  return M;
end);

InstallMethod(IsAcyclic, "for [IsMealyAutomaton]", [IsMealyAutomaton],
function(A)
  local i, j, M, N;
  M:=AdjacencyMatrix(A);
  N:=StructuralCopy(M);
  for i in [1..(A!.n_states-1)] do
    N:=N*M;
    for j in [1..A!.n_states] do
      if N[j][j]<>M[j][j]^(i+1) then return false; fi;
    od;
  od;
  return true;
end);


#E
