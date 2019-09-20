#############################################################################
##
#W  init.g                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##

ReadPackage("automgrp", "gap/tree.gd");
ReadPackage("automgrp", "gap/treehom.gd");
ReadPackage("automgrp", "gap/treehomsg.gd");
ReadPackage("automgrp", "gap/treeaut.gd");
ReadPackage("automgrp", "gap/treeautgrp.gd");
ReadPackage("automgrp", "gap/autom.gd");
ReadPackage("automgrp", "gap/automaton.gd");
ReadPackage("automgrp", "gap/automfam.gd");
ReadPackage("automgrp", "gap/automsg.gd");
ReadPackage("automgrp", "gap/automgroup.gd");
ReadPackage("automgrp", "gap/listops.gd");
ReadPackage("automgrp", "gap/utils.gd");
ReadPackage("automgrp", "gap/utilsfrgrp.gd");
ReadPackage("automgrp", "gap/rws.gd");
ReadPackage("automgrp", "gap/selfs.gd");
ReadPackage("automgrp", "gap/selfsim.gd");
ReadPackage("automgrp", "gap/selfsimfam.gd");
ReadPackage("automgrp", "gap/selfsimsg.gd");
ReadPackage("automgrp", "gap/selfsimgroup.gd");
#ReadPackage("automgrp", "gap/scilab.gd");

# In GAP 4.4, the function IsPackageMarkedForLoading is not available.
if not IsBound( IsPackageMarkedForLoading ) then
  IsPackageMarkedForLoading:= function( arg )
    return CallFuncList( LoadPackage, arg ) = true;
  end;
fi;

if IsPackageMarkedForLoading("FR", ">= 2.0.0" ) then
  ReadPackage("automgrp", "gap/convertersfr.gd");
fi;

#E
