#############################################################################
##
#W  indlist.gi              automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


IsIndexedListRep := NewRepresentation(  "IsIndexedListRep",
                                        IsComponentObjectRep,
                                        ["indexes", "values", "length"] );
IndexedListFamily := NewFamily  (
            "IndexedListFamily",
            IsIndexedList and IsIndexedListRep  );

InstallMethod(IndexedList, [IsList, IsList],
function(indlist, vallist)
    local i, list, ind;
    ind := Set(indlist);
    if Length(indlist) <> Length(ind) then
        if DEBUG_LEVEL > 1 then Print("IndexedList(IsList, IsList): returned fail\n"); fi;
        return fail;
    fi;

    vallist := Permuted(vallist, SortingPerm(indlist));

    return Objectify(   NewType(IndexedListFamily,
                                IsIndexedList and
                                IsIndexedListRep),
                         rec (
                            values := vallist,
                            indexes := ind,
                            length := Length(ind)   )
    );
end);

InstallOtherMethod(IndexedList, [IsList],
function(list)
    return IndexedList(list, list);
end);

InstallOtherMethod(IndexedList, "creates empty indexed list", ReturnTrue, [],
function()
    return Objectify(   NewType(IndexedListFamily,
                                IsIndexedList and
                                IsIndexedListRep),
                         rec (
                            values := [],
                            indexes := Set([]),
                            length := 0   )
    );
end);

InstallOtherMethod(Length, [IsIndexedList],
function(list)
    return list!.length;
end);
InstallOtherMethod(Size, [IsIndexedList],
function(list)
    return list!.length;
end);

InstallMethod(PrintObj, [IsIndexedList],
function(list)
    Print(list!.indexes, " -> ", list!.values);
    return;
end);


InstallOtherMethod(IsBoundInIndexedList, [IsIndexedList, IsObject],
function(list, pos)
    return not (PositionSet(list!.indexes, pos) = fail);
end);

InstallOtherMethod(Value, [IsIndexedList, IsObject],
function(list, pos)
    local realpos;
# Print("Value: list is ", list, "\npos is ", pos, "\n");
    realpos := PositionSet(list!.indexes, pos);
    if realpos = fail then
        if DEBUG_LEVEL > 1 then Print("IndexedList(IsList, IsList): returned fail\n"); fi;
        return fail;
    else
        return list!.values[realpos];
    fi;
end);

InstallOtherMethod(Put, [IsIndexedList, IsObject, IsObject],
function(list, pos, val)
    local realpos;
    realpos := PositionSet(list!.indexes, pos);
    if realpos <> fail then
        list!.values[realpos] := val;
    else
        realpos := PositionSorted(list!.indexes, pos);
        if realpos = list!.length + 1 then
            Add(list!.values, val);
        else
            list!.values := Concatenation(
                    list!.values{[1..(realpos-1)]},
                    [val],
                    list!.values{[realpos..list!.length]}
            );
        fi;
        AddSet(list!.indexes, pos);
        list!.length := list!.length + 1;
    fi;
    return list;
end);

InstallOtherMethod(Remove, [IsIndexedList, IsObject],
function(list, pos)
    local realpos;
    realpos := PositionSet(list!.indexes, pos);
    if realpos <> fail then
        RemoveSet(list!.indexes, pos);
        if realpos = list!.length then
            list!.values := list!.values{[1..(realpos - 1)]};
        else
            list!.values := Concatenation(
                    list!.values{[1..(realpos - 1)]},
                    list!.values{[(realpos + 1)..list!.length]}
            );
        fi;
        list!.length := list!.length - 1;
    fi;
    return list;
end);


InstallMethod(SubList, [IsIndexedList, IsList],
function(list, ind)
    local sub, i;

    sub := IndexedList(Set(ind));
    for i in ind do
        Put(sub, i, Value(list, i));
    od;
    return sub;
end);

InstallMethod(Indexes, [IsIndexedList],
function(list)
    return list!.indexes;
end);


InstallMethod(Values, [IsIndexedList],
function(list)
    return list!.values;
end);


InstallMethod(UnionOfIndexedLists, [IsIndexedList, IsIndexedList],
function(l1, l2)
    local ind, val, sub;
    ind := l1!.indexes;
    val := l1!.values;
    sub := SubList(l2, Difference(l2!.indexes, ind));
    ind := Concatenation(ind, sub!.indexes);
    val := Concatenation(val, sub!.values);
    return IndexedList(ind, val);
end);


InstallOtherMethod(UnionOfIndexedLists, [IsList],
function(list)
    local union, i;
##  fixme
##  check correctness os argument
    union := list[1];
    for i in [2..Length(list)] do
        union := UnionOfIndexedLists(union, list[i]);
    od;
    return union;
end);




