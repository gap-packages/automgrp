#############################################################################
##
#W  tree.gi                 automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#M  TopDegreeOfTree (<obj>)
##
InstallMethod(TopDegreeOfTree, "for [IsActingOnTree]", [IsActingOnTree],
function(obj)
  local si;
  si := SphericalIndex(obj);
  if not IsEmpty(si.start) then
    return si.start[1];
  else
    return si.period[1];
  fi;
end);


#############################################################################
##
#M  DegreeOfLevel (<obj>)
##
InstallMethod(DegreeOfLevel, "for [IsActingOnTree, IsPosInt]",
              [IsActingOnTree, IsPosInt],
function(obj, k)
  return AG_DegreeOfLevelInSphericalIndex(SphericalIndex(obj), k);
end);


#############################################################################
##
#M  IsActingOnRegularTree(<obj>)
##
InstallMethod(IsActingOnRegularTree, "for [IsActingOnTree]",
              [IsActingOnTree],
function(obj)
  local si;
  si := SphericalIndex(obj);
  return IsEmpty(si.start) and Length(si.period) = 1;
end);


#############################################################################
##
#M  DegreeOfTree(<obj>)
##
InstallMethod(DegreeOfTree, "for [IsActingOnTree]",
              [IsActingOnTree],
function(obj)
  if not IsActingOnRegularTree(obj) then Error("The object ",obj," is not acting on a regular tree"); fi;
  return SphericalIndex(obj).period[1];
end);


#############################################################################
##
#M  IsActingOnBinaryTree(<obj>)
##
InstallMethod(IsActingOnBinaryTree, "for [IsActingOnTree]",
              [IsActingOnTree],
function(obj)
  return IsActingOnRegularTree(obj) and DegreeOfTree(obj) = 2;
end);


#############################################################################
##
#M  FixesLevel (<obj>, <k>)
##
##  The most stupid method - just for case.
##
InstallMethod(FixesLevel, "for [IsActingOnTree, IsPosInt]",
              [IsActingOnTree, IsPosInt],
function(obj, k)
  local lev, v;

  if HasIsSphericallyTransitive(obj) then
    if IsSphericallyTransitive(obj) then
      return false;
    fi;
  fi;

  lev := Tuples([1..DegreeOfTree(obj)], k);
  for v in lev do
    if not FixesVertex(obj, v) then
      return false;
    else
      Info(InfoAutomGrp, 3, "IsSphericallyTransitive(obj): false");
      Info(InfoAutomGrp, 3, "  obj fixes vertex", v);
      Info(InfoAutomGrp, 3, "  obj = ", obj);
      SetIsSphericallyTransitive(obj, false);
    fi;
  od;

  return true;
end);


#E
