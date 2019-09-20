#############################################################################
##
#W  utils.gi                   automgrp package                Yevgen Muntyan
##                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
##  AG_PermFromTransformation( <tr> )
##
InstallGlobalFunction(AG_PermFromTransformation,
function(tr)
  if IsPerm(tr) then
    return tr;
  elif tr^-1=fail then
    Error(tr, " is not invertible");
  else
    return AsPermutation(tr);
  fi;
end);

#############################################################################
##
##  AG_PrintTransformation( <tr> )
##
InstallGlobalFunction(AG_PrintTransformation,
function(tr)
  local list, i;
  if IsPerm(tr) then
    Print(tr);
  else
    list := ImageListOfTransformation(tr);
    Print("[");
    for i in [1..Length(list)] do
      if i <> 1 then
        Print(",");
      fi;
      Print(list[i]);
    od;
    Print("]");
  fi;
end);


#############################################################################
##
##  AG_TransformationString( <tr> )
##
InstallGlobalFunction(AG_TransformationString,
function(tr)
  local list, i, str;
  if IsPerm(tr) then
    return String(tr);
  else
    list := ImageListOfTransformation(tr);
    str:="[";
    for i in [1..Length(list)] do
      if i <> 1 then
        Append(str, ",");
      fi;
      Append(str, String(list[i]));
    od;
    Append(str, "]");
  fi;
  return str;
end);



InstallGlobalFunction(AG_TrCmp,
function(p1, p2, d)
  local l1, l2, getlist;

  if IsIdenticalObj(p1, p2) then
    return 0;
  fi;

  getlist := function(p)
    local l;
    if IsTransformation(p) then
      return ImageListOfTransformation(p);
    else
      return Permuted([1..d],p);
    fi;
  end;

  l1 := getlist(p1);
  l2 := getlist(p2);

  if l1 = l2 then
    return 0;
  elif l1 < l2 then
    return -1;
  else
    return 1;
  fi;
end);


#############################################################################
##
##  AG_CalculateWord(<word>, <list>)
##
# XXX do not use this
InstallMethod(AG_CalculateWord, [IsAssocWord, IsList],
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
##  AG_CalculateWords(<words_list>, <list>)
##
InstallMethod(AG_CalculateWords, [IsList, IsList],
function(words, domain)
  local result, i;

  result := [];
  for i in [1..Length(words)] do
    result[i] := AG_CalculateWord(words[i], domain);
  od;

  return result;
end);


###############################################################################
##
##  AG_ReducedSphericalIndex(<ind>)
##
InstallGlobalFunction("AG_ReducedSphericalIndex",
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
##  AG_IsEqualSphericalIndex(<ind1>, <ind2>)
##
InstallGlobalFunction("AG_IsEqualSphericalIndex",
function(M1, M2)
  return AG_ReducedSphericalIndex(M1) = AG_ReducedSphericalIndex(M2);
end);


###############################################################################
##
##  AG_TopDegreeInSphericalIndex(<ind>)
##
InstallGlobalFunction("AG_TopDegreeInSphericalIndex",
function(M)
  if not IsEmpty(M.start) then return M.start[1];
  else return M.period[1]; fi;
end);


###############################################################################
##
##  AG_DegreeOfLevelInSphericalIndex(<ind>)
##
InstallGlobalFunction("AG_DegreeOfLevelInSphericalIndex",
function(M, k)
  local i;
  if Length(M.start) >= k then return M.start[k]; fi;
  i := RemInt(k-Length(M.start), Length(M.period));
  if i = 0 then i := Length(M.period); fi;
  return M.period[i];
end);


###############################################################################
##
##  AG_TreeLevelTuples(<ind>)
##  AG_TreeLevelTuples(<ind>, <n>)
##  AG_TreeLevelTuples(<start>, <period>, <n>)
##
InstallGlobalFunction("AG_TreeLevelTuples",
function(arg)
  local n, m, args, ind, start, period;

  if Length(arg) = 1 and IsList(arg[1]) then
    ind := arg[1];
    n := Length(ind);
    args := List([1..n], i -> [1..ind[i]]);
    Add(args, function(arg) return arg; end);
    return CallFuncList(ListX, args);
  elif Length(arg) = 2 and IsRecord(arg[1]) and IsPosInt(arg[2]) then
    return AG_TreeLevelTuples(arg[1].start, arg[1].period, arg[2]);
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
    Error("in AG_TreeLevelTuples\n",
          "  usage: AG_TreeLevelTuples([n_1, n_2, ..., n_k])\n",
          "         AG_TreeLevelTuples(<spher_ind>, k)\n",
          "         AG_TreeLevelTuples(start, period, k)\n");
  fi;
end);


#############################################################################
##
##  AG_AbelImageX
##  AG_AbelImageSpherTrans
##
InstallGlobalFunction(AG_AbelImageX,
function()
  if not IsReadOnlyGlobal("AG_AbelImageXvar") then
    AG_AbelImageXvar := Indeterminate(GF(2),"x");
    MakeReadOnlyGlobal("AG_AbelImageXvar");
  fi;
  return AG_AbelImageXvar;
end);

InstallGlobalFunction(AG_AbelImageSpherTrans,
function()
  return One(AG_AbelImageX())/ (One(AG_AbelImageX()) + AG_AbelImageX());
end);


#############################################################################
##
##  AG_AbelImageAutomatonInList(<list>)
##
InstallGlobalFunction(AG_AbelImageAutomatonInList,
function(list)
  local zero, one, x, m, mk, e, n, d, s, i, k, det, detk, result;

  n := Length(list);
  d := Length(list[1]) - 1;
  x := AG_AbelImageX();
  m := IdentityMat(n, x);
  e := [];
  zero := 0*x;
  one := x^0;

  for s in [1..n] do
    for i in [1..d] do
      #  if the family is defined by wreath recursion
      if IsList(list[s][i]) then
        for k in [1..Length(list[s][i])] do
          m[s][AbsInt(list[s][i][k])] := m[s][AbsInt(list[s][i][k])] + x;
        od;
      #  if the family is defined by automaton
      else
        m[s][list[s][i]] := m[s][list[s][i]] + x;
      fi;
    od;
    if SignPerm(list[s][d+1]) = 1 then e[s] := zero;
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
