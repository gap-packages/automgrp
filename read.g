#############################################################################
##
#W  read.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##

ReadPackage("automgrp", "gap/globals.g");
ReadPackage("automgrp", "gap/parser.g");
ReadPackage("automgrp", "gap/automaton.gi");
ReadPackage("automgrp", "gap/tree.gi");
ReadPackage("automgrp", "gap/treehom.gi");
ReadPackage("automgrp", "gap/treehomsg.gi");
ReadPackage("automgrp", "gap/treeaut.gi");
ReadPackage("automgrp", "gap/treeautgrp.gi");
ReadPackage("automgrp", "gap/autom.gi");
ReadPackage("automgrp", "gap/automfam.gi");
ReadPackage("automgrp", "gap/automgroup.gi");
ReadPackage("automgrp", "gap/automsg.gi");
ReadPackage("automgrp", "gap/listops.gi");
ReadPackage("automgrp", "gap/utils.gi");
ReadPackage("automgrp", "gap/utilsfrgrp.gi");
ReadPackage("automgrp", "gap/rws.gi");
ReadPackage("automgrp", "gap/selfs.gi");
ReadPackage("automgrp", "gap/selfsim.gi");
ReadPackage("automgrp", "gap/selfsimfam.gi");
ReadPackage("automgrp", "gap/selfsimsg.gi");
ReadPackage("automgrp", "gap/selfsimgroup.gi");
ReadPackage("automgrp", "gap/groups.g");
#ReadPackage("automgrp", "gap/scilab.gi");

if IsPackageMarkedForLoading("FR", ">= 2.0.0" ) then
  ReadPackage("automgrp", "gap/convertersfr.gi");
fi;


#E
