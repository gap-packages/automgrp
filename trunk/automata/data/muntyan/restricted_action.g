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


dual_list := [[2,6,(1,2)],[1,6,()],[1,2,()],[]]