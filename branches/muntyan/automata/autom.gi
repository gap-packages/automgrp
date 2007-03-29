#############################################################################
##
#W  autom.gi                 automata package                  Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


###############################################################################
##
#R  IsAutomRep
##
DeclareRepresentation(  "IsAutomRep",
                        IsComponentObjectRep and IsAttributeStoringRep,
                        ["Word", "States", "Perm", "Degree"]);


###############################################################################
##
#M  CreateAutom(<list>, <names>, <rename>, <int>)
##
InstallOtherMethod(CreateAutom, [IsList, IsList, IsBool, IsInt],
function (list, names, rename, fictive_parameter)
    local  degree, t, trivstate , perm, nontrivstates, freegroup,
            freegens, i, j, family;

# 1. Check correctness of arguments

    if not IsCorrectListComponentOfAutomaton(list)[1] then
        Print("error: ", IsCorrectListComponentOfAutomaton(list)[2], "\n");
        return fail;
    fi;

    degree := Length(list[1]) - 1;

# 2. Reduce automaton, find trivial state, permute states

    t := ReducedAutomatonInList(list);
    list := t[1];
    names := List(t[2], x->names[x]);

    trivstate := 0;
    for i in [1..Length(list)] do
        if IsTrivialStateInList(i, list) then
            trivstate := i;
        fi;
    od;
    if trivstate <> 0 then
        if Length(list) = 1 then
            Print("error: don't want to work with trivial automaton\n");
            return fail;
        fi;
        if trivstate <> Length(list) then
            perm := PermListList([1..Length(list)],
                Concatenation(  [1..(trivstate-1)],
                                [(trivstate+1)..Length(list)],
                                [trivstate] )
            );
            list := PermuteStatesInList(list, perm^-1);
            names := Permuted(names, perm^-1);
        fi;
        trivstate := Length(list);
        names[trivstate] := AUTOMATA_PARAMETERS.IDENTITY_SYMBOL;
    fi;

    # list [1..Length(list)] or [1..Lentgh(list)-1], depending on
    # presence of trivial state
    nontrivstates := Difference([1..Length(list)], [trivstate]);

# 4. Create FreeGroup and FreeGens

    freegroup := FreeGroup(names{nontrivstates});
    freegens := FreeGeneratorsOfFpGroup(freegroup);

    for i in [1..Length(list)] do
        for j in [1..degree] do
            if list[i][j] = trivstate then
                list[i][j] := One(freegroup);
            else
                list[i][j] := freegens[list[i][j]];
            fi;
        od;
    od;

# 8. Create family

    family := NewFamily("AutomFamily",
                        IsAutom,
                        IsAutom,
                        IsAutomFamily and IsAutomObj);

    family!.Degree := degree;
    family!.Names := names{nontrivstates};
    family!.FreeGroup := freegroup;
    family!.FreeGens := freegens;
    family!.AutomatonList := list;

# 9. Create Automs

    family!.Gens := IndexedList();
    for i in [1..Length(freegens)] do
        Put(family!.Gens, freegens[i],
            Objectify(  NewType(family, IsAutom),
                        rec(    Word := freegens[i],
                                States := list[i]{[1..degree]},
                                Perm := list[i][degree+1],
                                Degree := degree   )   )
        );
        Put(family!.Gens, freegens[i]^-1,
            Value(family!.Gens, freegens[i])^-1 );

        if rename then
            if IsBoundGlobal(names[i]) then
                if IsReadOnlyGlobal(names[i]) then
                    Print("CreateAutom: can't rename ", names[i], ", read-only variable\n");
                else
                    BindGlobal(names[i], Value(family!.Gens, freegens[i]));
                    MakeReadWriteGlobal(names[i]);
                fi;
            else
                BindGlobal(names[i], Value(family!.Gens, freegens[i]));
                MakeReadWriteGlobal(names[i]);
            fi;
        fi;
    od;
    Put(family!.Gens, One(freegroup), One(Value(family!.Gens, freegens[1])));

    family!.Group := AGroup(List(family!.FreeGens, x -> Value(family!.Gens, x)));
		return family!.Group;
end);


###############################################################################
##
#M  CreateAutom(<list>, <names>)
##
InstallOtherMethod(CreateAutom, [IsList, IsList],
function (list, names)
    return CreateAutom(list, names, true, 1);
end);


###############################################################################
##
#M  Autom(<word>, <fam>)
##
InstallOtherMethod(Autom, [IsAssocWord, IsAutomFamily],
function(w, fam)
    if Length(w) <= 1 then
        return Value(fam!.Gens, w);
    else
        return CalculateWord(w, List(fam!.FreeGens, x -> Value(fam!.Gens, x)));
    fi;
end);


###############################################################################
##
#M  Autom(<word>, <autom>)
##
InstallOtherMethod(Autom, [IsAssocWord, IsAutom],
function(w, a)
    return Autom(w, FamilyObj(a));
end);


###############################################################################
##
#M  InverseOp(a)
##
InstallMethod(InverseOp, [IsAutom],
function(a)
    return Objectify(  NewType(FamilyObj(a), IsAutom),
                        rec(    Word := a!.Word ^ -1,
                                States := List([1..a!.Degree], i -> a!.States[i^(a!.Perm^-1)] ^ -1),
                                Perm := a!.Perm ^ -1,
                                Degree := a!.Degree   )   );
end);


###############################################################################
##
#M  OneOp(a)
##
InstallMethod(OneOp, [IsAutom],
function(a)
    return Objectify(  NewType(FamilyObj(a), IsAutom),
                        rec(    Word := One(a!.Word),
                                States := List([1..a!.Degree], i -> One(a!.Word)),
                                Perm := (),
                                Degree := a!.Degree   )   );
end);


###############################################################################
##
#M  OneOp(fam)
##
InstallOtherMethod(OneOp, [IsAutomFamily],
function(fam)
    return Objectify(  NewType(fam, IsAutom),
                        rec(    Word := One(fam!.FreeGroup),
                                States := List([1..fam!.Degree], i -> One(fam!.FreeGroup)),
                                Perm := (),
                                Degree := fam!.Degree   )   );
end);


###############################################################################
##
#M  PrintObj(a)
##
InstallMethod(PrintObj, [IsAutom],
function (a)
    local deg, printword, i;

    printword := function(w)
        if IsOne(w) then Print(AUTOMATA_PARAMETERS.IDENTITY_SYMBOL);
        else Print(w); fi;
    end;

    deg := a!.Degree;
    printword(a!.Word);
    Print(" = (");
    for i in [1..deg] do
        printword(a!.States[i]);
        if i <> deg then Print(", "); fi;
    od;
    Print(")");
    if not IsOne(a!.Perm) then Print(a!.Perm); fi;
end);


# ###############################################################################
# ##
# #M  ViewObj(a)
# ##
# InstallMethod(ViewObj, [IsAutom],
# function (a)
#     if IsOne(a!.Word) then Print(AUTOMATA_PARAMETERS.IDENTITY_SYMBOL);
#     else Print(a!.Word); fi;
# end);


###############################################################################
##
#M  TopPerm(a)
##
InstallMethod(TopPerm, [IsAutom],
function(a)
    return a!.Perm;
end);


###############################################################################
##
#M  Perm(a)
##
InstallOtherMethod(Perm, [IsAutom],
function(a)
    return a!.Perm;
end);


###############################################################################
##
#M  Perm(a, k)
##
InstallMethod(Perm, [IsAutom, IsInt],
function(a, k)
		local dom, perm;
		
		if k <= 0 then
			Error("Perm(IsAutom, IsInt): level number is not positive\n");
		fi;
		
		dom := AsList(Tuples([1..Degree(a)], k));
		perm := List(dom, s -> s ^ a);
		perm := PermListList(dom, perm);
		
		return perm;
end);


###############################################################################
##
#M  Degree(a)
##
InstallOtherMethod(Degree, [IsAutom],
function(a)
    return a!.Degree;
end);


###############################################################################
##
#M  Word(a)
##
InstallOtherMethod(Word, [IsAutom],
function(a)
    return a!.Word;
end);


###############################################################################
##
#M  a1 * a2
##
InstallMethod(\*, [IsAutom, IsAutom],
function(a1, a2)
    return Objectify(
        NewType(FamilyObj(a1), IsAutom),
        rec(    Word := a1!.Word * a2!.Word,
                States := List([1..a1!.Degree], i -> a1!.States[i] * a2!.States[i^(a1!.Perm)]),
                Perm := a1!.Perm * a2!.Perm,
                Degree := a1!.Degree   )   );
end);


###############################################################################
##
#M  Projection(a, k)
##
InstallOtherMethod(Projection, [IsAutom, IsInt],
function(a, k)
    if k < 1 or k > a!.Degree then
        Error("Projection(IsAutom, IsInt): wrong vertex number\n");
    fi;

    return Autom(a!.States[k], a);
end);


# ###############################################################################
# ##
# #M  Nielsen(list, a)
# ##
# InstallOtherMethod(Nielsen, [IsList, IsAutom],
# function(list, fictive_argument)
#     local nie;
#     nie := Nielsen(List(list, a -> Word(a)));
#     return [List(nie[1], w -> Autom(w, list[1])), nie[2], nie[3]];
# end);
# 
# 
###############################################################################
##
#M  k ^ a
##
InstallOtherMethod(\^, [IsInt, IsAutom],
function(k, a)
    return k ^ Perm(a);
end);


###############################################################################
##
#M  \^(seq, a)
##
InstallOtherMethod(\^, [IsList, IsAutom],
function(seq, a)
    local i, deg, img, cur;

    deg := a!.Degree;
    for i in seq do
    if not IsInt(i) or i < 1 or i > deg then
        Print("\^(IsList, IsAutom): ",
            i, "is out of range 1..", deg, "\n");
    fi; od;

    if Length(seq) = 1 then return [seq[1]^a]; fi;

    cur := a;
    img := [];
    for i in [1..Length(seq)] do
        img[i] := seq[i]^Perm(cur);
        cur := Autom(cur!.States[seq[i]], a);
    od;

    return img;
end);


###############################################################################
##
#M  IsOne(a)
##
InstallOtherMethod(IsOne, [IsAutom],
function(a)
    local i, w, aw, d, to_check, checked;

    d := a!.Degree;

    to_check := [a!.Word];
    checked := [];

    while Length(to_check) <> 0 do
        for w in to_check do
            aw := Autom(w, a);
            for i in [1..d] do
                if Perm(aw) <> () then
                    return false;
                fi;
                if (not aw!.States[i] in checked) and (not aw!.States[i] in to_check)
                then
                    to_check := Union(to_check, [aw!.States[i]]);
                fi;
            od;
            checked := Union(checked, [w]);
            to_check := Difference(to_check, [w]);
        od;
    od;

    return true;
end);


###############################################################################
##
#M  a1 = a2
##
InstallMethod(\=, [IsAutom, IsAutom],
function(a1, a2)
    local d, checked_pairs, pos, aw1, aw2, np, i;

    d := a1!.Degree;
    checked_pairs := [[a1!.Word, a2!.Word]];
    pos := 0;

    while Length(checked_pairs) <> pos do
        pos := pos + 1;
        aw1 := Autom(checked_pairs[pos][1], a1);
        aw2 := Autom(checked_pairs[pos][2], a2);

        if Perm(aw1) <> Perm(aw2) then
            return false;
        fi;

        for i in [1..d] do
            np := [aw1!.States[i], aw2!.States[i]];
            if not np in checked_pairs then
                checked_pairs := Concatenation(checked_pairs, [np]);
            fi;
        od;
    od;

    return true;
end);


###############################################################################
##
#M  Projection(a, k)
##
InstallMethod(Projection, [IsAutom, IsInt],
function(a, k)
    if k < 1 or k > a!.Degree then
        Error("Projection(IsAutom, IsInt): wrong vertex number\n");
    fi;

    return Autom(a!.States[k], a);
end);


###############################################################################
##
#M  IsActingOnBinaryTree(fam)
##
InstallMethod(IsActingOnBinaryTree, [IsAutomFamily],
function(fam)
    return fam!.Degree = 2;
end);

























