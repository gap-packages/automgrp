//

function [freq_matrix] = plot_spec(mat)

freq_matrix = nfreq(spec(mat))
num_eigens = size(freq_matrix); num_eigens = num_eigens(1);
x = [1:num_eigens]; y =x;
for i=1:num_eigens
	x(i) = freq_matrix(i,1)
	y(i) = freq_matrix(i,2)
end
plot2d3(x,y, strf="011", rect=[-1,0,1,max(y)])
