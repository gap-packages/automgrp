// PlotSpectraPermsInScilab.sci
// File used by PlotSpectraPermsInScilab() GAP function defined in scilab.gi.

function [spectra] = PlotSpectraPermsInScilab(file_mats, num_mats, size_mats, prec, stack_size, output_file, graph_title)

if stack_size > 0 then
  stacksize(stack_size);
end

[all_mats] = read(file_mats, size_mats, 2*num_mats);

mats = list(1:num_mats);
for i=1:num_mats
  mats(i) = [all_mats([1:size_mats], [2*i-1, 2*i])];
end

id = ones(size_mats, 1);
op = sparse(mats(1), id) + sparse(mats(1), id)';
for i=2:num_mats
  op = op + sparse(mats(i), id) + sparse(mats(i), id)';
end
op = op / num_mats /2;

sp = spec(full(op));
spectra = sp;
for i=1:size_mats
  spectra(i) = round(spectra(i)*2^(prec)) / 2^(prec);
end

freq_matrix = nfreq(spectra);
num_eigens = size(freq_matrix); num_eigens = num_eigens(1);
x = [1:num_eigens]; y = x;
for i=1:num_eigens,
  x(i) = freq_matrix(i,1);
  y(i) = freq_matrix(i,2);
end,
xbasc(0);
plot2d3(x,y, strf="011", rect=[-1,0,1,max(y)]);

// legends(["lalala"], [-1], opt="ur")
if graph_title <> ""
  xtitle(graph_title)
end

if output_file <> ""
  xs2eps(0, output_file + ".eps")
  fprintfMat(output_file + ".dat",freq_matrix,"%f")
end
