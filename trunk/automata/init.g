#############################################################################
##
#W  init.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.3
##
#Y  Copyright (C) 2003 - 2016 Yevgen Muntyan, Dmytro Savchuk
##

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
#ReadPkg("automgrp", "gap/scilab.gd");

# In GAP 4.4, the function IsPackageMarkedForLoading is not available.
if not IsBound( IsPackageMarkedForLoading ) then
  IsPackageMarkedForLoading:= function( arg )
    return CallFuncList( LoadPackage, arg ) = true;
  end;
fi;

if IsPackageMarkedForLoading("FR", ">= 2.0.0" ) then
  ReadPkg("automgrp", "gap/convertersfr.gd");
fi;

#E
