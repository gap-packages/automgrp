#############################################################################
##
#W  agroup.gi               automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


###############################################################################
##
#R  IsAGroupRep
##
DeclareRepresentation(  "IsAGroupRep",
                        IsComponentObjectRep and IsAttributeStoringRep,
                        ["Gens", "AutomFam", "Degree"]);


###############################################################################
##
#M  AGroup(<gens>)
##
InstallMethod(AGroup, [IsList],
function(gens)
    local i;

    for i in [1..Length(gens)] do
        if not IsAutom(gens[i]) then
            Error("AGroup(IsList): ", i, "-th element of list is not Autom\n");
        fi;
    od;

    if Length(gens) = 0 then
        Error("AGroup(IsList): don't know what is trivial group\n");
    fi;

    return Objectify(  NewType(NewFamily("AGroupFamily"), IsAGroup),
                        rec (   Gens := gens,
                                AutomFam := FamilyObj(gens[1]),
                                Degree := Degree(gens[1]))
    );
end);


###############################################################################
##
#M  PrintObj(G)
##
InstallMethod(PrintObj, [IsAGroup],
function(G)
    Print("<", Word(G!.Gens), ">");
end);


###############################################################################
##
#M  OneOp(G)
##
InstallOtherMethod(OneOp, [IsAGroup],
function(G)
    return One(G!.AutomFam);
end);


###############################################################################
##
#M  GeneratorsOfGroup(G)
##
InstallOtherMethod(GeneratorsOfGroup, [IsAGroup],
function(G)
    return G!.Gens;
end);


###############################################################################
##
#M  Word(G)
##
InstallOtherMethod(Word, [IsAGroup],
function(G)
    return Word(G!.Gens);
end);


###############################################################################
##
#M  Degree(G)
##
InstallOtherMethod(Degree, [IsAGroup],
function(G)
    return G!.Degree;
end);


###############################################################################
##
#M  StabilizerOfFirstLevel(G)
##
InstallMethod(StabilizerOfFirstLevel, [IsAGroup],
function (G)
    local freegens, S, F, hom, chooser, s, f, gens;

    if Set( List(G!.Gens, g -> Perm(g)) ) = [()] then
        return G;
    fi;

    freegens := List(GeneratorsOfGroup(G), a -> [a!.Word, a!.Perm]);
    S := Group(List(freegens, x -> x[2]));
    F := FreeGroup(Length(freegens));
    hom := GroupHomomorphismByImagesNC(F, S,
                GeneratorsOfGroup(F), List(freegens, x -> x[2]));
    gens := GeneratorsOfGroup(Kernel(hom));
    gens := Nielsen(gens)[1];
    gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
    return AGroup(gens);
end);


###############################################################################
##
#M  StabilizerOfLevel(G, k)
##
InstallMethod(StabilizerOfLevel, [IsAGroup, IsInt],
function (G, k)
    local freegens, S, F, hom, chooser, s, f, gens;

##	TODO
##	if stabilizes the level then return G

    freegens := List(GeneratorsOfGroup(G), a -> [a!.Word, Perm(a, k)]);
    S := Group(List(freegens, x -> x[2]));
    F := FreeGroup(Length(freegens));
    hom := GroupHomomorphismByImagesNC(F, S,
                GeneratorsOfGroup(F), List(freegens, x -> x[2]));
    gens := GeneratorsOfGroup(Kernel(hom));
    gens := Nielsen(gens)[1];
    gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
    return AGroup(gens);
end);


###############################################################################
##
#M  StabilizerOfVertex(G, k)
##
InstallMethod(StabilizerOfVertex, [IsAGroup, IsInt],
function (G, k)
    local X, S, F, hom, s, f, gens, stab, rt, map, canonreprs,
            action;

##	TODO
#     if G stabilizes k then return G; fi;

    X := List(G!.Gens, a -> [a!.Word, a!.Perm]);
    S := Group(List(X, x -> x[2]));
    F := FreeGroup(Length(X));
    hom := GroupHomomorphismByImagesNC(F, S,
                GeneratorsOfGroup(F), List(X, x -> x[2]));
    action := function(k, w)
        return k^Image(hom, w);
    end;
    gens := GeneratorsOfGroup(Stabilizer(F, k, action));
    gens := Nielsen(gens)[1];
    gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
    return AGroup(gens);
end);


###############################################################################
##
#M  StabilizerOfVertex(G, seq)
##
InstallOtherMethod(StabilizerOfVertex, [IsAGroup, IsList],
function (G, seq)
    local X, S, F, hom, s, f, gens, stab, rt, map, canonreprs,
            action, i, v;

##	TODO
#     if G stabilizes k then return G; fi;

		if Length(seq) = 0 then
			Error("StabilizerOfVertex(IsAGroup, IsList): don't want to stabilize root vertex\n");
		fi;    
		for i in [1..Length(seq)] do
			if not seq[i] in [1..Degree(G)] then
				Error("StabilizerOfVertex(IsAGroup, IsList): list is not valid vertex\n");
			fi;
		od;
		
		v := Position(AsList(Tuples([1..Degree(G)], Length(seq))), seq);
		
		X := List(G!.Gens, a -> [a!.Word, Perm(a, Length(seq))]);
    S := Group(List(X, x -> x[2]));
    F := FreeGroup(Length(X));
    hom := GroupHomomorphismByImagesNC(F, S,
                GeneratorsOfGroup(F), List(X, x -> x[2]));
    action := function(k, w)
        return k^Image(hom, w);
    end;
    gens := GeneratorsOfGroup(Stabilizer(F, v, action));
    gens := Nielsen(gens)[1];
    gens := List(gens, w -> CalculateWord(w, GeneratorsOfGroup(G)));
    return AGroup(gens);
end);


#############################################################################
##
#M  IndexInFreeGroup(G)
##
InstallMethod(IndexInFreeGroup, [IsAGroup],
function(G)
    local s, fam;
    fam := G!.AutomFam;
    s := Subgroup(fam!.FreeGroup, List(G!.Gens, a -> a!.Word));
    return IndexInParent(s);
end);


#############################################################################
##
#M  Mihaylov(G)
##
InstallMethod(Mihaylov, [IsAGroup],
function(G)
	return Mihaylov(G!.AutomFam);
end);


###############################################################################
##
#M  Nielsen(G)
##
InstallOtherMethod(Nielsen, [IsAGroup],
function(G)
    local gens;
    gens := Difference(Nielsen(Word(G!.Gens))[1],
                        [One(Nielsen(Word(G!.Gens))[1][1])]);

    if Length(gens) = 0 then
        return AGroup([One(G)]);
    else
        return AGroup(List(gens, w -> Autom(w, G!.AutomFam)));
    fi;
end);


###############################################################################
##
#M  Projection(G, k)
##
InstallMethod(Projection, [IsAGroup, IsInt],
function(G, k)
    if k < 1 or k > G!.Degree then
        Error("Projection(IsAGroup, IsInt): bad vertex number\n");
    fi;

    if Set(List(G!.Gens, g -> (k = k^g))) <> [true] then
        Error("Projection(IsAGroup, IsInt): group does not stabilize given vertex\n");
    fi;

    return AGroup(List(G!.Gens, g -> Projection(g, k)));
end);


###############################################################################
##
#M  IsFractalByWords(G)
##
InstallOtherMethod(IsFractalByWords, [IsAGroup],
function(G)
	return IsFractalByWords(G!.AutomFam);
end);


###############################################################################
##
#M  Perm(G)
##
InstallOtherMethod(Perm, [IsAGroup],
function(G)
	return Group(List(GeneratorsOfGroup(G), a -> Perm(a)));
end);


###############################################################################
##
#M  Perm(G, k)
##
InstallOtherMethod(Perm, [IsAGroup, IsInt],
function(G, k)
	return Group(List(GeneratorsOfGroup(G), a -> Perm(a, k)));
end);






