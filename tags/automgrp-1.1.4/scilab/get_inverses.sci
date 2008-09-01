//

function [full_mat] = get_inverses(mat)
	[m, d] = size(mat);

	inv_mat = mat;
	for i = 1:m 
		if inv_mat(i,3) == 0 then
			inv_mat(i,1) = inv_mat(i,1) + m;
			inv_mat(i,2) = inv_mat(i,2) + m;			
		else
			t = inv_mat(i,1);
			inv_mat(i,1) = inv_mat(i,2) + m;
			inv_mat(i,2) = t + m;			
		end
	end
	
	full_mat = [mat; inv_mat];
endfunction


