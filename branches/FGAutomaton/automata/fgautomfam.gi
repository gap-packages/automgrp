#############################################################################
##
#W  fgautomfam.gi               automata package               Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


#############################################################################
##
#M  Mihaylov(<fam>)
##
InstallOtherMethod(Mihaylov, [IsFGAutomFamily],
function(fam)
	return MihaylovSystem(fam);
end);


#############################################################################
##
#M  MihaylovSystem(<fam>)
##
InstallMethod(MihaylovSystem, [IsFGAutomFamily],
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
InstallMethod(IsFractalByWords, [IsFGAutomFamily],
function(fam)
	local stab, i, pr;

	stab := StabilizerOfFirstLevel(FGAutomGroup(Values(fam!.Gens)));
	stab := List(GeneratorsOfGroup(stab), a -> a!.States);
	for i in [1..fam!.Degree] do
		pr := List(stab, s -> s[i]);
		if Difference(Nielsen(pr)[1], [One(pr[1])]) <> GeneratorsOfGroup(fam!.FreeGroup) then
			return false;
		fi;
	od;

	return true;
end);

