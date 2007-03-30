d := 2;
n := 4;
S := SymmetricGroup(n);
W := Tuples([0,1], n);
BD := [];

DualGroup := function(g)
  return GroupOfAutomFamily(DualAutomFamily(UnderlyingAutomFamily(g)));
end;

check_bi_dual := function(p1, p2, w)
  local pp, pp1, pp2;
  pp := function(i, w, p, q)
    if i = 0 then
      return i^p;
    else
      return i^q;
    fi;
  end;
  pp1 := List([1..n], i -> pp(i, w, p1, p2));
  pp2 := List([1..n], i -> pp(i, w, p2, p1));
  return PermList(pp1) <> fail and PermList(pp2) <> fail;
end;

pp2aut := function(pp, w)
  local table, i, j;

  table := [];

  for i in [1..n] do
    Add(table, []);
    for j in [1..d] do
      table[i][j] := i^pp[j];
    od;
    if w[i] = 0 then
      table[i][d+1] := ();
    else
      table[i][d+1] := (1,2);
    fi;
  od;

  return table;
end;

action_no_squares := function(table)
  local i, j, ntab, sno, d, m, s, make_perm;

  m := Length(table);
  d := Length(table[1]) - 1;

  sno := function(i, j)
    return (i-1)*d + j;
  end;

  make_perm := function(perm, bad)
    local i, img;
    img := List([1..d], i -> i^perm);
    bad := bad^perm;
    for i in [1..d] do
      if img[i] = bad then
        Unbind(img[i]);
      elif img[i] > bad then
        img[i] := img[i] - 1;
      fi;
    od;
    return PermListList([1 .. d-1], Compacted(img));
  end;

  ntab := [];

  for i in [1..m] do
    for j in [1..d] do
      s := List([1..d], x -> sno(table[i][x], x));
      Unbind(s[j]);
      ntab[sno(i, j)] := Compacted(s);
      ntab[sno(i, j)][d] := make_perm(table[i][d+1], j);
    od;
  od;

  return ntab;
end;

group_action_no_squares := function(grp)
  local table, ntab, slave, fam, m, d, i, gens, old_gens, sgens;

  table := AutomatonList(grp);
  table := table{[1 .. Length(table)/2]};

  m := Length(table);
  d := Length(table[1]) - 1;

  ntab := action_no_squares(table);
  Print(ntab, "\n");
  slave := AutomGroup(ntab);
  sgens := GeneratorsOfGroup(slave);
  fam := UnderlyingAutomFamily(slave);
  if fam!.trivstate <> 0 then
    sgens[fam!.trivstate] := One(slave);
  fi;
  old_gens := [];
  for i in [1..Length(ntab)] do
    old_gens[i] := sgens[fam!.oldstates[i]];
  od;

  gens := [];
  for i in [1..m] do
    gens[i] := TreeAutomorphism(List([1..d], j -> old_gens[(i-1)*d+j]), table[i][d+1]);
  od;

  return Group(gens);
end;

# for p1 in S do
#   for p2 in S do
#     if p1 <> p2 then
#       for w in W do
#         if check_bi_dual(p1, p2, w) then
#           __a := ReducedAutomatonInList(pp2aut([p1, p2], w));
#           if Length(__a[1]) = n then
#             __g := AutomGroupNoBindGlobal(__a[1]);
#             __d := DualGroup(__g);
# #             Print(__g, "\n", Filtered(GeneratorsOfGroup(__g), x -> not IsOne(x^2)), "\n");
# #             Print(__d, "\n");
#             if IsTransitive(PermGroupOnLevel(__d, 1)) and
#                NrMovedPoints(PermGroupOnLevel(__d, 1)) = n and
#                Filtered(GeneratorsOfGroup(__g), x -> not IsOne(x^2)) = []
#             then
#                Add(BD, __g);
#             fi;
#           fi;
#         fi;
#       od;
#     fi;
#   od;
# od;

# for g in BD do
#   if IsSphericallyTransitive(group_action_no_squares(DualGroup(g))) then
#     Print("******* good: \n", g, "\n");
#   else
#     Print("******* not good: \n", g, "\n");
#     break;
#   fi;
# od;

# a1 = (a2, a3), a2 = (a1, a1)(1,2), a3 = (a3, a2)
