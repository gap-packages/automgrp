//	iter_autmats
//	iterates automata matrices, i.e. takes computed n x n matrices
//	and returns 2n x 2n matrices
//
//	mats - list of n x n matrices in the same order as they're given in rule
//	rule - matrix defining automaton - m x 3 matrix - each row for each state; 
//
function [new_mats] = iter_autmats(mats, autom)
	
	[m, d] = size(autom);
	
	new_mats = mats;
	z = zeros(mats(1));

	for i = 1:m,
		if autom(i, 3) == 1 then,
			new_mats(i) = [z, mats(autom(i, 1)); mats(autom(i ,2)), z];
		else,
			new_mats(i) = [mats(autom(i, 1)), z; z, mats(autom(i ,2))];
		end,
	end,
