#############################################################################
##
#W  treeautobj.gi              automata package                Yevgen Muntyan
#W                                                              Dmytro Sachuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##

Revision.treeautobj_gi :=
  "@(#)$Id$";


###############################################################################
##
#M  TopDegreeOfTree(<obj>)
##
InstallMethod(TopDegreeOfTree, "method for IsTreeAutObject",
              [IsTreeAutObject],
function(obj)
  if not IsEmpty(SphericalIndex(obj).start) then
    return SphericalIndex(obj).start[1];
  else
    return SphericalIndex(obj).period[1];
  fi;
end);


###############################################################################
##
#M  DegreeOfLevel(<obj>)
##
InstallMethod(DegreeOfLevel, "DegreeOfLevel(IsTreeAutObject, IsPosInt)",
              [IsTreeAutObject, IsPosInt],
function(obj, k)
  return DegreeOfLevelInSphericalIndex(SphericalIndex(obj), k);
end);


###############################################################################
##
#M  IsActingOnHomogeneousTree(<obj>)
##
InstallMethod(IsActingOnHomogeneousTree, "method for IsTreeAutObject",
              [IsTreeAutObject],
function(obj)
  return IsEmpty(SphericalIndex(obj).start) and
          Length(SphericalIndex(obj).period) = 1;
end);


###############################################################################
##
#M  DegreeOfTree(<obj>)
##
InstallMethod(DegreeOfTree, "method for IsTreeAutObject",
              [IsTreeAutObject],
function(obj)
  if not IsActingOnHomogeneousTree(obj) then Error(); fi;
  return SphericalIndex(obj).period[1];
end);


###############################################################################
##
#M  IsActingOnBinaryTree(<obj>)
##
InstallMethod(IsActingOnBinaryTree, "method for IsTreeAutObject",
              [IsTreeAutObject],
function(obj)
  return IsActingOnHomogeneousTree(obj) and DegreeOfTree(obj) = 2;
end);


###############################################################################
##
#M  FixesLevel(<obj>, <k>)
##
##  The most stupid method - just for case.
##
InstallMethod(FixesLevel, "method for IsTreeAutObject and IsPosInt",
              [IsTreeAutObject, IsPosInt],
function(obj, k)
  local lev, v;

  if HasIsSphericallyTransitive(obj) then
    if IsSphericallyTransitive(obj) then
      return false; fi; fi;

  lev := Tuples([1..DegreeOfTree(obj)], k);
  for v in lev do
    if not FixesVertex(obj, v) then
      return false;
    else
      Info(InfoAutomata, 3, "IsSphericallyTransitive(obj): false");
      Info(InfoAutomata, 3, "  obj fixes vertex", v);
      SetIsSphericallyTransitive(obj, false);
    fi;
  od;

  return true;
end);


###############################################################################
##
#M  FixesVertex(<obj>, <v>)
##
InstallOtherMethod(FixesVertex, "method for IsAutomatonObject and IsObject",
                   [IsTreeAutObject, IsObject],
function(obj, v)
  if HasIsSphericallyTransitive(obj) then
    if IsSphericallyTransitive(obj) then
      return false; fi; fi;

  TryNextMethod();
end);


#E
