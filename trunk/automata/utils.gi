#############################################################################
##
#W  utils.gi                   automata package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##

Revision.utils_gi :=
  "@(#)$Id$";


#############################################################################
##
#M  CalculateWord(<word>, <list>)
##
InstallMethod(CalculateWord, [IsAssocWord, IsList],
function(w, dom)
    local result, i;

    result := One(dom[1]);

    for i in [1..NumberSyllables(w)] do
        result := result *
                    dom[GeneratorSyllable(w, i)]^ExponentSyllable(w, i);
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
    Error("in TreeLevelTuples\n  usage: TreeLevelTuples([n_1, n_2, ..., n_k])\n         TreeLevelTuples(<spher_ind>, k)\n         TreeLevelTuples(start, period, k)\n");
  fi;
end);


#E