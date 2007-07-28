#############################################################################
##
#W  globals.g               automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
##  AG_Groups
##
##  This record contains the definitions of several groups.
##
BindGlobal("AG_Groups", rec(
  GrigorchukGroup := AutomatonGroup([[1,1,()],[1,1,(1,2)],[2,4,()],[2,5,()],[1,3,()]],["1","a","b","c","d"],false),
  Basilica := AutomatonGroup([[1,1,()],[3,1,(1,2)],[2,1,()]],["1","u","v"],false),
  Lamplighter := AutomatonGroup([[1,2,(1,2)],[1,2,()]],["a","b"],false),
  AddingMachine := AutomatonGroup([[1,1,()],[1,2,(1,2)]],["1","t"],false),
  AleshinGroup := AutomatonGroup([[2,3,(1,2)],[3,2,(1,2)],[1,1,()]],["a","b","c"],false),
  Bellaterra := AutomatonGroup([[3,3,(1,2)],[1,2,()],[2,1,()]],["a","b","c"],false),
  InfiniteDihedral := AutomatonGroup([[1,1,(1,2)],[2,1,()]],["a","b"],false),
  SushchanskyGroup := AutomatonGroup("\
      A=(1,1,1)(1,2,3), A2=(1,1,1)(1,3,2), B=(r_1,q_1,A),\
      r_1=(r_2,A,1), r_2=(r_3,1,1), r_3=(r_4,1,1),\
      r_4=(r_5,A,1), r_5=(r_6,A2,1), r_6=(r_7,A,1),\
      r_7=(r_8,A,1), r_8=(r_9,A,1), r_9=(r_1,A2,1),\
      q_1=(q_2,1,1), q_2=(q_3,A,1), q_3=(q_1,A,1)",false),
  Hanoi3 := AutomatonGroup([[1,1,1,()],[2,1,1,(2,3)],[1,3,1,(1,3)],[1,1,4,(1,2)]],["1","a23","a13","a12"],false),
  Hanoi4 := AutomatonGroup([[1,1,1,1,()],[1,1,2,2,(1,2)],[1,3,1,3,(1,3)],[1,4,4,1,(1,4)],[5,1,1,5,(2,3)],[6,1,6,1,(2,4)],[7,7,1,1,(3,4)]],["1","a12","a13","a14","a23","a24","a34"],false),
  GuptaSidki3Group := AutomatonGroup([[1,1,1,()],[1,1,1,(1,2,3)],[1,1,1,(1,3,2)],[2,3,4,()]],["1","a","a^-1","b"],false),
  GuptaFabrikowskiGroup := AutomatonGroup([[1,1,1,()],[1,1,1,(1,2,3)],[2,1,3,()]],["1","a","b"],false),
  BartholdiGrigorchukGroup := AutomatonGroup([[1,1,1,()],[1,1,1,(1,2,3)],[2,2,3,()]],["1","a","b"],false),
  ErschlerGrigorchukGroup := AutomatonGroup([[1,1,()],[1,1,(1,2)],[2,3,()],[2,5,()],[1,4,()]],["1","a","b","c","d"],false),
  BartholdiNonunifExponGroup := AutomatonGroup([ [1,1,1,1,1,1,1,()],\
            [1,1,1,1,1,1,1,(1,5)(3,7)],[1,1,1,1,1,1,1,(2,3)(6,7)],[1,1,1,1,1,1,1,(4,6)(5,7)],\
            [5,2,1,1,1,1,1,()],[6,3,1,1,1,1,1,()],[7,4,1,1,1,1,1,()]],\
            ["1","x","y","z","x1","y1","z1"],false),
  IMG_z2plusI:=AutomatonGroup([[1,1,()],[1,1,(1,2)],[2,4,()],[3,1,()]],["1","a","b","c"],false),
  Airplane:=AutomatonGroup([[1,1,()],[1,3,(1,2)],[1,4,()],[2,1,()]],["1","a","b","c"],false),
  Rabbit:=AutomatonGroup([[1,1,()],[3,1,(1,2)],[1,4,()],[2,1,()]],["1","a","b","c"],false),
  TwoStateSemigroupOfIntermediateGrowth:=AutomatonSemigroup([[1,1,(1,2)],[2,1,Transformation([2,2])]],["f0","f1"],false),\
));


###############################################################################
##
#V  InfoAutomGrp
##
DeclareInfoClass("InfoAutomGrp");
SetInfoLevel(InfoAutomGrp, 5);


#E
