# restricted_action := function(list, forbidden)
#   local i, g, d, k, s, f, nstates, naut, dom;
#
#   ## check that forbidden is closed under automaton action
#   g := AutomGroup(list);
#   f := [];
#   d := Length(forbidden);
#   if Union(List([1..d], i -> Orbit(g, [i,forbidden[i]]))) <>
#     Union(List([1..d], i -> [[i,forbidden[i]]])) then
#       Print("not closed\n");
#       return fail;
#   fi;
#
#   nstates := ListX([1..Length(list)], [1..d], function(arg) return arg; end);
#   naut := List([1..Length(nstates)], i->[]);
#   for s in nstates do
#     p := List([1..d], i->i^list[s[1]][d+1]);
#     dom := Difference([1..d], forbidden[s[1]]);
#   od;
# end;


dual_list := [[2,6,(1,2)],[1,6,()],[1,2,()],[5,3,()],[4,3,(1,2)],[4,5,(1,2)]];
dd := AutomGroup(dual_list, ["a1","a2","a3","b1","b2","b3"]);
a := TreeAutomorphism([a1, a2, b3], (2,3));
b := TreeAutomorphism([b1, b2, a3], (1,3,2));
d := Group(a,b);
s1 := ProjStab(d, 1);
s2 := ProjStab(s1, 1);
s3 := ProjStab(s2, 1);


normal_to_restricted := function(v)
  local res, i;

  if IsInt(v) or Length(v) = 1 then return v; fi;

  res := [v[1]];
  for i in [2..Length(v)] do
    if v[i] = v[i-1] then Error(); fi;
    if v[i] = Maximum(Difference([1,2,3], [v[i-1]])) then
      res[i] := 2;
    else
      res[i] := 1;
    fi;
  od;
  return res;
end;

restricted_to_normal := function(r)
  local v, i;

  if IsInt(r) or Length(r) = 1 then return r; fi;

  v := [r[1]];
  for i in [2..Length(r)] do
    if r[i] = 1 then
      v[i] := Minimum(Difference([1,2,3], [v[i-1]]));
    else
      v[i] := Maximum(Difference([1,2,3], [v[i-1]]));
    fi;
  od;
  return v;
end;

nodup := function(l)
  local i;
  for i in [1..Length(l)-1] do
    if l[i] = l[i+1] then return false; fi;
  od;
  return true;
end;

manynormalwords := [];
for i in [1..5] do
  Append(manynormalwords, Tuples([1,2,3], i));
od;
manynormalwords := Filtered(manynormalwords, nodup);

manyrwords := [];
for i in [1..5] do
  args := [[1..3]];
  Append(args, List([1..i-1], j->[1,2]));
  Add(args, function(arg)return arg;end);
  Append(manyrwords, CallFuncList(ListX, args));
od;

for v in manyrwords do
  if normal_to_restricted(restricted_to_normal(v)) <> v then
    Error(v);
  fi;
od;
for v in manynormalwords do
  if restricted_to_normal(normal_to_restricted(v)) <> v then
    Error(v);
  fi;
od;


D := AutomGroup([[1,1,2,(2,3)],[2,2,1,(1,3,2)]], ["A", "B"]);
for v in manyrwords do
  if normal_to_restricted(restricted_to_normal(v)^A) <> v^a then
    Error(v);
  fi;
  if normal_to_restricted(restricted_to_normal(v)^B) <> v^b then
    Error(v);
  fi;
od;
for v in manynormalwords do
  if restricted_to_normal(normal_to_restricted(v)^a) <> v^A then
    Error(v);
  fi;
  if restricted_to_normal(normal_to_restricted(v)^b) <> v^B then
    Error(v);
  fi;
od;
