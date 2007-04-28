#############################################################################
##
#W  scilab.gi               automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#F  PlotSpectraPermsInScilab(<perms>, <perm_deg>, <round>, <stacksize>)
##
InstallGlobalFunction(PlotSpectraPermsInScilab,
function(perms, deg, round, stacksize)
  local mats, i, j,
  temp_dir, temp_file, temp_file_name, sci_temp_file, sci_temp_file_name,
  plot_spectra_func_file, exec_string;

  plot_spectra_func_file := Filename(DirectoriesPackageLibrary("automata","scilab"),
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

  AppendTo(sci_temp_file, "getf(\"", plot_spectra_func_file, "\");\n");
  AppendTo(sci_temp_file, "PlotSpectraPermsInScilab(\"",
                          temp_file_name, "\", ",
                          Length(perms), ", ", deg, ", ", round, ", ",
                          stacksize, ");\n");
#  AppendTo(sci_temp_file, "exit\n");
  CloseStream(sci_temp_file);

  exec_string := Concatenation( "xterm -e scilab -nw -f ",
                                sci_temp_file_name, " &" );
  Exec(exec_string);
end);


#############################################################################
##
#M  PlotSpectraInScilabAddInverses(<G>, <level>)
##
InstallOtherMethod(PlotSpectraInScilabAddInverses,
                   [IsTreeAutomorphismGroup, IsPosInt],
function(G, lev)
  PlotSpectraInScilabAddInverses(G, lev, AutomataParameters.round_spectra);
end);


#############################################################################
##
#M  PlotSpectraInScilabAddInverses(<G>, <level>, <round>)
##
InstallMethod(PlotSpectraInScilabAddInverses,
              [IsTreeAutomorphismGroup, IsPosInt, IsPosInt],
function(G, lev, round)
  local gens;
  gens := Filtered(List(GeneratorsOfGroup(G), g -> PermOnLevel(g, lev)),
                    p -> not IsOne(p));
  PlotSpectraInScilabAddInverses(gens, DegreeOfTree(G)^lev, round);
end);


#############################################################################
##
#M  PlotSpectraInScilabAddInverses(<perm_list>, <perm_deg>, <round>)
##
InstallMethod(PlotSpectraInScilabAddInverses,
              [IsList and IsPermCollection, IsPosInt, IsPosInt],
function(perms, perm_deg, round)
  PlotSpectraPermsInScilab( Concatenation(perms, List(perms, p -> p^-1)),
                            perm_deg, round,
                            AutomataParameters.scilab_stacksize );
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




