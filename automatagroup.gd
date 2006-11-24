#############################################################################
##
#W  automatagroup.gd           automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsAutomataGroup
##
##  IsAutomataGroup is a category parent for all automata group categories.
##
DeclareCategory("IsAutomataGroup", IsAutomatonObject and IsTreeAutomorphismGroup);


###############################################################################
##
#A  AutomatonListInitialStatesGenerators (<G>)
##
##  Numbers of initial states in the AutomatonList(G).
##
DeclareAttribute( "AutomatonListInitialStatesGenerators",
                  IsAutomataGroup, "mutable" );


###############################################################################
##
#A  GeneratingAutomatonList (<G>)
##
DeclareAttribute("GeneratingAutomatonList", IsAutomataGroup, "mutable");


###############################################################################
##
#O  LowerCentralSeriesOnLevel (<G>, <k>)
#O  PCentralSeriesOnLevel (<G>, <k>)
#O  JenningsSeriesOnLevel (<G>, <k>)
#O  LowerCentralSeriesRanksOnLevel (<G>, <k>)
#O  PCentralSeriesRanksOnLevel (<G>, <k>)
#O  JenningsSeriesRanksOnLevel (<G>, <k>)
##
KeyDependentOperation("LowerCentralSeriesOnLevel",
                      IsAutomataGroup, IsPosInt, ReturnTrue);
KeyDependentOperation("PCentralSeriesOnLevel",
                      IsAutomataGroup, IsPosInt, ReturnTrue);
KeyDependentOperation("JenningsSeriesOnLevel",
                      IsAutomataGroup, IsPosInt, ReturnTrue);
KeyDependentOperation("LowerCentralSeriesRanksOnLevel",
                      IsAutomataGroup and IsActingOnBinaryTree,
                      IsPosInt, ReturnTrue);
KeyDependentOperation("PCentralSeriesRanksOnLevel",
                      IsAutomataGroup and IsActingOnBinaryTree,
                      IsPosInt, ReturnTrue);
KeyDependentOperation("JenningsSeriesRanksOnLevel",
                      IsAutomataGroup and IsActingOnBinaryTree,
                      IsPosInt, ReturnTrue);


#E
