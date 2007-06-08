#############################################################################
##
#W  init.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##

DeclareAutoPackage("automgrp", "0.91", ReturnTrue);

if false then
  MakeReadWriteGlobal("DeclareOperation");
  AG_saved_DeclareOperation := DeclareOperation;
  DeclareOperation := function(arg)
    Print("DeclareOperation: ", arg, "\n");
    CallFuncList(AG_saved_DeclareOperation, arg);
  end;
fi;

ReadPkg("automgrp", "gap/automaton.gd");
ReadPkg("automgrp", "gap/tree.gd");
ReadPkg("automgrp", "gap/treehom.gd");
ReadPkg("automgrp", "gap/treehomsg.gd");
ReadPkg("automgrp", "gap/treeaut.gd");
ReadPkg("automgrp", "gap/treeautgrp.gd");
ReadPkg("automgrp", "gap/autom.gd");
ReadPkg("automgrp", "gap/automfam.gd");
ReadPkg("automgrp", "gap/automsg.gd");
ReadPkg("automgrp", "gap/automgroup.gd");
ReadPkg("automgrp", "gap/listops.gd");
ReadPkg("automgrp", "gap/utils.gd");
ReadPkg("automgrp", "gap/utilsfrgrp.gd");
ReadPkg("automgrp", "gap/scilab.gd");
ReadPkg("automgrp", "gap/rws.gd");
ReadPkg("automgrp", "gap/selfs.gd");

if IsBoundGlobal("AG_saved_DeclareOperation") then
  DeclareOperation := AG_saved_DeclareOperation;
  MakeReadOnlyGlobal("DeclareOperation");
  UnbindGlobal("AG_saved_DeclareOperation");
fi;

#E
