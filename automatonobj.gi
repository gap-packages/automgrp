#############################################################################
##
#W  automatonobj.gi            automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.automatonobj_gi :=
  "@(#)$Id$";


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
