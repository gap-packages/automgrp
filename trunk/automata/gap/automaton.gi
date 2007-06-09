#############################################################################
##
#W  automaton.gi              automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#R  IsAutomatonRep
##
DeclareRepresentation("IsAutomatonRep",
                      IsComponentObjectRep and IsAttributeStoringRep,
                      ["table",     # transitions: table[i][j] is the state automaton goes to after processing letter j
                                    # if it was in state i
                       "perms",     # output: perms[i] is the output function at state i. it is either IsPerm or IsTransformation
                       "trans",     # images of elements of perms: i^perms[j] = trans[j][i]
                       "alphabet",  # by default it's [1..degree]; may be something different e.g. after taking "cross product"
                                    # it's used for pretty printing, internally only [1..degree] is used
                       "degree",    # Length(alphabet)
                       "states",    # names of the states
                       "n_states",  # Length(states), Length(table)
                       ]);
BindGlobal("_AG_AutomatonFamily", NewFamily("AutomatonFamily", IsAutomaton, IsAutomaton, IsAutomatonFamily));


BindGlobal("_AG_IsInvertible",
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
  perms := List(table, s->s[degree+1]);
  table := List(table, s->s{[1..degree]});
  invertible := true;

  for i in [1..n_states] do
    if not IsPerm(perms[i]) and not _AG_IsInvertible(perms[i]) then
      invertible := false;
      break;
    fi;
  od;

  if not invertible then
    for i in [1..n_states] do
      if IsPerm(perms[i]) then
        perms[i] := Transformation(List([1..degree],j->j^perms[i]));
      fi;
    od;
  else
    for i in [1..n_states] do
      if not IsPerm(perms[i]) then
        perms[i] := PermList(ImageListOfTransformation(perms[i]));
      fi;
    od;
  fi;

  a := Objectify(NewType(_AG_AutomatonFamily, IsAutomaton and IsAutomatonRep),
                 rec(table := table,
                     perms := perms,
                     trans := List([1..n_states], i->List([1..degree], j->j^perms[i])),
                     states := states,
                     n_states := n_states,
                     alphabet := alphabet,
                     degree := degree));

  SetIsInvertible(a, invertible);

  return a;
end);


BindGlobal("$AG_PrintPerm",
function(p)
  if IsPerm(p) then
    Print(p);
  else
    Print(ImageListOfTransformation(p));
  fi;
end);


InstallMethod(Automaton, [IsList, IsList, IsList],
function(table, states, alphabet)
  return _AG_CreateAutomaton(table, states, alphabet);
end);

InstallMethod(Automaton, [IsList, IsList],
function(table, states)
  return _AG_CreateAutomaton(table, states, fail);
end);

InstallMethod(Automaton, [IsList],
function(table)
  return _AG_CreateAutomaton(table, fail, fail);
end);

InstallMethod(Automaton, [IsString],
function(string)
  local ret;
  ret := AG_ParseAutomatonString(string);
  return Automaton(ret[2], ret[1]);
end);


InstallMethod(ViewObj, [IsAutomaton],
function(a)
  Print("<automaton>");
end);

InstallMethod(PrintObj, [IsAutomaton and IsAutomatonRep],
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
      $AG_PrintPerm(a!.perms[i]);
    fi;
    if i <> a!.n_states then
      Print(", ");
    fi;
  od;
end);


BindGlobal("_AG_AutomatonTransform",
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


# InstallMethod(TransitionFunction, [IsAutomaton and IsAutomatonRep],
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


InstallMethod(AutomatonList, [IsAutomaton],
function(a)
  return List([1..a!.n_states], i->Concatenation(a!.table[i],[a!.perms[i]]));
end);


InstallMethod(NumberOfStates, [IsAutomaton],
function(A)
  return A!.n_states;
end);


InstallMethod(SizeOfAlphabet, [IsAutomaton],
function(A)
  return A!.degree;
end);


InstallMethod(MINIMIZED_AUTOMATON_LIST, "MINIMIZED_AUTOMATON_LIST(IsAutomaton)", [IsAutomaton],
function(A)
  return AG_AddInversesList(List(AutomatonList(A), x->List(x)));
end);


InstallGlobalFunction(MinimizationOfAutomatonTrack,
function(a)
  local min_aut;
  min_aut := AG_MinimizationOfAutomatonListTrack(List(AutomatonList(a), x->List(x)), [1..a!.n_states], [1..a!.n_states]);
  return [Automaton(min_aut[1], a!.states{min_aut[2]}), min_aut[2], min_aut[3]];
end);


InstallGlobalFunction(MinimizationOfAutomaton,
function(a)
  local min_aut;
  min_aut := AG_MinimizationOfAutomatonListTrack(List(AutomatonList(a), x->List(x)), [1..a!.n_states], [1..a!.n_states]);
  return Automaton(min_aut[1], a!.states{min_aut[2]});
end);


#InstallMethod(IsOfPolynomialGrowth,"IsOfPolynomialGrowth(IsAutomaton)",true,
#              [IsAutomaton],
#function(A)
#  local G, res;
#  G:=AutomGroup(A);
#  res:=IsGeneratedByAutomatonOfPolynomialGrowth(G);
#  if res then
#    SetPolynomialDegreeOfGrowthOfAutomaton(A,PolynomialDegreeOfGrowthOfAutomaton(G));
#  fi;
#  SetIsBounded(A,IsGeneratedByBoundedAutomaton(G));
#  return res;
#end);


InstallMethod(IsOfPolynomialGrowth,"IsOfPolynomialGrowth(IsAutomaton)",true,
              [IsAutomaton],
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
#          if cur_cycle=Permuted(C,long_cycle^i) then return false; fi;
#        od;
        Info(InfoAutomGrp, 5, "cycle1=", cur_cycle, "cycle2=", C);
        return fail;
      fi;
    od;

    return true;
  end;

#  Example:
#  cycles = [[1,2,4],[3,5,6],[7]]
#  cur_cycles = [1,3] (the first and the third cycles)
#  cycle_order = [[2,3],[3],[]] (means 1->2->3,  1->3)

  HasPolyGrowth := function(v)
    local i, v_next, is_new, C, ver;
#    Print("v=",v,"\n");
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
#              Print("next_cycles = ",next_cycles);
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


  aut_list := AG_MinimizationOfAutomatonList(List(AutomatonList(A),x->List(x)));

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
  cycle_of_vertex := List([1..nstates], x->0);  #if vertex i is in cycle j, then cycle_of_vertex[i]=j
  next_cycles := List([1..nstates], x->[]); #if vertex i is not in a cycle, next_cycles[i] stores the list of cycles, that can be reached immediately (with no cycles in between) from this vertex
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
  SetPolynomialDegreeOfGrowthOfAutomaton(A, lev-2);
  Info(InfoAutomGrp, 5, "Cycles = ", cycles);
  Info(InfoAutomGrp, 5, "cycle_order = ", cycle_order);
  Info(InfoAutomGrp, 5, "next_cycles = ", next_cycles);
  return true;
end);




InstallMethod(IsBounded,"IsBounded(IsAutomaton)",true,
              [IsAutomaton],
function(A)
  # XXX ???
  local res;
  res := IsOfPolynomialGrowth(A);
  return IsBounded(A);
end);


InstallMethod(PolynomialDegreeOfGrowthOfAutomaton, "PolynomialDegreeOfGrowthOfAutomaton(IsAutomaton)", true,
              [IsAutomaton],
function(A)
  local res;

  res := IsOfPolynomialGrowth(A);

  if not res then
    Info(InfoAutomGrp, 1, "Error: the automaton <A> has exponential growth");
    return fail;
  fi;

  return PolynomialDegreeOfGrowthOfAutomaton(A);
end);


InstallMethod(DualAutomaton, "DualAutomaton(IsAutomaton)", true,
              [IsAutomaton],
function(A)
  local list, dual_list, states, d, n;

  list := AutomatonList(A);
  d := Length(list[1]) - 1;
  n := Length(list);
  dual_list := List([1..d], i -> Concatenation(List([1..n], j -> i^list[j][d+1]),
                                               [Transformation(List([1..n], j -> list[j][i]))]));
  states := List([1..d], i -> Concatenation(AG_Globals.state_symbol_dual, String(i)));

  return Automaton(dual_list, states);
end);


InstallMethod(InverseAutomaton,"DualAutomaton(IsAutomaton)",true,
              [IsAutomaton],
function(A)
  local list, inv_list, states, n;

  if not IsInvertible(A) then
    Error("Automaton <A> is not invertible");
  fi;

  list := AutomatonList(A);
  n := Length(list);
  inv_list := AG_InverseAutomatonList(list);
  states := List([1..n],i -> Concatenation(AG_Globals.state_symbol, String(i)));

  return Automaton(inv_list,states);
end);


InstallMethod(IsBireversible,"IsBireversible(IsAutomaton)",true,
              [IsAutomaton],
function(A)
  local list, inv_list, states, n;

  return IsInvertible(A) and IsInvertible(DualAutomaton(A)) and
         IsInvertible(DualAutomaton(InverseAutomaton(A)));
end);


###############################################################################
##
#M  \*
##
##  Constructs a product of two noninitial automata
##
InstallMethod(\*, "\*(IsAutomaton, IsAutomaton)", [IsAutomaton, IsAutomaton],
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
#     (i,j)                                <->    m*(i-1)+j
#     (Int((x-1)/m)+1, ((x-1) mod m) + 1 ) <->    x
      Add(aut_list, Concatenation(List([1..d], x->m*(A1!.table[i][x]-1) + A2!.table[j][x^A1!.perms[i]]), [A1!.perms[i]*A2!.perms[j]]));
    od;
  od;
  states := List([1..n*m], i -> Concatenation(AG_Globals.state_symbol, String(i)));
  return Automaton(aut_list, states);
end);


InstallMethod(IsTrivial, "IsTrivial(IsAutomaton)", [IsAutomaton],
function(A)
  # XXX trivial transformation
  return AutomatonList(MinimizationOfAutomaton(A)) = [Concatenation(List([1..A!.degree], x->1), [()])];
end);


InstallMethod(DisjointUnion, "IsTrivial(IsAutomaton,IsAutomaton)", [IsAutomaton,IsAutomaton],
function(A, B)
  local n, m, aut_list, states, perms, tableA, tableB;

  if A!.degree <> B!.degree then
    Error("The cardinalities of alphabets in <A> and <B> do not coincide");
  fi;

  n := A!.n_states;
  m := B!.n_states;
  tableA := List(A!.table, x->List(x));
  tableB := List(B!.table, x->List(x));
  Append(tableA, List(tableB, x->List(x, y -> y+n)));
  perms := Concatenation(A!.perms, B!.perms);

  aut_list := List([1..n+m], i->Concatenation(tableA[i], [perms[i]]));

  states := List([1..n+m], i -> Concatenation(AG_Globals.state_symbol, String(i)));

  return Automaton(aut_list, states);
end);


InstallMethod(IsEquivAutomata, "IsEquivAutomata(IsAutomaton,IsAutomaton)", [IsAutomaton,IsAutomaton],
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


#E
