aut := [[2,2,1,2,2,1,(2,3)(4,5,6)],[1,1,2,1,1,2,(1,3,2)(5,6)]];

new_states := ListX([1,2], [1..6], function(x,y) return [x,y]; end);
new_aut := List(new_states, i -> []);
for s in new_states do
  # Position(new_states, s);
  p := [];
  for i in [1..6] do
    if i = s[2] then continue; fi;
    ns := [];
    ns[1] := aut[s[1]][i];
    ns[2] := i;
    new_aut[Position(new_states, s)][i] := Position(new_states, ns);
    p[i] := i^aut[s[1]][7];
  od;
  new_aut[Position(new_states, s)] := Filtered(new_aut[Position(new_states, s)], ReturnTrue);
  p := Filtered(p, ReturnTrue);
#   p := List(p, function(i) if i > s[2] then return i-1; else return i; fi; end);
  p := PermListList(AsSet(p), p);
  Print(p, "\n");
  Add(new_aut[Position(new_states, s)], p);
od;

Print(new_aut, "\n");

names := List(new_states,
function(s)
  if s[1] = 1 then
    return Concatenation("a", String(s[2]));
  else
    return Concatenation("b", String(s[2]));
  fi;
end);

dual := AutomGroup(new_aut, names);
dual_big := WreathProduct(dual, Group((1,2),(2,3),(4,5),(5,6)));
a := [b1, b2, a3, b4, b5, a6, (2,3)(4,5,6)];
b := [a1, a2, b3, a4, a5, b6, (1,3,2)(5,6)];

S := Group((2,3)(4,5,6), (1,3,2)(5,6));
F := FreeGroup("a", "b");
hom := GroupHomomorphismByImagesNC(F, S, [F.1, F.2], [(2,3)(4,5,6), (1,3,2)(5,6)]);
action := function(k, w)
    return k^Image(hom, w);
end;
stab_gens := GeneratorsOfGroup(Stabilizer(F, 1, action));
stab_gens := Difference(stab_gens, [One(stab_gens[1])]);
gens := List(stab_gens,
  w -> MappedWord(w, [F.1, F.2], [a, b]));
