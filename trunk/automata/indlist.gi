#############################################################################
##
#W  indlist.gi              automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


#############################################################################
##
#R  IsIndexedListRep
##
IsIndexedListRep := NewRepresentation(  "IsIndexedListRep",
                                        IsComponentObjectRep,
                                        ["indexes", "values", "length"] );
IndexedListFamily := NewFamily  (
            "IndexedListFamily",
            IsIndexedList and IsIndexedListRep  );

#############################################################################
##
#M  IndexedList(<ind_list>, <val_list>)
##
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


#############################################################################
##
#M	IndexedList(<list>)
##
InstallOtherMethod(IndexedList, [IsList],
function(list)
    return IndexedList(list, list);
end);


#############################################################################
##
#M	IndexedList()
##
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


#############################################################################
##
#M	Length(<indexed_list>)
##
InstallOtherMethod(Length, [IsIndexedList],
function(list)
    return list!.length;
end);
#############################################################################
##
#M	Size(<indexed_list>)
##
InstallOtherMethod(Size, [IsIndexedList],
function(list)
    return list!.length;
end);


#############################################################################
##
#M	PrintObj(<indexed_list>)
##
InstallMethod(PrintObj, [IsIndexedList],
function(list)
    Print(list!.indexes, " -> ", list!.values);
    return;
end);


#############################################################################
##
#M	IsBoundInIndexedList(<indexed_list>, <pos>)
##
InstallOtherMethod(IsBoundInIndexedList, [IsIndexedList, IsObject],
function(list, pos)
    return not (PositionSet(list!.indexes, pos) = fail);
end);


#############################################################################
##
#M	Value(<indexed_list>, <pos>)
##
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


#############################################################################
##
#M	Put(<indexed_list>, <pos>, <val>)
##
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


#############################################################################
##
#M	Remove(<indexed_list>, <pos>)
##
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


#############################################################################
##
#M	SubList(<indexed_list>, <indexes>)
##
InstallMethod(SubList, [IsIndexedList, IsList],
function(list, ind)
    local sub, i;

    sub := IndexedList(Set(ind));
    for i in ind do
        Put(sub, i, Value(list, i));
    od;
    return sub;
end);


#############################################################################
##
#M	Indexes(<indexed_list>)
##
InstallMethod(Indexes, [IsIndexedList],
function(list)
    return list!.indexes;
end);


#############################################################################
##
#M	Values(<indexed_list>)
##
InstallMethod(Values, [IsIndexedList],
function(list)
    return list!.values;
end);


#############################################################################
##
#M	UnionOfIndexedLists(<list1>, <list2>)
##
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


#############################################################################
##
#M	UnionOfIndexedLists(<list>)
##
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




