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


###############################################################################
##
#M  Degree(<object>)
##
InstallMethod(Degree, [IsAutomObj],
function(obj)
	return obj!.Degree;
end);


###############################################################################
##
#M  IsActingOnBinaryTree(<object>)
##
InstallMethod(IsActingOnBinaryTree, [IsAutomObj],
function(obj)
	return Degree(obj) = 2;
end);


