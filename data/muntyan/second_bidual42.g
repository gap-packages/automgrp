restricted_aut := function(list, forbidden)
  local i, g, d, k, s, f, p, pim, nstates, naut, dom;

  ## check that forbidden is closed under automaton action
  g := AutomGroupNoBindGlobal(list);
  d := Length(forbidden);
  if Union(List([1..d], i -> Orbit(g, [i,forbidden[i]]))) <>
    Union(List([1..d], i -> [[i,forbidden[i]]])) then
      Print("not closed\n");
      return fail;
  fi;

  nstates := ListX([1..Length(list)], [1..d], function(arg) return arg; end);
  naut := List([1..Length(nstates)], i->[]);
  for s in nstates do
    f := Difference([1..d], [forbidden[s[2]]]);
    p := List(f, i->i^list[s[1]][d+1]);
    pim := StructuralCopy(p);
    Sort(pim);
    p := PermListList(pim, p);
    naut[Position(nstates, s)] := List(f, i -> Position(nstates, [list[s[1]][i], i]));
    naut[Position(nstates, s)][d] := p;
  od;

  return naut;
end;


restricted_action := function(list, forbidden, names)
  local l, pairs, nnames, d, i, g, gens, ngens;

  d := Length(list[1]) - 1;
  l := restricted_aut(list, forbidden);
  pairs := ListX([1..Length(list)], [1..d], function(arg) return arg; end);
  nnames := List(pairs, p -> Concatenation(names[p[1]], String(p[2])));
  g := AutomGroup(l, nnames);
  gens := GeneratorsOfGroup(g);
  if Length(gens) < Length(l) then Error(); fi;
  ngens := [];
  for i in [1..Length(list)] do
    ngens[i] := TreeAutomorphism(List([1..d], j ->
      gens[Position(pairs, [list[i][j], j])]), list[i][d+1]);
  od;
  return GroupWithGenerators(ngens);
end;

a := [ [ 1, 2, () ], [ 2, 4, () ], [ 4, 1, () ], [ 3, 3, (1,2) ] ];
list := DualAutomatonList(a);
names := ["A","B"];
forbidden := [1,2,3,4];
d := Length(list[1]) - 1;
l := restricted_aut(list, forbidden);
pairs := ListX([1..Length(list)], [1..d], function(arg) return arg; end);
nnames := List(pairs, p -> Concatenation(names[p[1]], String(p[2])));
g := AutomGroup(l, nnames);
A := TreeAutomorphism([A1, e, A3, A4], (3,4));
B := TreeAutomorphism([B1, B2, B3, B4], (1,2,4,3));
G := Group(A, B);
IsSphericallyTransitive(G);
