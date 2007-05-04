#############################################################################
##
#W  rws.gd                  automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


DeclareCategory("IsAGRewritingSystem", IsRewritingSystem and IsBuiltFromGroup);

DeclareOperation("AGRewritingSystem", [IsPosInt]);
DeclareOperation("AGRewritingSystem", [IsPosInt, IsObject]);

DeclareOperation("AddRule", [IsAGRewritingSystem, IsObject]);
DeclareOperation("AddRule", [IsAGRewritingSystem, IsObject, IsBool]);
DeclareOperation("AddRules", [IsAGRewritingSystem, IsObject]);
DeclareOperation("AddRules", [IsAGRewritingSystem, IsObject, IsBool]);
DeclareOperation("SetRwRules", [IsAGRewritingSystem, IsObject]);

DeclareOperation("AGRewritingSystem", [IsAutomFamily]);
DeclareOperation("UseAGRewritingSystem", [IsAutomFamily, IsBool]);


#E
