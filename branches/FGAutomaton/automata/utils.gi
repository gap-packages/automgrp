#############################################################################
##
#W  utils.gi                   automata package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##
##  automata v 0.91 started June 07 2004
##

Revision.utils_gi := 
  "@(#)$Id$";


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
#        if DEBUG_LEVEL > 1 then Print("IndexedList(IsList, IsList): returned fail\n"); fi;
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
#        if DEBUG_LEVEL > 1 then Print("IndexedList(IsList, IsList): returned fail\n"); fi;
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






#############################################################################
##
#F  automata_lt(w1, w2)
##
automata_lt := function(w1, w2)
	local i, er1, er2;

	if Length(w1) <> Length(w2) then
		return Length(w1) < Length(w2);
	fi;

	er1 := LetterRepAssocWord(w1);
	er2 := LetterRepAssocWord(w2);
	for i in [1..Length(er1)] do
		if AbsInt(er1[i]) <> AbsInt(er2[i]) then
			return AbsInt(er1[i]) < AbsInt(er2[i]);
		fi;
		if er1[i] <> er2[i] then
			return er1[i] > er2[i];
		fi;
	od;

	return false;
end;


#############################################################################
##
#M  Nielsen(<list>)
#M  NielsenBack(<list>)
##
##	It calls appropriate method depending on first element of <list>.
##
##	Returned value is triple [result, transform, did_something] :
##		<result> is the list of words (or whatever depending on type of 
##			argument) obtained from <list> using Nielsen transformations;
##			lexicographic ordering on set of words is generated by the following
##			ordering: x_1 < x_1^{-1} < x_2 < x_2^{-1} < ...
##		<transform> is the list of words for obtaining <result> from 
##			<list> by substituting
##		<did_something> is true if <result> differs from <list> and is
##			false otherwise
##
##	NielsenBack is almost identical to Nielsen: the difference is in the 
##		the order of comparisons performed inside of main loop;
##		it makes Mihaylov feel better?
##
InstallMethod(Nielsen, [IsList],
function(list)
	if IsEmpty(list) or not IsDenseList(list) then
		Error("Nielsen(IsList): argument is empty list\n");
	fi;
	return Nielsen(list, list[1]);
end);

InstallMethod(NielsenBack, [IsList],
function(list)
	if IsEmpty(list) or not IsDenseList(list) then
		Error("NielsenBack(IsList): argument is empty list\n");
	fi;
	return NielsenBack(list, list[1]);
end);


#############################################################################
##
#M  Nielsen(<words_list>, <associative_word>)
##
InstallOtherMethod(Nielsen, [IsList, IsAssocWord],
function(words_list, fictive_arg)
	local result, transform, did_something, n, i, j, try_again, tmp;
	
	n := Length(words_list);
	result := ShallowCopy(words_list);
	transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(n)));
	did_something := false;
	try_again := true;
	
	for i in [1..n] do
		if not IsAssocWord(result[i]) then
			Error("Nielsen(IsList, IsAssocWord): ", i, "-th element of list is not associative word\n");
		fi;
	od;
	
	while try_again do
		try_again := false;
		
		for i in [1..n] do
		for j in [1..n] do
			
			if i = j then
				if automata_lt(result[i]^-1, result[i]) then
					result[i] := result[i]^-1;
					transform[i] := transform[i]^-1;
					did_something := true;
					try_again := true;
				fi;
				continue;
			fi;
			
			if i > j and automata_lt(result[i], result[j]) then
				tmp := result[i];
				result[i] := result[j];
				result[j] := tmp;
				tmp := transform[i];
				transform[i] := transform[j];
				transform[j] := tmp;
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]*result[j], result[i]) then
				result[i] := result[i]*result[j];
				transform[i] := transform[i]*transform[j];
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]*result[j], result[j]) then
				result[j] := result[i]*result[j];
				transform[j] := transform[i]*transform[j];
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]^-1*result[j], result[i]) then
				result[i] := result[i]^-1*result[j];
				transform[i] := transform[i]^-1*transform[j];
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]^-1*result[j], result[j]) then
				result[j] := result[i]^-1*result[j];
				transform[j] := transform[i]^-1*transform[j];
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]*result[j]^-1, result[i]) then
				result[i] := result[i]*result[j]^-1;
				transform[i] := transform[i]*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]*result[j]^-1, result[j]) then
				result[j] := result[i]*result[j]^-1;
				transform[j] := transform[i]*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]^-1*result[j]^-1, result[i]) then
				result[i] := result[i]^-1*result[j]^-1;
				transform[i] := transform[i]^-1*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]^-1*result[j]^-1, result[j]) then
				result[j] := result[i]^-1*result[j]^-1;
				transform[j] := transform[i]^-1*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
		od;
		od;
	od;
	
	return [result, transform, did_something];
end);


#############################################################################
##
#M  NielsenBack(<words_list>, <associative_word>)
##
InstallOtherMethod(NielsenBack, [IsList, IsAssocWord],
function(words_list, fictive_arg)
	local result, transform, did_something, n, i, j, try_again, tmp;
	
	n := Length(words_list);
	result := ShallowCopy(words_list);
	transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(n)));
	did_something := false;
	try_again := true;
	
	for i in [1..n] do
		if not IsAssocWord(result[i]) then
			Error("NielsenBack(IsList, IsAssocWord): ", i, "-th element of list is not associative word\n");
		fi;
	od;
	
	while try_again do
		try_again := false;
		
		for i in [1..n] do
		for j in [1..n] do
			
			if i = j then
				if automata_lt(result[i]^-1, result[i]) then
					result[i] := result[i]^-1;
					transform[i] := transform[i]^-1;
					did_something := true;
					try_again := true;
				fi;
				continue;
			fi;
			
			if i > j and automata_lt(result[i], result[j]) then
				tmp := result[i];
				result[i] := result[j];
				result[j] := tmp;
				tmp := transform[i];
				transform[i] := transform[j];
				transform[j] := tmp;
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]^-1*result[j]^-1, result[j]) then
				result[j] := result[i]^-1*result[j]^-1;
				transform[j] := transform[i]^-1*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]^-1*result[j]^-1, result[i]) then
				result[i] := result[i]^-1*result[j]^-1;
				transform[i] := transform[i]^-1*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]*result[j]^-1, result[j]) then
				result[j] := result[i]*result[j]^-1;
				transform[j] := transform[i]*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]*result[j]^-1, result[i]) then
				result[i] := result[i]*result[j]^-1;
				transform[i] := transform[i]*transform[j]^-1;
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]^-1*result[j], result[i]) then
				result[i] := result[i]^-1*result[j];
				transform[i] := transform[i]^-1*transform[j];
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]^-1*result[j], result[j]) then
				result[j] := result[i]^-1*result[j];
				transform[j] := transform[i]^-1*transform[j];
				did_something := true;
				try_again := true;
			fi;
			
			if automata_lt(result[i]*result[j], result[j]) then
				result[j] := result[i]*result[j];
				transform[j] := transform[i]*transform[j];
				did_something := true;
				try_again := true;
			fi;
			if automata_lt(result[i]*result[j], result[i]) then
				result[i] := result[i]*result[j];
				transform[i] := transform[i]*transform[j];
				did_something := true;
				try_again := true;
			fi;			
		od;
		od;
	od;
	
	return [result, transform, did_something];
end);


#############################################################################
##
#M  CalculateWord(<word>, <list>)
##
InstallMethod(CalculateWord, [IsAssocWord, IsList],
function(w, img)
    local result, i;

    result := One(img[1]);

    for i in [1..NumberSyllables(w)] do
        result := result *
                    img[GeneratorSyllable(w, i)]^ExponentSyllable(w, i);
    od;

    return result;
end);


#############################################################################
##
#M  CalculateWords(<words_list>, <list>)
##
InstallMethod(CalculateWords, [IsList, IsList],
function(words, domain)
    local result, i;

    result := [];
    for i in [1..Length(words)] do
        result[i] := CalculateWord(words[i], domain);
    od;

    return result;
end);


#############################################################################
##
#M  Rang(<list>)
##
InstallMethod(Rang, [IsList],
function(list)
    return Rang(list, list[1]);
end);


#############################################################################
##
#M  Rang(<words_list>)
##
InstallOtherMethod(Rang, [IsList, IsAssocWord],
function(words, fictive_argument)
    return Length(Difference(Nielsen(words)[1], [One(words[1])]));
end);


#############################################################################
##
#M  Mihaylov(<list>)
##
InstallMethod(Mihaylov, [IsList],
function(pairs)
	local result, i, nie, m, n, w, t;

	if not IsList(pairs[1]) then
		Error("Mihaylov(IsList): first element of list is not IsList\n");
	fi;
	
	if Length(pairs[1]) <> 2 then
		Error("Mihaylov(IsList): can work only with pairs\n");
	fi;
	
	if not IsAssocWord(pairs[1][1]) then
		Error("Mihaylov(IsList): <arg>[1][1] is not IsAssocWord\n");
	fi;
	
	result := StructuralCopy(pairs);
	
##	TODO: do something with m and n	
	
	nie := Nielsen(List(result, p -> p[1]));
	if nie[3] then
		t := StructuralCopy(result);
		for i in [1..Length(result)] do
			t[i][1] := CalculateWord(nie[2][i], List(result, p -> p[1]));
			t[i][2] := CalculateWord(nie[2][i], List(result, p -> p[2]));
		od;
		result := StructuralCopy(t);
	fi;

	for i in [1..Length(result)] do
		if not IsOne(result[i][1]) then
			break;
		fi;
	od;
	m := i - 1; n := Length(result) - m;
	if m = 0 then
		return result;
	fi;
	##	TODO
	##	impossible?
	if n = 0 then
		Error("Mihaylov(IsList): n = 0\n");
	fi;	
	

	nie := NielsenMihaylov(List(result, p -> p[2]), m, n);
	if nie[3] then
		t := StructuralCopy(result);
		for i in [1..Length(result)] do
			t[i][1] := CalculateWord(nie[2][i], List(result, p -> p[1]));
			t[i][2] := CalculateWord(nie[2][i], List(result, p -> p[2]));
		od;
		result := StructuralCopy(t);
	fi;

	nie := NielsenBack(List(result{[m+1..m+n]}, p -> p[1]));
	if nie[3] then
		t := StructuralCopy(result);
		for i in [1..n] do
			t[m+i][1] := CalculateWord(nie[2][i], List(result{[m+1..m+n]}, p -> p[1]));
			t[m+i][2] := CalculateWord(nie[2][i], List(result{[m+1..m+n]}, p -> p[2]));
		od;
		result := StructuralCopy(t);
	fi;

	return result;
end);


#############################################################################
##
#M  Contains(<words_list>, <a>)
##
InstallMethod(Contains, [IsList, IsAssocWord],
function(words, v)
    return Contains(words, v, words[1]);
end);

#############################################################################
##
#M  Contains(<words_list>, <w>, <w>)
##
InstallOtherMethod(Contains, [IsList, IsAssocWord, IsAssocWord],
function(words, v, fictive_argument)
    local proceed, w, lt;

    lt := function(w1, w2)
        local i, er1, er2;

        if Length(w1) <> Length(w2) then
            return Length(w1) < Length(w2);
        fi;

        er1 := LetterRepAssocWord(w1);
        er2 := LetterRepAssocWord(w2);
        for i in [1..Length(er1)] do
            if AbsInt(er1[i]) <> AbsInt(er2[i]) then
                return AbsInt(er1[i]) < AbsInt(er2[i]);
            fi;
            if er1[i] <> er2[i] then
                return er1[i] > er2[i];
            fi;
        od;

        return false;
    end;

    words := Set(Nielsen(words)[1]);

    proceed := true;
    while proceed do
        proceed := false;
        for w in words do
        if lt(v*w, v) then
            v := v*w;
            proceed := true;
        fi;
        if lt(v*w^-1, v) then
            v := v*w^-1;
            proceed := true;
        fi;
        if lt(w*v, v) then
            v := w*v;
            proceed := true;
        fi;
        if lt(w^-1*v, v) then
            v := w^-1*v;
            proceed := true;
        fi;
        od;
    od;

    if IsOne(v) then return true;
    else return false; fi;
end);


#############################################################################
##
#M  NielsenLow(<words_list>, m, n)
##
InstallMethod(NielsenLow, [IsList, IsInt, IsInt],
function(words_list, m, n)
	local result, transform, did_something, i, j, try_again, tmp, nie;
		
	result := ShallowCopy(words_list);
	transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(m+n)));
	did_something := false;
	try_again := true;

	while try_again do
		try_again := false;
		
		nie := Nielsen(result{[1..m]});
		if nie[3] then
			result := Concatenation(CalculateWords(nie[2], result{[1..m]}), result{[m+1..m+n]});
			transform := Concatenation(CalculateWords(nie[2], transform{[1..m]}), transform{[m+1..m+n]});
			did_something := true;
			try_again := true;		
		fi;
		
		for i in [1..m] do			
			for j in [m+1..m+n] do
				if automata_lt(result[i]^result[j], result[i]) then
					result[i] := result[i]^result[j];
					transform[i] := transform[i]^transform[j];
					did_something := true;
					try_again := true;
				fi;
			
				if automata_lt(result[i]^(result[j]^-1), result[i]) then
					result[i] := result[i]^(result[j]^-1);
					transform[i] := transform[i]^(transform[j]^-1);
					did_something := true;
					try_again := true;
				fi;
				
				if automata_lt((result[i]^-1)^result[j], result[i]) then
					result[i] := (result[i]^-1)^result[j];
					transform[i] := (transform[i]^-1)^transform[j];
					did_something := true;
					try_again := true;
				fi;
			
				if automata_lt((result[i]^-1)^(result[j]^-1), result[i]) then
					result[i] := (result[i]^-1)^(result[j]^-1);
					transform[i] := (transform[i]^-1)^(transform[j]^-1);
					did_something := true;
					try_again := true;
				fi;			
			od;
		od;
	od;
	
	return [result, transform, did_something];
end);


#############################################################################
##
#M  NielsenMihaylov(<words_list>, m, n)
##
InstallOtherMethod(NielsenMihaylov, [IsList, IsInt, IsInt],
function(words_list, m, n)
	local result, transform, did_something, try_again, nie, i, j, tf, pair,
				good_tf, good_pair, tmp;
	
	result := StructuralCopy(words_list);
	transform := ShallowCopy(FreeGeneratorsOfFpGroup(FreeGroup(m+n)));
	did_something := false;
	try_again := true;
	
	while try_again do
		try_again := false;
		
		nie := NielsenLow(result, m, n);
		if nie[3] then
			did_something := true;
			try_again := true;
			result := nie[1];
			transform := CalculateWords(nie[2], transform);
		fi;
		
		nie := Nielsen(result{[m+1..m+n]});
		if nie[3] then
			did_something := true;
			try_again := true;
			result := Concatenation(result{[1..m]}, nie[1]);
			transform := Concatenation(transform{[1..m]}, CalculateWords(nie[2], transform{[m+1..m+n]}));
		fi;
		
		if Rang(result{[m+1..m+n]}) = n then
			if List(result{[m+1..m+n]}, w -> Length(w)) = List([1..n], i -> 1) then
				## ok
				try_again := false;
			else
				##	try to minimize sum of lengths
				good_pair := false;
				for pair in ListX([m+1..m+n], [1..m], function(i,j) return [i,j]; end) do
					good_tf := false;
					for tf in [	[1,1,2,1],[2,1,1,1],[1,-1,2,1],[2,-1,1,1],
											[1,1,2,-1],[2,1,1,-1],[1,-1,2,-1],[2,-1,1,-1]	] do
						tmp := StructuralCopy(result);
						tmp[pair[1]] := tmp[pair[tf[1]]]^tf[2] * tmp[pair[tf[3]]]^tf[4];
						if 	Rang(tmp{[m+1..m+n]}) = n and 
								NumberOfLetters(tmp{[m+1..m+n]}) = NumberOfLetters(result{[m+1..m+n]}) and
								Sum(List(tmp{[m+1..m+n]}, w -> Length(w))) < Sum(List(result{[m+1..m+n]}, w -> Length(w)))
						then
							good_tf := true;
							break;
						fi;
					od;
					if good_tf then
						good_pair := true;
						break;
					fi;
				od;
				if not good_pair then
					##	give up
					return [result, transform, did_something];
				else
					result[pair[1]] := result[pair[tf[1]]]^tf[2] * result[pair[tf[3]]]^tf[4];
					transform[pair[1]] := transform[pair[tf[1]]]^tf[2] * transform[pair[tf[3]]]^tf[4];
					try_again := true;
					did_something := true;
				fi;
			fi;
		else
			##	try to make rang bigger
			for i in [1..m] do
				good_tf := false;
				pair := [m+1, i];
				for tf in [	[1,1,2,1],[2,1,1,1],[1,-1,2,1],[2,-1,1,1],
										[1,1,2,-1],[2,1,1,-1],[1,-1,2,-1],[2,-1,1,-1]	] do
					tmp := StructuralCopy(result);
					tmp[pair[1]] := tmp[pair[tf[1]]]^tf[2] * tmp[pair[tf[3]]]^tf[4];
					if 	Rang(tmp{[m+1..m+n]}) > Rang(result{[m+1..m+n]}) and 
							NumberOfLetters(tmp{[m+1..m+n]}) >= NumberOfLetters(result{[m+1..m+n]}) 
					then
						good_tf := true;
						break;
					fi;
				od;
				if good_tf then
					good_pair := true;
					break;
				fi;
			od;
			if not good_pair then
				##	give up
				return [result, transform, did_something];					
			else
				result[pair[1]] := result[pair[tf[1]]]^tf[2] * result[pair[tf[3]]]^tf[4];
				transform[pair[1]] := transform[pair[tf[1]]]^tf[2] * transform[pair[tf[3]]]^tf[4];
				try_again := true;
				did_something := true;
			fi;
		fi;
	
	od;

	return [result, transform, did_something];
end);


#############################################################################
##
#M  NumberOfLetters(<word>, <list>)
##
InstallOtherMethod(NumberOfLetters, [IsList],
function(list)
	local letters, i, j;
	
	letters := [];
	for i in [1..Length(list)] do
		for j in [1..NumberSyllables(list[i])] do
			AddSet(letters, GeneratorSyllable(list[i], j)); 
		od;
	od;
	return Length(letters);
end);


#############################################################################
##
#M  Word(<list>)
##
InstallOtherMethod(Word, [IsList],
function(list)
    return List(list, i -> Word(i));
end);


#E