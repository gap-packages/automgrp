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
function [sp, max_freq] = plot_spec_round(autom, iter_num, prec)

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
max_freq = 0;
for i=1:num_eigens,
	x(i) = freq_matrix(i,1);
	y(i) = freq_matrix(i,2);
end,
max_freq = max(y);
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
	
	xbasc();
//	xset("default");
	xset("font size", 6);
	if calc_inv == 1 then
		[sp, ymax] = plot_spec_round(get_inverses(autom), iter, ROUND);
	else
		[sp, ymax] = plot_spec_round(autom, iter, ROUND);
	end

//	xset("font size", 10);
	xtitle(get_title(autom, iter), string(iter), "");	
//	xstring(1.05, ymax/2 ,get_titles_mat(autom));	
	
	disp(strcat(["minmin = ", string(sp(1))]));
	disp(strcat(["min = ", string(sp(2))]));
	disp(strcat(["max = ", string(sp(2^iter-1))]));
endfunction
// ******************************************************************


// ******************************************************************
function [sp] = plotspec(autom, iter)
	sp = plotmain(autom, iter, 1);
endfunction

function [sp] = plotspec_ni(autom, iter)
	sp = plotmain(autom, iter, 0);
endfunction
// ******************************************************************


// ******************************************************************
function [title] = get_title(autom, iter)
	[num_states, d] = size(autom); d = d - 1;
	st_mat = get_titles_mat(autom);
	states = list(1:num_states);
	for i = 1:num_states
		states(i) = st_mat(i, 1);
	end
	
	title = "";
	for i=1:(num_states - 1)
		title = strcat([title, states(i), ", "]);
	end
	title = strcat([title, states(num_states)]);
//	title = strcat([title, "; ", string(iter), "-th level"]);
endfunction
// ******************************************************************


// ******************************************************************
function [mat] = get_titles_mat(autom)
	[num_states, d] = size(autom); d = d - 1;
	letters = ['a','b','c','d','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
	id = 'e';
	sigma = "(01)";
	st = list(1:num_states);
	for i = 1:num_states
		if (autom(i, 1) - i)^2 + (autom(i, 2) - i)^2 + (autom(i, 3))^2 == 0 then
			st(i) = id;
		else
			st(i) = letters(i);
		end
	end
	
	states = [];
	for i = 1:num_states
		str = strcat([st(i), " = (", st(autom(i, 1)), ", ", st(autom(i, 2)), ")"]);
		if autom(i, 3) <> 0 then
			str = strcat([str, sigma]);
		end
		states = [states; [str]];
	end
	
	mat = [states(1)];
	for i = 2:num_states
		mat = [mat; [states(i)]];
	end
endfunction
// ******************************************************************




