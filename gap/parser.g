###############################################################################
##
##  Splits an automaton string into a list of strings each containing a state
##  of the automaton, e.g.
##  "a = (a, 1)(1,2), b=(a,a)" -> ["a = (a, 1)(1,2)", "b=(a,a)"]
##
__AG_split_states := function(str)
  local states, s, c, i, parens;

  states := [];
  parens := [];
  s := "";

  for i in [1..Length(str)] do
    c := str[i];
    if c = '(' or c = '[' then
      if c = '(' then
        Add(parens, ')');
      else
        Add(parens, ']');
      fi;
      Add(s, c);
    elif c = ')' or c = ']' then
      if IsEmpty(parens) or parens[Length(parens)] <> c then
        Error("Unmatched parenthesis: ", str{[i..Length(str)]});
      fi;
      Remove(parens, Length(parens));
      Add(s, c);
    elif (c = ',' or c = ';') and IsEmpty(parens) then
      NormalizeWhitespace(s);
      Add(states, s);
      s := "";
    else
      Add(s, c);
    fi;
  od;

  Add(states, s);

  return states;
end;

###############################################################################
##
##  Splits a state string:
##  "(a,b,c)(1,2)" -> [[[ "a", "b", "c" ], true], [["1", "2"],true]]
##  It actually has no idea about permutations, it just parses the parentheses
##  and brackets. In the elements of the resulting list boolean element
##  indicates whether it were parentheses or brackets.
##  Correctly skips stuff like (a*b)^2 in "((a*b)^2, a, a)".
##
__AG_split_perms := function(str)
  local s, perms, elms, cl, op,
        paren, bracket, isperm;

  s := 0;
  perms := [];

  while s < Length(str) do
    paren := Position(str, '(', s);
    bracket := Position(str, '[', s);

    if paren <> fail and (bracket = fail or bracket > paren) then
      isperm := true;
      op := paren;
      cl := Position(str, ')', op);
    elif bracket <> fail then
      isperm := false;
      op := bracket;
      cl := Position(str, ']', op);
    else
      Error("Invalid state string '", str, "'");
    fi;

    if cl = fail then
      Error("Invalid state string '", str, "'");
    fi;

    elms := SplitString(str{[op+1 .. cl-1]}, ",;");
    Perform(elms, NormalizeWhitespace);

    Add(perms, [elms, isperm]);

    s := cl;
  od;

  return perms;
end;

###############################################################################
##
##  Guesses whether the argument denotes a permutation (or a transformation) or
##  it's a state list:
##  [1,2,3] -> true
##  ["a",1,1] -> false
##
__AG_is_permutation := function(list)
  local s, d, one;
  one := true;
  for s in list do
    d := Int(s);
    if d = fail or d < 0 then
      return false;
    elif d > 1 then
      one := false;
    fi;
  od;
  return not one;
end;

###############################################################################
##
##  Parses a word:
##  "a", [] -> [1], ["a"]
##  "a*b", [] -> [1, 2], ["a", "b"]
##  "a*b^-1", [] -> [1, -2], ["a", "b"]
##  "(a*b)^-1", [] -> [-2, -1], ["a", "b"]
##
__AG_parse_word := function(word, names)
  local parsed_word, paren, paren_start, s, len, i,
        tok, power, in_power, finish_token;

  parsed_word := [];
  paren := 0;
  paren_start := -1;
  len := Length(word);
  tok := fail;
  power := fail;
  in_power := false;

  finish_token := function()
    local j;
    if in_power and power = fail then
      Error("trailing power sign: ", word);
    fi;
    if power = fail then
      power := 1;
    elif IsString(power) then
      power := Int(power);
      if power = fail then
        Error("invalid power: ", word);
      fi;
    fi;
    if IsString(tok) then
      if not tok in names then
        Add(names, tok);
        tok := [Length(names)];
      else
        tok := [Position(names, tok)];
      fi;
    elif not IsList(tok) then
      Error("oops");
    fi;
    if power < 0 then
      power := -power;
      tok := List(Reversed(tok), elm -> -elm);
    fi;
    for j in [1..power] do
      Append(parsed_word, tok);
    od;
    tok := fail;
    power := fail;
    in_power := false;
  end;

  for i in [1..len] do
    s := word[i];

    if s = '(' then
      paren := paren + 1;
      if paren = 1 then
        paren_start := i;
      fi;

    elif s = ')' then
      paren := paren - 1;
      if paren = -1 then
        Error("invalid word: ", word);
      fi;
      if paren = 0 then
        if not in_power then
          tok := __AG_parse_word(word{[paren_start+1..i-1]}, names);
        else
          Error("invalid word, parentheses inside the power: ", word);
        fi;
        paren_start := -1;
      fi;

    # skip what's inside parentheses
    elif paren <> 0 then
      continue;

    elif s = '*' then
      finish_token();

    elif s = '^' then
      if in_power then
        Error("invalid word, power is not associative: ", word);
      elif tok = fail then
        Error("power without operand: ", word);
      fi;
      in_power := true;

    elif not in_power then
      if tok = fail then
        tok := word{[i..i]};
      elif IsString(tok) then
        Add(tok, s);
      else
        Error("invalid word, missing multiplication sign: ", word);
      fi;
    else
      if power = fail then
        power := word{[i..i]};
      elif IsString(power) then
        Add(power, s);
      else
        Error("invalid word, missing multiplication sign: ", word);
      fi;
    fi;
  od;

  if tok <> fail then
    finish_token();
  fi;

  return parsed_word;
end;

###############################################################################
##
##  ["a", "b", "c"] -> [[[1], [2], [3]], ["a", "b", "c"]]
##  ["a", "1", "1"] -> [[[1], [], []], ["a"]]
##
__AG_make_states := function(list, names, str)
  local states, s;

  states := [];

  for s in list do
    if s = "1" then
      Add(states, []);
    else
      Add(states, __AG_parse_word(s, names));
    fi;
  od;

  return states;
end;

###############################################################################
##
##  Tries to make sense of the permutation in an automaton string:
##  [[1,2,3],true] -> (1,2,3)
##  [[1,2,3],false] -> [1,2,3]
##  [[1,2,2],true] -> fail
##  [[1,2,"nonsense"],true] -> fail
##
__AG_make_permutation := function(list)
  local indices, s, d;

  indices := [];
  for s in list[1] do
    d := Int(s);
    if d = fail then
      return fail;
    fi;
    Add(indices, d);
  od;

  if Length(indices) < 2 then
    return ();
  elif list[2] then
    return MappingPermListList(indices,
                               Concatenation(indices{[2..Length(indices)]},
                                             [indices[1]]));
  else
    return Transformation(indices);
  fi;
end;

###############################################################################
##
##  Parses a single state string, e.g. "a = (b, c, d)"
##  Returns list [id, states, perm], where
##  id is the name of the given state,
##  states is a list of states as associative words in list representation,
##  perm is the permutation.
##  Modifies names in place.
##  E.g. "a = (1, a)", [] -> ["a", [[], [1]], ()], ["a"]
##
__AG_parse_state := function(str, names)
  local id_and_def, id, def,
        states, perm, i, p;

  id_and_def := SplitString(str, "=");
  Perform(id_and_def, NormalizeWhitespace);

  if Length(id_and_def) <> 2 or not IsEmpty(Filtered(id_and_def, IsEmpty)) then
    Error("Invalid state '", str, "'");
  fi;

  id := id_and_def[1];
  def := __AG_split_perms(id_and_def[2]);

  if IsEmpty(def) then
    Error("Invalid state '", str, "'");
  fi;

  states := [];
  perm := ();

  for i in [1..Length(def)] do
    if i = 1 and def[i][2] and not __AG_is_permutation(def[i][1]) then
      states := __AG_make_states(def[i][1], names, str);
    else
      p := __AG_make_permutation(def[i]);
      if p = fail then
        Error("Invalid permutation ", def[i], " in '", str, "'");
      fi;
      perm := perm * p;
    fi;
  od;

  return [id, states, perm];
end;

###############################################################################
##
##  AG_ParseAutomatonStringFR(<str>)
##
##  Same as AG_ParseAutomatonString, except it does functionally recursive
##  automata.
##  Returns a list [names, table] where names is a list of automata states names,
##  and table is the table representing an FR automaton, as in ???
##
InstallGlobalFunction(AG_ParseAutomatonStringFR,
function(str)
  local aut_list, aut_states, alph, i, j, k, s,
        largest_moved_point, word, letter, names, states;

  largest_moved_point := function(p)
    if IsPerm(p) then
      return LargestMovedPointPerm(p);
    else
      return DegreeOfTransformation(p);
    fi;
  end;

  names := [];
  states := __AG_split_states(str);
  states := List(states, s -> __AG_parse_state(s, names));

  alph := Maximum(List(states, s -> largest_moved_point(s[3])));
  aut_states := [];

  for s in states do
    if s[1] in aut_states then
      Error("Duplicate state name '", s[1], "' in '", str, "'");
    fi;
    Add(aut_states, s[1]);
    if Length(s[2]) > alph then
      alph := Length(s[2]);
    fi;
  od;

  for s in states do
    if IsEmpty(s[2]) then
      s[2] := List([1..alph], i -> []);
    elif Length(s[2]) <> alph then
      Error("not enough states in '", s[1], "': '", str, "'");
    fi;
  od;

  aut_list := [];

  for i in [1..Length(states)] do
    s := states[i];

    for j in [1..alph] do
      word := s[2][j];
      for k in [1..Length(word)] do
        letter := AbsInt(word[k]);
        if not names[letter] in aut_states then
          Error("invalid state '", names[letter], "'");
        fi;
        if word[k] > 0 then
          word[k] := Position(aut_states, names[letter]);
        else
          word[k] := -Position(aut_states, names[letter]);
        fi;
      od;
    od;

    Add(aut_list, Concatenation(s[2], [s[3]]));
  od;

  return [aut_states, aut_list];
end);

###############################################################################
##
##  AG_ParseAutomatonString(<str>)
##
##  Parses strings of type "a = (a,a,1)(2,3), b = (a^2, b^-1, b)"
##
InstallGlobalFunction(AG_ParseAutomatonString,
function(str)
  local result, table, names, need_one, s, i, alph;

  result := AG_ParseAutomatonStringFR(str);
  names := result[1];
  table := result[2];
  alph := Length(table[1]) - 1;
  need_one := false;

  for s in table do
    for i in [1..alph] do
      if Length(s[i]) = 0 then
        need_one := true;
        s[i] := Length(table) + 1;
      elif Length(s[i]) = 1 then
        if s[i][1] < 0 then
          Error("functionally recursive automaton: ", str);
        fi;
        s[i] := s[i][1];
      else
        Error("functionally recursive automaton: ", str);
      fi;
    od;
  od;

  if need_one then
    Add(names, 1);
    Add(table, List([1..alph], i -> Length(table)+1));
    table[Length(table)][alph+1] := ();
  fi;

  return [names, table];
end);

# AG_Printf := function(arg)
#   local format, arg_ind, i, len, c, s;
#
#   format := arg[1];
#   arg_ind := 2;
#   i := 1;
#   len := Length(format);
#   s := "";
#
#   while i <= len do
#     c := format[i];
#     if c = '%' then
#       if i = len then
#         Error("trailing % in format string '", format, "'");
#       fi;
#       if format[i+1] = '%' then
#         Add(s, '%');
#       elif format[i+1] = 's' then
#         Print(s, arg[arg_ind]);
#         arg_ind := arg_ind + 1;
#         s := "";
#       else
#         Error("unknown format sequence %", format[i+1], " in format string '", format, "'");
#       fi;
#       i := i + 2;
#     else
#       Add(s, c);
#       i := i + 1;
#     fi;
#   od;
#
#   if s <> "" then
#     Print(s);
#   fi;
# end;
