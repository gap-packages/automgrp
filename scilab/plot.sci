// ******************************************************************
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

endfunction
// ******************************************************************



// ******************************************************************
function [sp] = plot_spec_round(autom, iter_num, prec)

num_states = size(autom); num_states = num_states(1);

mats = list(1);
for i=2:num_states
	mats = lstcat(mats, list(1));
end

for i=1:iter_num
	mats = iter_autmats(mats, autom);
end

op = mats(1);
for i=2:num_states
	op = op + mats(i);
end
op = op / num_states;

sp = spec(op);
sp_for_plotting = sp;
for i=1:2^iter_num
	sp_for_plotting(i) = round(sp_for_plotting(i)*2^(prec)) / 2^(prec);
end

freq_matrix = nfreq(sp_for_plotting);
num_eigens = size(freq_matrix); num_eigens = num_eigens(1);
x = [1:num_eigens]; y =x;
for i=1:num_eigens,
	x(i) = freq_matrix(i,1);
	y(i) = freq_matrix(i,2);
end,
plot2d3(x,y, strf="011", rect=[-1,0,1,max(y)]);

endfunction
// ******************************************************************



// ******************************************************************
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
// ******************************************************************


// ******************************************************************
function [sp] = plotmain(autom, iter, calc_inv)
	global ROUND
	
	if ROUND == [] then
		ROUND = 7;
	end
	
	ss = stacksize();
	if ss < 10000000 then	
		stacksize(10000000);
	end
	
	if calc_inv then
		sp = plot_spec_round(get_inverses(autom), iter, ROUND);
	else
		sp = plot_spec_round(autom, iter, ROUND);
	end
//	xset("font size", 14);
	xtitle(get_title(autom, iter), "", "");
	disp(strcat(["minmin = ", string(sp(1))]));
	disp(strcat(["min = ", string(sp(2))]));
	disp(strcat(["max = ", string(sp(2^iter-1))]));
endfunction
// ******************************************************************


// ******************************************************************
function [sp] = plotspec(autom, iter)
	sp = plotmain(autom, iter, %T);
endfunction

function [sp] = plotspec_ni(autom, iter)
	sp = plotmain(autom, iter, %F);
endfunction
// ******************************************************************


// ******************************************************************
function [title] = get_title(autom, iter)
	[num_states, d] = size(autom); d = d - 1;
	letters = ['a','b','c','d','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
	id = 'e';
	sigma = "(01)";
	st = list(1:num_states);
	for i = 1:num_states
		if (autom(i, 1) - i)^2 + (autom(i, 2) - i)^2 + (autom(i, 3))^2 == 0 then
			st = id;
		else
			st = letters(i);
		end
	end
	
	states = list(1:num_states);
	for i = 1:num_states
		states(i) = strcat([st(i), " = (", st(autom(i, 1)), ", ", st(autom(i, 2)), ")"]);
		if autom(i, 3) <> 0 then
			states(i) = strcat([states(i), sigma]);
		end
	end
	
	title = "";
	for i=1:(num_states - 1)
		title = strcat([title, states(i), ", "]);
	end
	title = strcat([title, states(num_states)]);
	title = strcat([title, "; ", string(iter), "-th level"]);
endfunction
// ******************************************************************




