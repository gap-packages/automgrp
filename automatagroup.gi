#############################################################################
##
#W  automatagroup.gi           automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.automatagroup_gi :=
  "@(#)$Id$";


###############################################################################
##
#M  UseSubsetRelation(<super>, <sub>)
##
InstallMethod(UseSubsetRelation, "method for two IsAutomataGroup's",
              [IsAutomataGroup, IsAutomataGroup],
function(super, sub)
  if HasIsFreeAbelian(super) then
    if IsFreeAbelian(super) then
      if not IsTrivial(sub) then SetIsFreeAbelian(sub, true); fi;
    else
      SetIsFreeAbelian(sub, false);
    fi;
  fi;

  if HasIsFreeNonabelian(super) then
    if IsFreeNonabelian(super) then
      if not IsTrivial(sub) then SetIsFreeNonabelian(sub, true); fi;
    else
      SetIsFreeNonabelian(sub, false);
    fi;
  fi;

  if HasIsSphericallyTransitive(super) then
    if not IsSphericallyTransitive(super) then
      SetIsSphericallyTransitive(sub, false); fi; fi;

  TryNextMethod();
end);


###############################################################################
##
#M  LowerCentralSeriesOnLevelOp (<G>, <k>)
#M  PCentralSeriesOnLevelOp (<G>, <k>)
#M  JenningsSeriesOnLevelOp (<G>, <k>)
##
InstallMethod(LowerCentralSeriesOnLevelOp, "method for IsAutomataGroup",
              [IsAutomataGroup, IsPosInt],
function(G, k)
  local pgroup;
  pgroup := PermGroupOnLevel(G, k);
  return LowerCentralSeriesOfGroup(pgroup);
end);

InstallMethod(PCentralSeriesOnLevelOp, "method for IsAutomataGroup",
              [IsAutomataGroup, IsPosInt],
function(G, k)
  local pgroup;
  pgroup := PermGroupOnLevel(G, k);
  return PCentralSeries(pgroup);
end);

InstallMethod(JenningsSeriesOnLevelOp, "method for IsAutomataGroup",
              [IsAutomataGroup, IsPosInt],
function(G, k)
  local pgroup;
  pgroup := PermGroupOnLevel(G, k);
  return JenningsSeries(pgroup);
end);


###############################################################################
##
#M  LowerCentralSeriesRanksOnLevelOp (<G>, <k>)
#M  PCentralSeriesRanksOnLevelOp (<G>, <k>)
#M  JenningsSeriesRanksOnLevelOp (<G>, <k>)
##
InstallMethod(LowerCentralSeriesRanksOnLevelOp,
              "method for IsAutomataGroup",
              [IsAutomataGroup and IsActingOnBinaryTree, IsPosInt],
function(G, k)
  local series, ranks;
  series := LowerCentralSeriesOnLevel(G, k);
  return List([1..Length(series)-1],
              i -> Log2Int(Size(series[i])/Size(series[i+1])));
end);

InstallMethod(PCentralSeriesRanksOnLevelOp,
              "method for IsAutomataGroup",
              [IsAutomataGroup and IsActingOnBinaryTree, IsPosInt],
function(G, k)
  local series, ranks;
  series := PCentralSeriesOnLevel(G, k);
  return List([1..Length(series)-1],
              i -> Log2Int(Size(series[i])/Size(series[i+1])));
end);

InstallMethod(JenningsSeriesRanksOnLevelOp,
              "method for IsAutomataGroup",
              [IsAutomataGroup and IsActingOnBinaryTree, IsPosInt],
function(G, k)
  local series, ranks;
  series := JenningsSeriesOnLevel(G, k);
  return List([1..Length(series)-1],
              i -> Log2Int(Size(series[i])/Size(series[i+1])));
end);


#E
