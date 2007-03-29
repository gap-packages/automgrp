#############################################################################
##
#W  rws.gd                  automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


DeclareCategory("IsFARewritingSystem", IsRewritingSystem);

DeclareOperation("FARewritingSystem", [IsAutomFamily]);
DeclareOperation("FARewritingSystem", [IsPosInt]);
DeclareOperation("FARewritingSystem", [IsPosInt, IsObject]);

DeclareOperation("AddRule", [IsFARewritingSystem, IsObject]);
DeclareOperation("AddRule", [IsFARewritingSystem, IsObject, IsBool]);
DeclareOperation("AddRules", [IsFARewritingSystem, IsObject]);
DeclareOperation("AddRules", [IsFARewritingSystem, IsObject, IsBool]);
DeclareOperation("SetRwRules", [IsFARewritingSystem, IsObject]);
