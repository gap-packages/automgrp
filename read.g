#############################################################################
##
#W  read.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.3
##
#Y  Copyright (C) 2003 - 2016 Yevgen Muntyan, Dmytro Savchuk
##

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
ReadPkg("automgrp", "gap/groups.g");
#ReadPkg("automgrp", "gap/scilab.gi");

if IsPackageMarkedForLoading("FR", ">= 2.0.0" ) then
  ReadPkg("automgrp", "gap/convertersfr.gi");
fi;


#E
