#############################################################################
##
#W  listops.gd             automata package                    Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.listops_gd := 
  "@(#)$Id$";


###############################################################################
##
#F  IsCorrectListCompOfAutomaton( list )
##
##  checks if given list can be list component of automaton structure
##  returns list with two components: first component is true/false,
##  second one is error message
##
InstallGlobalFunction(IsCorrectListComponentOfAutomaton,
function(list)
        local len, deg, i, j;

        if not IsDenseList(list) then
                return [false, "argument is not dense list"];
        fi;
        len := Length(list);
        if len = 0 then
                return [false, "empty list"];
        fi;
        for i in [1..len] do
                if not IsList(list[i]) then
                        return [false, Concatenation(String(i), "th element of given list is not list")];
                fi;
                if Length(list[i]) <> Length(list[1]) then
                        return [false, Concatenation(String(i), "th element of given list is not of the same length as the first one")];
                fi;
        od;
        if Length(list[1]) < 3 then
                return [false, "alphabet is of less than two letters"];
        fi;
        deg := Length(list[1]) - 1;
        for i in [1..len] do
                if not IsDenseList(list) then
                        return [false, Concatenation("list\[", String(i), "\] is not dense list")];
                fi;
                for j in [1..deg] do
                        if not list[i][j] in Integers then
                                return [false, Concatenation("list\[", String(i), "\]\[", String(j), "\] is not integer")];
                        fi;
                        if list[i][j] > len or list[i][j] < 1 then
                                return [false, Concatenation("list\[", String(i), "\]\[", String(j), "\] is not integer between 1 and ", String(len))];
                        fi;
                od;
                if not list[i][deg + 1] in SymmetricGroup(deg) then
                        return [false, Concatenation("list\[", String(i), "\]\[", String(deg+1), "\] is not permutation of \{1, .., ", String(deg), "\}")];
                fi;
        od;

        return [true, "OK"];
end);


###############################################################################
##
#F  ConnectedStatesInList(state, list)
##
##  Returns list of states which are reachable from given state,
##  it does not check correctness of arguments
##
InstallGlobalFunction(ConnectedStatesInList,
function(state, list)
    local i, s, d, to_check, checked;

    d := Length(list[1]) - 1;

    to_check := [state];
    checked := [];

    while Length(to_check) <> 0 do
        for s in to_check do
            for i in [1..d] do
                if (not list[s][i] in checked) and (not list[s][i] in to_check)
                then
                    to_check := Union(to_check, [list[s][i]]);
                fi;
            od;
            checked := Union(checked, [s]);
            to_check := Difference(to_check, [s]);
        od;
    od;

    return checked;
end);


###############################################################################
##
#F  IsTrivialStateInList(state, list)
##
##  it does not check correctness of arguments
##
InstallGlobalFunction(IsTrivialStateInList,
function(state, list)
    local i, s, d, to_check, checked;

    d := Length(list[1]) - 1;

    to_check := [state];
    checked := [];

    while Length(to_check) <> 0 do
        for s in to_check do
            for i in [1..d] do
                if list[s][d+1] <> () then
                    return false;
                fi;
                if (not list[s][i] in checked) and (not list[s][i] in to_check)
                then
                    to_check := Union(to_check, [list[s][i]]);
                fi;
            od;
            checked := Union(checked, [s]);
            to_check := Difference(to_check, [s]);
        od;
    od;

    return true;
end);


###############################################################################
##
#F  AreEquivalentStatesInList(state1, state2, list)
##
##  it does not check correctness of arguments
##
InstallGlobalFunction(AreEquivalentStatesInList,
function(state1, state2, list)
    local d, checked_pairs, pos, s1, s2, np, i;

    d := Length(list[1]) - 1;
    checked_pairs := [[state1, state2]];
    pos := 0;

    while Length(checked_pairs) <> pos do
        pos := pos + 1;
        s1 := checked_pairs[pos][1];
        s2 := checked_pairs[pos][2];

        if list[s1][d+1] <> list[s2][d+1] then
            return false;
        fi;

        for i in [1..d] do
            np := [list[s1][i], list[s2][i]];
            if not np in checked_pairs then
                checked_pairs := Concatenation(checked_pairs, [np]);
            fi;
        od;
    od;

    return true;
end);


###############################################################################
##
#F  AreEquivalentStatesInLists(state1, state2, list1, list2)
##
##  it does not check correctness of arguments
##
InstallGlobalFunction(AreEquivalentStatesInLists,
function(state1, state2, list1, list2)
    local d, checked_pairs, pos, s1, s2, np, i;

    d := Length(list1[1]) - 1;
    checked_pairs := [[state1, state2]];
    pos := 0;

    while Length(checked_pairs) <> pos do
        pos := pos + 1;
        s1 := checked_pairs[pos][1];
        s2 := checked_pairs[pos][2];

        if list1[s1][d+1] <> list2[s2][d+1] then
            return false;
        fi;

        for i in [1..d] do
            np := [list1[s1][i], list2[s2][i]];
            if not np in checked_pairs then
                checked_pairs := Concatenation(checked_pairs, [np]);
            fi;
        od;
    od;

    return true;
end);


###############################################################################
##
#F  ReducedAutomatonInList(list)
##
##  returns new list which is list representation of reduced form of automaton
##  given by list
##  first state of returned list is always first state if given one
##  this function does not remove trivial state - it's for initial automata
##
##  It does not check correctness of list
##
InstallGlobalFunction(ReducedAutomatonInList,
function(list)
    local  i, n, triv_states, equiv_classes, checked_states, s, s1, s2,
            eq_cl, eq_cl_1, eq_cl_2, are_equiv, eq_cl_reprs,
            new_states, new_list, deg,
            reduced_automaton, state, states_reprs;

    n := Length(list);
    triv_states := [];
    equiv_classes := [];
    checked_states := [];
    deg := Length(list[1]) - 1;

    for s in [1..n] do
        if IsTrivialStateInList(s, list) then
            triv_states := Union(triv_states, [s]);
        fi;
    od;

    equiv_classes:=[triv_states];
    for s1 in Difference([1..n], triv_states) do
    for s2 in Difference([s1+1..n], triv_states) do
        are_equiv := AreEquivalentStatesInList(s1, s2, list);

        if s1 in checked_states then
            for eq_cl in equiv_classes do
                if s1 in eq_cl then
                    eq_cl_1 := StructuralCopy(eq_cl);
                    break; fi; od;
        else
            equiv_classes := Union(equiv_classes, [[s1]]);
            eq_cl_1 := [s1];
            checked_states := Union(checked_states, [s1]);
        fi;
        if s2 in checked_states then
            for eq_cl in equiv_classes do
                if s2 in eq_cl then
                    eq_cl_2 := StructuralCopy(eq_cl);
                    break; fi; od;
        else
            equiv_classes := Union(equiv_classes, [[s2]]);
            eq_cl_2 := [s2];
            checked_states := Union(checked_states, [s2]);
        fi;

        if are_equiv then
            equiv_classes := Difference(equiv_classes, [eq_cl_1, eq_cl_2]);
            equiv_classes := Union(equiv_classes, [Union(eq_cl_1, eq_cl_2)]);
        fi;
    od;
    od;
    states_reprs := [1..n];
    for eq_cl in equiv_classes do
        for s in eq_cl do
            states_reprs[s] := Minimum(eq_cl);
        od;
    od;


    new_states := Set(states_reprs);
    new_list := [];

    for s in new_states do
        state := [];
        state[deg+1] := list[s][deg+1];
        for i in [1..deg] do
            state[i] := Position(new_states, states_reprs[list[s][i]]);
        od;
        new_list := Concatenation(new_list, [state]);
    od;

    return [new_list, new_states];
end);


###############################################################################
##
#F  MinimalSubAutomatonInlist(<states>, <list>)
##
##  Returns list rep of automaton which is minimal subatomaton of automaton
##  with list rep <list> containing states <states>.
##
##  It does not check correctness of list
##
InstallGlobalFunction(MinimalSubAutomatonInlist,
function(states, list)
    local s, new_states, state, new_list, i, deg;

    new_states := [];
    for s in states do
        new_states := Union(new_states, ConnectedStatesInList(s, list));
    od;

    new_list := [];
    deg := Length(list[1]) - 1;

    for s in new_states do
        state := [];
        for i in [1..deg] do
            state[i] := Position(new_states, list[s][i]);
        od;
        state[deg+1] := list[s][deg+1];
        new_list := Concatenation(new_list, [state]);
    od;

    return [new_list, new_states];
end);


###############################################################################
##
#F  PermuteStatesInList(<list>, <perm>)
##
##  It does not check correctness of arguments
##
InstallGlobalFunction(PermuteStatesInList,
function(list, perm)
    local new_list, i, j, deg;

    deg := Length(list[1]) - 1;
    new_list := [];
    for i in [1..Length(list)] do
        new_list[i^perm] := [];
        for j in [1..deg] do
            new_list[i^perm][j] := list[i][j]^perm;
        od;
        new_list[i^perm][deg+1] := list[i][deg+1];
    od;

    return new_list;
end);





























