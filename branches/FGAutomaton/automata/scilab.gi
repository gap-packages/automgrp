#############################################################################
##
#W  scilab.gi               automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


InstallOtherMethod(PlotAutomatonSpectraInScilab, [IsList, IsInt, IsInt, IsInt],
function(list, iter_num, round, stacksize)
  local mats, i, j,
  temp_dir, temp_file, temp_file_name, sci_temp_file, sci_temp_file_name,
  plot_spectra_func_file, exec_string;

  plot_spectra_func_file := "/home/muntyan/math/automata/scilab/plot_spectra.sci";

  ## TODO: input checking

  mats := PermMatrices(list, iter_num);

  temp_dir := DirectoryTemporary();
  temp_file_name := Filename(temp_dir, "pass");
  temp_file := OutputTextFile(temp_file_name, false);
  if temp_file = fail then
  	Error("Could not create temp file\n");
  fi;

  for i in [1..2^iter_num] do
  	for j in [1..Length(list)] do
  		AppendTo(temp_file, mats[j][i][1], "\t", mats[j][i][2], "\t");
  	od;
  	AppendTo(temp_file, "\n");
  od;
  CloseStream(temp_file);

  sci_temp_file_name := Filename(temp_dir, "pass_sci");
  sci_temp_file := OutputTextFile(sci_temp_file_name, false);
  if sci_temp_file = fail then
  	Error("Could not create temp file for scilab script\n");
  fi;

  AppendTo(sci_temp_file, "getf(\"", plot_spectra_func_file, "\");\n");
  AppendTo(sci_temp_file, "plot_spectra(\"", temp_file_name, "\", ", Length(list), ", ", iter_num, ", ", round, ", ", stacksize, ");\n");
#  AppendTo(sci_temp_file, "exit\n");
  CloseStream(sci_temp_file);

  exec_string := Concatenation("xterm -e scilab -nw -f ", sci_temp_file_name, " > /dev/null");
  Exec(exec_string);
end);


InstallMethod(PlotAutomatonSpectraInScilab, [IsList, IsInt, IsInt],
function(list, iter_num, round)
  PlotAutomatonSpectraInScilab(list, iter_num, round, 10000000);
end);


InstallOtherMethod(PlotAutomatonSpectraInScilab, [IsList, IsInt],
function(list, iter_num)
  PlotAutomatonSpectraInScilab(list, iter_num, 7, 10000000);
end);



