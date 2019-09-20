#############################################################################
##
#W  scilab.gi               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


InstallGlobalFunction(PlotSpectraPermsInScilab,
function(perms, deg, opts)
  local mats, i, j,
  temp_dir, temp_file, temp_file_name, sci_temp_file, sci_temp_file_name,
  plot_spectra_func_file, exec_string,
  round, stacksize, output_filename, title;

  if IsBound(opts.round) then round := opts.round; else round := 7; fi;
  if IsBound(opts.stacksize) then stacksize := opts.stacksize; else stacksize := AG_Globals.scilab_stacksize; fi;
  if IsBound(opts.output) then output_filename := opts.output; else output_filename := ""; fi;
  if IsBound(opts.title) then title := opts.title; else title := ""; fi;

  plot_spectra_func_file := Filename(DirectoriesPackageLibrary("automgrp","scilab"),
                                     "PlotSpectraPermsInScilab.sci");
  if plot_spectra_func_file = fail then
    Print("error in PlotSpectraPermsInScilab:\n  scilab file not found\n");
    return fail;
  fi;

  temp_dir := DirectoryTemporary();
  temp_file_name := Filename(temp_dir, "pass");
  temp_file := OutputTextFile(temp_file_name, false);
  if temp_file = fail then
    Print("error in PlotSpectraPermsInScilab:\n  could not create temp file\n");
    return fail;
  fi;

  for i in [1..deg] do
    for j in [1..Length(perms)] do
      AppendTo(temp_file, i, "\t", i^perms[j], "\t");
    od;
    AppendTo(temp_file, "\n");
  od;
  CloseStream(temp_file);

  sci_temp_file_name := Filename(temp_dir, "commands_for_scilab");
  sci_temp_file := OutputTextFile(sci_temp_file_name, false);

  if sci_temp_file = fail then
    Print("error in PlotSpectraPermsInScilab:\n",
          "  Could not create temp file for scilab script\n");
    return fail;
  fi;

  SetPrintFormattingStatus(sci_temp_file, false);

  PrintTo(sci_temp_file, "getf(\"", plot_spectra_func_file, "\");\n");
  PrintTo(sci_temp_file, "PlotSpectraPermsInScilab(",
                         "\"", temp_file_name, "\", ",
                         Length(perms), ", ",
                         deg, ", ",
                         round, ", ",
                         stacksize, ", ",
                         "\"", output_filename, "\", ",
                         "\"", title, "\");\n");

  if output_filename <> "" then
    PrintTo(sci_temp_file, "exit\n");
  fi;

  CloseStream(sci_temp_file);

  exec_string := Concatenation(#"cat ", sci_temp_file_name, "; ",
                               "xterm -e scilab -nw -f ",
                               sci_temp_file_name);

  if output_filename = "" then
    Append(exec_string, " &");
  fi;

  Exec(exec_string);
end);


#############################################################################
##
##  PlotSpectraInScilab(<list>, <level>[, <opts>])
##
InstallMethod(PlotSpectraInScilab,
              [IsList and IsTreeAutomorphismCollection, IsPosInt],
function(gens, level)
  PlotSpectraPermsInScilab(List(gens, g -> PermOnLevel(g, level)),
                           DegreeOfTree(gens[1])^level, rec());
end);

InstallMethod(PlotSpectraInScilab,
              [IsList and IsTreeAutomorphismCollection, IsPosInt, IsRecord],
function(gens, level, opts)
  PlotSpectraPermsInScilab(List(gens, g -> PermOnLevel(g, level)),
                           DegreeOfTree(gens[1])^level, opts);
end);

InstallMethod(PlotSpectraInScilab,
              [IsTreeAutomorphismGroup, IsPosInt],
function(G, level)
  PlotSpectraInScilab(GeneratorsOfGroup(G), level, rec());
end);

InstallMethod(PlotSpectraInScilab,
              [IsTreeAutomorphismGroup, IsPosInt, IsRecord],
function(G, level, opts)
  PlotSpectraInScilab(GeneratorsOfGroup(G), level, opts);
end);


# InstallOtherMethod(PlotAutomatonSpectraInScilab, [IsList, IsInt, IsInt, IsInt],
# function(list, iter_num, round, stacksize)
#   local mats, i, j,
#   temp_dir, temp_file, temp_file_name, sci_temp_file, sci_temp_file_name,
#   plot_spectra_func_file, exec_string;
#
#   plot_spectra_func_file := "/home/muntyan/math/automata/scilab/plot_spectra.sci";
#
#   ## TODO: input checking
#
#   mats := PermMatrices(list, iter_num);
#
#   temp_dir := DirectoryTemporary();
#   temp_file_name := Filename(temp_dir, "pass");
#   temp_file := OutputTextFile(temp_file_name, false);
#   if temp_file = fail then
#     Error("Could not create temp file\n");
#   fi;
#
#   for i in [1..2^iter_num] do
#     for j in [1..Length(list)] do
#       AppendTo(temp_file, mats[j][i][1], "\t", mats[j][i][2], "\t");
#     od;
#     AppendTo(temp_file, "\n");
#   od;
#   CloseStream(temp_file);
#
#   sci_temp_file_name := Filename(temp_dir, "pass_sci");
#   sci_temp_file := OutputTextFile(sci_temp_file_name, false);
#   if sci_temp_file = fail then
#     Error("Could not create temp file for scilab script\n");
#   fi;
#
#   AppendTo(sci_temp_file, "getf(\"", plot_spectra_func_file, "\");\n");
#   AppendTo(sci_temp_file, "plot_spectra(\"", temp_file_name, "\", ", Length(list), ", ", iter_num, ", ", round, ", ", stacksize, ");\n");
# #  AppendTo(sci_temp_file, "exit\n");
#   CloseStream(sci_temp_file);
#
#   exec_string := Concatenation("xterm -e scilab -nw -f ", sci_temp_file_name, " > /dev/null");
#   Exec(exec_string);
# end);
#
#
# InstallMethod(PlotAutomatonSpectraInScilab, [IsList, IsInt, IsInt],
# function(list, iter_num, round)
#   PlotAutomatonSpectraInScilab(list, iter_num, round, 10000000);
# end);
#
#
# InstallOtherMethod(PlotAutomatonSpectraInScilab, [IsList, IsInt],
# function(list, iter_num)
#   PlotAutomatonSpectraInScilab(list, iter_num, 7, 10000000);
# end);
