#############################################################################
##
#W  read.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##

if false then
  MakeReadWriteGlobal("InstallMethod");
  AG_saved_InstallMethod := InstallMethod;
  InstallMethod := function(arg)
    Print("InstallMethod: ", arg[1], "\n");
    CallFuncList(AG_saved_InstallMethod, arg);
  end;
fi;

ReadPkg("automgrp", "gap/globals.g");
ReadPkg("automgrp", "gap/parser.g");
ReadPkg("automgrp", "gap/automaton.gi");
ReadPkg("automgrp", "gap/tree.gi");
ReadPkg("automgrp", "gap/treehom.gi");
ReadPkg("automgrp", "gap/treehomsg.gi");
ReadPkg("automgrp", "gap/treeaut.gi");
ReadPkg("automgrp", "gap/treeautgrp.gi");
ReadPkg("automgrp", "gap/autom.gi");
ReadPkg("automgrp", "gap/automfam.gi");
ReadPkg("automgrp", "gap/automgroup.gi");
ReadPkg("automgrp", "gap/automsg.gi");
ReadPkg("automgrp", "gap/listops.gi");
ReadPkg("automgrp", "gap/utils.gi");
ReadPkg("automgrp", "gap/utilsfrgrp.gi");
ReadPkg("automgrp", "gap/rws.gi");
ReadPkg("automgrp", "gap/selfs.gi");
ReadPkg("automgrp", "gap/selfsim.gi");
ReadPkg("automgrp", "gap/selfsimfam.gi");
ReadPkg("automgrp", "gap/selfsimsg.gi");
ReadPkg("automgrp", "gap/selfsimgroup.gi");
ReadPkg("automgrp", "gap/data.g");
ReadPkg("automgrp", "gap/groups.g");
ReadPkg("automgrp", "gap/scilab.gi");



if IsBoundGlobal("AG_saved_InstallMethod") then
  InstallMethod := AG_saved_InstallMethod;
  MakeReadOnlyGlobal("InstallMethod");
  UnbindGlobal("AG_saved_InstallMethod");
fi;

#E
