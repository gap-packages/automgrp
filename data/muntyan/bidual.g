find_all_bidual := function(d, m)
  local perms, state_perms, all, list, i;

  all := [];

  for perms in Tuples(SymmetricGroup(d), m) do
  for state_perms in Tuples(SymmetricGroup(m), d) do
    list := [];
    for i in [1..m] do
      list[i] := List([1..d], j -> i^state_perms[j]);
      Add(list[i], perms[i]);
    od;
    if HasDualOfInverseInList(list) then
      Add(all, list);
    fi;
  od;
  od;

  return all;
end;


find_non_triv_bidual := function(d, m)
  local all, all_ntr, l;

  all := find_all_bidual(d, m);
  all_ntr := [];

  for l in all do
    if Length(ReducedAutomatonInList(l)[1]) = Length(l) then Add(all_ntr, l); fi;
  od;

  return all_ntr;
end;


find_diff_bidual := function(d, m)
  local all, all_diff, symmetries, i, s, orbs, p;

  all := find_all_bidual(d, m);
  all_diff := [];
  symmetries := [];

  for i in [2..m] do
    p := (1, i);
    s := function(l)
      local r, j, k;
      r := List([1..m], k->[]);;
      for j in [1..m] do
        r[j][d+1] := l[j^p][d+1];
        for k in [1..d] do
          r[j][k] := (l[j^p][k])^p;
        od;
      od;
      return r;
    end;
    s := List(all, s);
    s := PermListList(all, s);
    Add(symmetries, s);
  od;

  for i in [2..d] do
    p := (1, i);
    s := function(l)
      local j, k, r;
      r := [];
      for j in [1..m] do
        r[j] := [];
        for k in [1..d] do
          r[j][k] := l[j][k^p];
        od;
        r[j][d+1] := l[j][d+1]^p;
      od;
      return r;
    end;
    s := List(all, s);
    s := PermListList(all, s);
    Add(symmetries, s);
  od;

  s := l -> AG_InverseAutomatonList(l);
  s := List(all, s);
  s := PermListList(all, s);
  Add(symmetries, s);

  s := GroupWithGenerators(symmetries);
  orbs := OrbitsPerms(s, [1..Size(all)]);;
  return List(orbs, o -> all[Minimum(o)]);;
end;


find_all_diff_nontriv_bidual := function(d, m)
  local all;
  all := find_diff_bidual(d, m);
  all := Filtered(all, l -> Length(ReducedAutomatonInList(l)[1]) = Length(l));
  return all;
end;
