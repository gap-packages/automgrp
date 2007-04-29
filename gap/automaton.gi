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
                      ["table", "alphabet", "states", "n_states", "degree"]);
BindGlobal("AutomatonFamily", NewFamily("AutomatonFamily", IsAutomaton, IsAutomaton, IsAutomatonFamily));


BindGlobal("$AG_CreateAutomaton",
function(table, states, alphabet)
  local a, s;

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

  a := Objectify(NewType(AutomatonFamily, IsAutomaton and IsAutomatonRep),
                 rec(table := StructuralCopy(table),
                     states := states,
                     n_states := Length(states),
                     alphabet := alphabet,
                     degree := Length(alphabet)));

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
  return $AG_CreateAutomaton(table, states, alphabet);
end);

InstallMethod(Automaton, [IsList, IsList],
function(table, states)
  return $AG_CreateAutomaton(table, states, fail);
end);

InstallMethod(Automaton, [IsList],
function(table)
  return $AG_CreateAutomaton(table, fail, fail);
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
    if not IsOne(a!.table[i][a!.degree+1]) then
      $AG_PrintPerm(a!.table[i][a!.degree+1]);
    fi;
    if i <> a!.n_states then
      Print(", ");
    fi;
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


#E
