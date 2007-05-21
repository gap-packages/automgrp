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

  if not IsCorrectAutomatonList(table, false) then
    Error("'", table, "' is not a correct table representing a finite automaton");
  fi;

  if states = fail then
    states := List([1..Length(table)], i -> Concatenation(AutomataParameters.state_symbol, String(i)));
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
  ret := ParseAutomatonString(string);
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


InstallGlobalFunction(MinimizationOfAutomatonTrack,
function(a)
  local min_aut;
  min_aut:=AG_MinimizationOfAutomatonListTrack(List(AutomatonList(a),x->List(x)),[1..a!.n_states],[1..a!.n_states]);
  return [Automaton(min_aut[1],a!.states{min_aut[2]}),min_aut[2],min_aut[3]];
end);


InstallGlobalFunction(MinimizationOfAutomaton,
function(a)
  local min_aut;
  min_aut:=AG_MinimizationOfAutomatonListTrack(List(AutomatonList(a),x->List(x)),[1..a!.n_states],[1..a!.n_states]);
  return Automaton(min_aut[1],a!.states{min_aut[2]});
end);


InstallMethod(IsOfPolynomialGrowth,"IsOfPolynomialGrowth(IsAutomaton)",true,
              [IsAutomaton],
function(A)
  local G, res;
  G:=AutomGroup(A);
  res:=IsGeneratedByAutomatonOfPolynomialGrowth(G);
  if res then
    SetPolynomialDegreeOfGrowthOfAutomaton(A,PolynomialDegreeOfGrowthOfAutomaton(G));
  fi;
  SetIsBounded(A,IsGeneratedByBoundedAutomaton(G));
  return res;
end);


InstallMethod(IsBounded,"IsBounded(IsAutomaton)",true,
              [IsAutomaton],
function(A)
  local res;
  res:=IsOfPolynomialGrowth(A);
  return IsBounded(A);
end);


InstallMethod(PolynomialDegreeOfGrowthOfAutomaton,"PolynomialDegreeOfGrowthOfAutomaton(IsAutomaton)",true,
              [IsAutomaton],
function(A)
  local res;
  res:=IsOfPolynomialGrowth(A);
  if not res then
    Info(InfoAutomata,"Error: the automaton <A> has exponenetial growth");
    return fail;
  fi;
  return PolynomialDegreeOfGrowthOfAutomaton(A);
end);


#E
