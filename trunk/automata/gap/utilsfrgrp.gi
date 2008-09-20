#############################################################################
##
#W  utilsfrgrp.gi              automgrp package                Yevgen Muntyan
##                                                             Dmytro Savchuk
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#M  <F1> = <F2>
##  TODO:RELEASE Remove it if possible (i.e. if our code doesn't use it)
##
InstallMethod(\=, "method for two subgroups of free group",
              IsIdenticalObj, [IsFreeGroup, IsFreeGroup],
function(F1, F2)
  return FreeGeneratorsOfGroup(F1) = FreeGeneratorsOfGroup(F2);
end);


#############################################################################
##
#M  <w> in <F2>
##  TODO:RELEASE Remove it if possible (i.e. if our code doesn't use it)
##
InstallMethod(\in, "method for element and subgroup of free group",
              [IsAssocWord, IsFreeGroup],
function(w, F)
  local gens;

  if IsOne(w) then return true;
  elif IsTrivial(F) then return false; fi;

  gens := FreeGeneratorsOfGroup(F);
  return FreeGeneratorsOfGroup(Group(Concatenation(gens, [w]))) = gens;
end);


#############################################################################
##
#M  IsSubset(<F1>, <F2>)
##  F1 > F2
##  TODO:RELEASE Remove it if possible (i.e. if our code doesn't use it)
##
InstallMethod(IsSubset, "method for two subgroups of free group",
              IsIdenticalObj, [IsFreeGroup, IsFreeGroup],
function(F1, F2)
  return ForAll(GeneratorsOfGroup(F2), g -> g in F1);
end);


#E
