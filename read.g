#############################################################################
##
#W  read.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##

ReadPkg("automgrp", "gap/globals.g");

ReadPkg("automgrp", "gap/automaton.gi");
ReadPkg("automgrp", "gap/tree.gi");
ReadPkg("automgrp", "gap/treehom.gi");
ReadPkg("automgrp", "gap/treehomsg.gi");
ReadPkg("automgrp", "gap/treeaut.gi");
ReadPkg("automgrp", "gap/treeautgrp.gi");
ReadPkg("automgrp", "gap/autom.gi");
ReadPkg("automgrp", "gap/automfam.gi");
ReadPkg("automgrp", "gap/automgroup.gi");
ReadPkg("automgrp", "gap/knowngroups.gi");

ReadPkg("automgrp", "gap/listops.gi");
ReadPkg("automgrp", "gap/utils.gi");
ReadPkg("automgrp", "gap/utilsfrgrp.gi");
ReadPkg("automgrp", "gap/scilab.gi");
ReadPkg("automgrp", "gap/rws.gi");

ReadPkg("automgrp", "gap/selfs.gi");
#ReadPkg("automgrp", "gap/autom32.g");


if Filename(DirectoriesLibrary("pkg/automgrp/gap"), "data.g") <> fail then
  ReadPkg("automgrp", "gap/data.g");
fi;

#E
