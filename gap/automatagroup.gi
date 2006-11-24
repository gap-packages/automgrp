#############################################################################
##
#W  automatagroup.gi           automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


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
