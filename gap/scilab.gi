#############################################################################
##
#W  scilab.gi               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


InstallGlobalFunction(PlotSpectraPermsInScilab,
function(perms, deg, round, stacksize, output_filename)
  local mats, i, j,
  temp_dir, temp_file, temp_file_name, sci_temp_file, sci_temp_file_name,
  plot_spectra_func_file, exec_string;

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
  PrintTo(sci_temp_file, "PlotSpectraPermsInScilab(\"",
                         temp_file_name, "\", ",
                         Length(perms), ", ", deg, ", ", round, ", ",
                         stacksize, ", \"",
                         output_filename, "\");\n");
#  PrintTo(sci_temp_file, "exit\n");
  CloseStream(sci_temp_file);

  exec_string := Concatenation("cat ", sci_temp_file_name, "; ",
                               "xterm -e scilab -nw -f ",
                               sci_temp_file_name, " &" );
  Exec(exec_string);
end);


#############################################################################
##
##  PlotSpectraInScilabAddInverses(<obj>, <level>[, <round>])
##
InstallOtherMethod(PlotSpectraInScilabAddInverses,
                   [IsTreeAutomorphismGroup, IsPosInt],
function(G, level)
  PlotSpectraInScilabAddInverses(G, level, AG_Globals.round_spectra);
end);

InstallMethod(PlotSpectraInScilabAddInverses,
              [IsTreeAutomorphismGroup, IsPosInt, IsPosInt],
function(G, level, round)
  PlotSpectraInScilabAddInverses(GeneratorsOfGroup(G), level, round);
end);

InstallOtherMethod(PlotSpectraInScilabAddInverses,
                   [IsList and IsTreeAutomorphismCollection, IsPosInt],
function(gens, level)
  PlotSpectraInScilabAddInverses(gens, level, AG_Globals.round_spectra);
end);

InstallMethod(PlotSpectraInScilabAddInverses,
              [IsList and IsTreeAutomorphismCollection, IsPosInt, IsPosInt],
function(gens, level, round)
  gens := Concatenation(gens, List(gens, g->g^-1));
  PlotSpectraInScilab(gens, level, round);
end);


#############################################################################
##
##  PlotSpectraInScilab(<list>, <level>[, <round>][, <output_file>])
##
InstallMethod(PlotSpectraInScilab,
              [IsList and IsTreeAutomorphismCollection, IsPosInt, IsPosInt],
function(gens, level, round)
  PlotSpectraPermsInScilab(List(gens, g -> PermOnLevel(g, level)),
                           DegreeOfTree(gens[1])^level, round,
                           AG_Globals.scilab_stacksize, "");
end);

InstallOtherMethod(PlotSpectraInScilab,
                   [IsList and IsTreeAutomorphismCollection, IsPosInt, IsPosInt, IsString],
function(gens, level, round, output_file)
  PlotSpectraPermsInScilab(List(gens, g -> PermOnLevel(g, level)),
                           DegreeOfTree(gens[1])^level, round,
                           AG_Globals.scilab_stacksize, output_file);
end);

InstallOtherMethod(PlotSpectraInScilab,
                   [IsList and IsTreeAutomorphismCollection, IsPosInt],
function(gens, level)
  PlotSpectraInScilab(gens, level, AG_Globals.round_spectra);
end);

InstallOtherMethod(PlotSpectraInScilab,
                   [IsList and IsTreeAutomorphismCollection, IsPosInt, IsString],
function(gens, level, output_file)
  PlotSpectraInScilab(gens, level, AG_Globals.round_spectra, output_file);
end);

InstallMethod(PlotSpectraInScilab,
              [IsTreeAutomorphismGroup, IsPosInt, IsPosInt],
function(G, level, round)
  PlotSpectraInScilab(GeneratorsOfGroup(G), level, round);
end);

InstallOtherMethod(PlotSpectraInScilab,
                   [IsTreeAutomorphismGroup, IsPosInt, IsPosInt, IsString],
function(G, level, round, output_file)
  PlotSpectraInScilab(GeneratorsOfGroup(G), level, round, output_file);
end);

InstallOtherMethod(PlotSpectraInScilab,
                   [IsTreeAutomorphismGroup, IsPosInt],
function(G, level)
  PlotSpectraInScilab(G, level, AG_Globals.round_spectra);
end);

InstallOtherMethod(PlotSpectraInScilab,
                   [IsTreeAutomorphismGroup, IsPosInt, IsString],
function(G, level, output_file)
  PlotSpectraInScilab(G, level, AG_Globals.round_spectra, output_file);
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
