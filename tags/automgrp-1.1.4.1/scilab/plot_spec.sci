// plot_spec.sci

function [freq_matrix] = plot_spec(autom, iter_num)

if ~(exists("iter_autmats")) then
	getf("/home/muntyan/math/automata/scilab/iter_autmats.sci")
end

num_states = size(autom); num_states = num_states(1);

mats = list(1);
for i=2:num_states
	mats = lstcat(mats, list(1))
end

for i=1:iter_num
	mats = iter_autmats(mats, autom)
end

op = mats(1);
for i=2:num_states
	op = op + mats(i)
end
op = op / num_states

freq_matrix = nfreq(spec(op))
num_eigens = size(freq_matrix); num_eigens = num_eigens(1);
x = [1:num_eigens]; y =x;
for i=1:num_eigens
	x(i) = freq_matrix(i,1)
	y(i) = freq_matrix(i,2)
end
plot2d3(x,y, strf="011", rect=[-1,0,1,max(y)])
