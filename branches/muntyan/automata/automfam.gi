#############################################################################
##
#W  automfam.gi               automata package                  Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


#############################################################################
##
#M  Mihaylov(<fam>)
##
InstallOtherMethod(Mihaylov, [IsAutomFamily],
function(fam)
	return MihaylovSystem(fam);
end);


#############################################################################
##
#M  MihaylovSystem(<fam>)
##
InstallMethod(MihaylovSystem, [IsAutomFamily],
function(fam)
	local gens, mih;
	
	if not IsActingOnBinaryTree(fam) then
		Print("Mihaylov(IsAutomFamily): group is not acting on binary tree\n");
		return fail;
	fi;
	
	if not IsFractalByWords(fam) then
		Print("Mihaylov(IsAutomFamily): group is not fractal\n");
		return fail;
	fi;
	
	gens := StructuralCopy(GeneratorsOfGroup(StabilizerOfFirstLevel(fam!.Group)));
	mih := Mihaylov(List(gens, a -> a!.States));
	
	return mih;
end);


###############################################################################
##
#M  IsFractalByWords(fam)
##
InstallMethod(IsFractalByWords, [IsAutomFamily],
function(fam)
	local stab, i, pr;

	stab := StabilizerOfFirstLevel(AGroup(Values(fam!.Gens)));
	stab := List(GeneratorsOfGroup(stab), a -> a!.States);
	for i in [1..fam!.Degree] do
		pr := List(stab, s -> s[i]);
# 		if IndexInParent(Subgroup(fam!.FreeGroup, pr)) <> 1 then
# 			return false;
# 		fi;
		if Difference(Nielsen(pr)[1], [One(pr[1])]) <> GeneratorsOfGroup(fam!.FreeGroup) then
			return false;
		fi;
	od;

	return true;
end);


