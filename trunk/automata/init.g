#############################################################################
##
#W  init.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.2.4
##
#Y  Copyright (C) 2003 - 2014 Yevgen Muntyan, Dmytro Savchuk
##

DeclareAutoPackage("automgrp", "1.2.4", ReturnTrue);

if false then
  MakeReadWriteGlobal("DeclareOperation");
  AG_saved_DeclareOperation := DeclareOperation;
  DeclareOperation := function(arg)
    Print("DeclareOperation: ", arg, "\n");
    CallFuncList(AG_saved_DeclareOperation, arg);
  end;
fi;


ReadPkg("automgrp", "gap/tree.gd");
ReadPkg("automgrp", "gap/treehom.gd");
ReadPkg("automgrp", "gap/treehomsg.gd");
ReadPkg("automgrp", "gap/treeaut.gd");
ReadPkg("automgrp", "gap/treeautgrp.gd");
ReadPkg("automgrp", "gap/autom.gd");
ReadPkg("automgrp", "gap/automaton.gd");
ReadPkg("automgrp", "gap/automfam.gd");
ReadPkg("automgrp", "gap/automsg.gd");
ReadPkg("automgrp", "gap/automgroup.gd");
ReadPkg("automgrp", "gap/listops.gd");
ReadPkg("automgrp", "gap/utils.gd");
ReadPkg("automgrp", "gap/utilsfrgrp.gd");
ReadPkg("automgrp", "gap/rws.gd");
ReadPkg("automgrp", "gap/selfs.gd");
ReadPkg("automgrp", "gap/selfsim.gd");
ReadPkg("automgrp", "gap/selfsimfam.gd");
ReadPkg("automgrp", "gap/selfsimsg.gd");
ReadPkg("automgrp", "gap/selfsimgroup.gd");
ReadPkg("automgrp", "gap/scilab.gd");


if IsBoundGlobal("AG_saved_DeclareOperation") then
  DeclareOperation := AG_saved_DeclareOperation;
  MakeReadOnlyGlobal("DeclareOperation");
  UnbindGlobal("AG_saved_DeclareOperation");
fi;

#E
