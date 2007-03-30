__fa_split_states := function(str)
  local states, s, c, i, parens;

  states := [];
  parens := 0;
  s := "";

  for i in [1..Length(str)] do
    c := str[i];
    if c = '(' then
      parens := parens + 1;
      Add(s, c);
    elif c = ')' then
      if parens = 0 then
        Error("Unmatched parenthesis: ", str{[i..Length(str)]});
      fi;
      parens := parens - 1;
      Add(s, c);
    elif c = ',' and parens = 0 then
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

__fa_split_perms := function(str)
  local s, perms, elms, cl, op;

  s := 0;
  perms := [];

  while s < Length(str) do
    op := Position(str, '(', s);
    if op = fail then
      Error("Invalid state string '", str, "'");
    fi;
    cl := Position(str, ')', op);
    if cl = fail then
      Error("Invalid state string '", str, "'");
    fi;
    elms := SplitString(str{[op+1 .. cl-1]}, ",");
    Perform(elms, NormalizeWhitespace);
    Add(perms, elms);
    s := cl;
  od;

  return perms;
end;

__fa_is_permutation := function(list)
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

__fa_make_states := function(list, str)
  local states, s;

  states := [];
  for s in list do
    if IsEmpty(s) or s = "1" then
      Add(states, 1);
    else
      if (not IsAlphaChar(s[1]) and s[1] <> '_') or
         PositionProperty(s, c -> not IsAlphaChar(c) and not IsDigitChar(c) and c <> '_') <> fail
      then
        Error("Invalid state name '", s, "' in '", str, "'");
      fi;
      Add(states, s);
    fi;
  od;

  return states;
end;

__fa_make_permutation := function(list)
  local indices, s, d;

  indices := [];
  for s in list do
    d := Int(s);
    if d = fail then
      return fail;
    fi;
    Add(indices, d);
  od;

  if Length(indices) < 2 then
    return ();
  else
    return MappingPermListList(indices,
                               Concatenation(indices{[2..Length(indices)]},
                                             [indices[1]]));
  fi;
end;

__fa_parse_state := function(str)
  local id_and_def, id, def,
        states, perm, i, p;

  id_and_def := SplitString(str, "=");
  Perform(id_and_def, NormalizeWhitespace);

  if Length(id_and_def) <> 2 or not IsEmpty(Filtered(id_and_def, IsEmpty)) then
    Error("Invalid state '", str, "'");
  fi;

  id := id_and_def[1];
  def := __fa_split_perms(id_and_def[2]);

  if IsEmpty(def) then
    Error("Invalid state '", str, "'");
  fi;

  states := [];
  perm := ();

  for i in [1..Length(def)] do
    if i = 1 and not __fa_is_permutation(def[i]) then
      states := __fa_make_states(def[i], str);
    else
      p := __fa_make_permutation(def[i]);
      if states = fail then
        Error("Invalid permutation ", def[i], " in '", str, "'");
      fi;
      perm := perm * p;
    fi;
  od;

  return [id, states, perm];
end;

ParseAutomaton := function(str)
  local states, aut_list, aut_states, need_one, alph, i, j, s;

  states := __fa_split_states(str);
  Apply(states, __fa_parse_state);
#   Display(states);

  need_one := false;
  aut_states := [];
  alph := Maximum(List(states, s -> LargestMovedPointPerm(s[3])));

  for s in states do
    if s[1] in aut_states then
      Error("Duplicate state name '", s[1], "' in '", str, "'");
    fi;
    Add(aut_states, s[1]);
    if Position(s[2], 1) <> fail then
      need_one := true;
    fi;
    if Length(s[2]) < alph then
      need_one := true;
    else
      alph := Length(s[2]);
    fi;
  od;

  if need_one then
    Add(aut_states, 1);
  fi;

  aut_list := [];

  for i in [1..Length(states)] do
    Add(aut_list, []);
    for j in [1..Length(states[i][2])] do
      if not states[i][2][j] in aut_states then
        Error("Unknown state name '", states[i][2][j], "' in '", str, "'");
      fi;
      aut_list[i][j] := Position(aut_states, states[i][2][j]);
    od;
    if Length(aut_list[i]) < alph then
      Append(aut_list[i], List([1..(alph - Length(aut_list[i]))],
                               i -> Position(aut_states, 1)));
    fi;
    Add(aut_list[i], states[i][3]);
  od;

  if need_one then
    s := List([1..alph], i -> Length(aut_states));
    Add(s, ());
    Add(aut_list, s);
  fi;

  return [aut_states, aut_list];
end;
