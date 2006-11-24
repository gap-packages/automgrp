#############################################################################
##
#W  automatonobj.gi            automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#M  Degree(<obj>)
##
InstallOtherMethod(Degree, "method for IsAutomatonObject",
                   [IsAutomatonObject],
function(obj)
  return DegreeOfTree(obj);
end);


###############################################################################
##
#M  SphericalIndex(<obj>)
##
InstallOtherMethod(SphericalIndex, [IsAutomatonObject],
function(obj)
  return rec(start := [], period := [DegreeOfTree(obj)]);
end);


#E
