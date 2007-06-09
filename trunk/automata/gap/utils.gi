#############################################################################
##
#W  utils.gi                   automgrp package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#F  AG_IsInvertibleTransformation( <tr> )
##
InstallGlobalFunction(AG_IsInvertibleTransformation,
function(tr)
  local img;
  if IsPerm(tr) then
    return true;
  else
    img := ImageListOfTransformation(tr);
    return SortedList(img) = AsSet(img);
  fi;
end);

#############################################################################
##
#F  AG_PermFromTransformation( <tr> )
##
InstallGlobalFunction(AG_PermFromTransformation,
function(tr)
  if not IsPerm(tr) then
    return PermList(ImageListOfTransformation(tr));
  else
    return tr;
  fi;
end);

#############################################################################
##
#F  AG_PrintTransformation( <tr> )
##
InstallGlobalFunction(AG_PrintTransformation,
function(tr)
  local list, i;
  if IsPerm(tr) then
    Print(tr);
  else
    list := ImageListOfTransformation(tr);
    Print("[");
    for i in list do
      if i <> 0 then
        Print(",");
      fi;
      Print(i);
    od;
    Print("]");
  fi;
end);


#############################################################################
##
#M  CalculateWord(<word>, <list>)
##
# XXX do not use this
InstallMethod(CalculateWord, [IsAssocWord, IsList],
function(w, dom)
  local result, i;

  result := One(dom[1]);

  for i in [1..NumberSyllables(w)] do
    result := result * dom[GeneratorSyllable(w, i)]^ExponentSyllable(w, i);
  od;

  return result;
end);


#############################################################################
##
#M  CalculateWords(<words_list>, <list>)
##
InstallMethod(CalculateWords, [IsList, IsList],
function(words, domain)
  local result, i;

  result := [];
  for i in [1..Length(words)] do
    result[i] := CalculateWord(words[i], domain);
  od;

  return result;
end);


###############################################################################
##
#F  ReducedSphericalIndex(<ind>)
##
InstallGlobalFunction("ReducedSphericalIndex",
function(M)
  local beg, per, beg_len, per_len, i;
  if IsEmpty(M.period) then return StructuralCopy(M); fi;
  beg := StructuralCopy(M.start);
  per := StructuralCopy(M.period);
  beg_len := Length(beg);
  per_len := Length(per);
  for i in Difference(DivisorsInt(per_len), [per_len]) do
    if per = Concatenation(List([1..per_len/i], j -> per{[1..i]})) then
      per := per{[1..i]};
      per_len := i;
      break;
    fi;
  od;
  while Length(beg) <> 0 and beg[beg_len] = per[per_len] do
    per := Concatenation([per[per_len]], per{[1..per_len-1]});
    beg := beg{[1..beg_len-1]};
    beg_len := beg_len - 1;
  od;
  return rec(start := beg, period := per);
end);


###############################################################################
##
#F  IsEqualSphericalIndex(<ind1>, <ind2>)
##
InstallGlobalFunction("IsEqualSphericalIndex",
function(M1, M2)
  return ReducedSphericalIndex(M1) = ReducedSphericalIndex(M2);
end);


###############################################################################
##
#F  TopDegreeInSphericalIndex(<ind>)
##
InstallGlobalFunction("TopDegreeInSphericalIndex",
function(M)
  if not IsEmpty(M.start) then return M.start[1];
  else return M.period[1]; fi;
end);


###############################################################################
##
#F  DegreeOfLevelInSphericalIndex(<ind>)
##
InstallGlobalFunction("DegreeOfLevelInSphericalIndex",
function(M, k)
  local i;
  if Length(M.start) >= k then return M.start[k]; fi;
  i := RemInt(k-Length(M.start), Length(M.period));
  if i = 0 then i := Length(M.period); fi;
  return M.period[i];
end);


###############################################################################
##
#F  TreeLevelTuples(<ind>)
#F  TreeLevelTuples(<ind>, <n>)
#F  TreeLevelTuples(<start>, <period>, <n>)
##
InstallGlobalFunction("TreeLevelTuples",
function(arg)
  local n, m, args, ind, start, period;

  if Length(arg) = 1 and IsList(arg[1]) then
    ind := arg[1];
    n := Length(ind);
    args := List([1..n], i -> [1..ind[i]]);
    Add(args, function(arg) return arg; end);
    return CallFuncList(ListX, args);
  elif Length(arg) = 2 and IsRecord(arg[1]) and IsPosInt(arg[2]) then
    return TreeLevelTuples(arg[1].start, arg[1].period, arg[2]);
  elif Length(arg) = 3 and IsList(arg[1]) and IsList(arg[2]) and IsPosInt(arg[3]) then
    start := arg[1];
    period := arg[2];
    n := arg[3];
    m := n;
    ind := [];
    if Length(start) <> 0 then
      if n <= Length(start) then
        ind := start{[1..n]};
        m := 0;
      else
        ind := start;
        m := n - Length(start);
      fi;
    fi;
    if m > 0 then
      # TODO: why Append doesn't work???
#       Append(ind, Concatenation(List([1..Int(m/Length(period))], i -> period)));
#       Append(ind, period{[1..m-Int(m/Length(period))]});
      ind := Concatenation(ind,
        Concatenation(List([1..Int(m/Length(period))], i -> period)));
      ind := Concatenation(ind, period{[1..m-Int(m/Length(period))]});
    fi;
    args := List([1..n], i -> [1..ind[i]]);
    Add(args, function(arg) return arg; end);
    return CallFuncList(ListX, args);
  else
    Error("in TreeLevelTuples\n",
          "  usage: TreeLevelTuples([n_1, n_2, ..., n_k])\n",
          "         TreeLevelTuples(<spher_ind>, k)\n",
          "         TreeLevelTuples(start, period, k)\n");
  fi;
end);


###############################################################################
##
#F  ParseAutomatonString(<str>)
##
$FA_split_states := function(str)
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

$FA_split_perms := function(str)
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

$FA_is_permutation := function(list)
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

$FA_make_states := function(list, str)
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

$FA_make_permutation := function(list)
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

$FA_parse_state := function(str)
  local id_and_def, id, def,
        states, perm, i, p;

  id_and_def := SplitString(str, "=");
  Perform(id_and_def, NormalizeWhitespace);

  if Length(id_and_def) <> 2 or not IsEmpty(Filtered(id_and_def, IsEmpty)) then
    Error("Invalid state '", str, "'");
  fi;

  id := id_and_def[1];
  def := $FA_split_perms(id_and_def[2]);

  if IsEmpty(def) then
    Error("Invalid state '", str, "'");
  fi;

  states := [];
  perm := ();

  for i in [1..Length(def)] do
    if i = 1 and not $FA_is_permutation(def[i]) then
      states := $FA_make_states(def[i], str);
    else
      p := $FA_make_permutation(def[i]);
      if states = fail then
        Error("Invalid permutation ", def[i], " in '", str, "'");
      fi;
      perm := perm * p;
    fi;
  od;

  return [id, states, perm];
end;

InstallGlobalFunction("ParseAutomatonString",
function(str)
  local states, aut_list, aut_states, need_one, alph, i, j, s;

  states := $FA_split_states(str);
  Apply(states, $FA_parse_state);
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
end);


#############################################################################
##
##  AbelImageAutomatonInList(<list>)
##
InstallGlobalFunction(AbelImageAutomatonInList,
function(list)
  local zero, one, x, m, mk, e, n, d, s, i, det, detk, result;

  n := Length(list);
  d := Length(list[1]) - 1;
  x := $AutomataAbelImageIndeterminate;
  m := IdentityMat(n, x);
  e := [];
  zero := 0*x;
  one := x^0;

  for s in [1..n] do
    for i in [1..d] do
      m[s][list[s][i]] := m[s][list[s][i]] + x;
    od;
    if (list[s][d+1] = ()) then e[s] := zero;
    else e[s] := one; fi;
  od;

  result := [];
  det := Determinant(m);
  for s in [1..n] do
    mk := StructuralCopy(m);
    for i in [1..n] do
      mk[i][s] := e[i];
    od;
    detk := Determinant(mk);
    result[s] := detk / det;
  od;

  return result;
end);


#E
