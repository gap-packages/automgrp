reset_finite_group := function(G)
  local aut, GS, i;
  aut := [];
  GS := AsList(G);
  for i in [1..Length(GS)] do
    aut[i] := [1..Length(GS)];
    aut[i][Length(GS)+1] := PermListList(GS, List(GS, g -> g*GS[i]));
  od;
  return AutomGroup(aut);
end;

