#############################################################################
##
#W  automobj.gi              automata package                  Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##

##
##	This file contains default mplementations of functions declared in 
##	automobj.gd
##


# ###############################################################################
# ##
# #M  Degree(<object>)
# ##
# InstallMethod(Degree, [IsAutomObj],
# function(obj)
# 	return obj!.Degree;
# end);
# 
# 
# ###############################################################################
# ##
# #M  IsActingOnBinaryTree(<object>)
# ##
# InstallMethod(IsActingOnBinaryTree, [IsAutomObj],
# function(obj)
# 	return Degree(obj) = 2;
# end);


###############################################################################
##
#M  PermMatrices(<listrep>, <level>)
##
InstallOtherMethod(PermMatrices, [IsList, IsInt],
function(list, n)
	local mats, new_mats, num, deg, i, j, k, k1, k2;
	
##	TODO: error checking	
	
	num := Length(list);
	deg := Length(list[1]) - 1;
	mats := List([1..num], j -> [[1,1]]);
	new_mats := [];
	
	if deg > 2 then
		Error("Sorry, can do it only for binary trees");
	fi;
	
	for i in [1..n] do
		for k in [1..num] do
			k1 := list[k][1];
			k2 := list[k][2];
			if list[k][deg+1] = () then
				new_mats[k] := List(mats[k2], j -> [j[1]+2^(i-1), j[2]+2^(i-1)]);
				new_mats[k] := Union(mats[k1], new_mats[k]);
			else
				new_mats[k] := List(mats[k1], j -> [j[1], j[2]+2^(i-1)]);
				new_mats[k] := Union(new_mats[k], List(mats[k2], j -> [j[1]+2^(i-1), j[2]]));
			fi;
		od;
		mats := StructuralCopy(new_mats);
	od;
	
	return mats;
end);










