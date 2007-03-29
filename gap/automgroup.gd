#############################################################################
##
#W  automgroup.gd             automata package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsAutomGroup( <G> )
##
##  returns true if G is a group generated by elements from category
##  IsAutom
##
DeclareSynonym("IsAutomGroup", IsGroup and IsAutomCollection);
InstallTrueMethod(IsAutomataGroup, IsAutomGroup);


#############################################################################
##
#O  AutomGroup(<automaton_list>)
#O  AutomGroup(<automaton_list>, <names>)
#O  AutomGroupNoBindGlobal(<automaton_list>)
#O  AutomGroupNoBindGlobal(<automaton_list>, <names>)
##
DeclareOperation("AutomGroup", [IsList]);
DeclareOperation("AutomGroupNoBindGlobal", [IsList]);


#############################################################################
##
#A  UnderlyingAutomFamily(<G>)
##
DeclareAttribute("UnderlyingAutomFamily", IsAutomGroup);
InstallSubsetMaintenance(UnderlyingAutomFamily, IsCollection, IsCollection);


#############################################################################
##
#P  IsGroupOfAutomFamily(<G>)
##
DeclareProperty("IsGroupOfAutomFamily", IsAutomGroup);
InstallTrueMethod(IsSelfSimilar, IsGroupOfAutomFamily);


#############################################################################
##
#P  IsFractalByWords(<G>)
##
DeclareProperty("IsFractalByWords", IsAutomGroup);
InstallTrueMethod(IsFractal, IsFractalByWords);


#############################################################################
##
#A  MihaylovSystem(<G>)
##
DeclareAttribute("MihaylovSystem", IsAutomGroup, "mutable");


#############################################################################
##
#A  UnderlyingFreeSubgroup(<G>)
#A  UnderlyingFreeGenerators(<G>)
#A  UnderlyingFreeGroup(<G>)
##
DeclareAttribute("UnderlyingFreeSubgroup", IsAutomGroup, "mutable");
DeclareAttribute("UnderlyingFreeGenerators", IsAutomGroup, "mutable");
DeclareAttribute("UnderlyingFreeGroup", IsAutomGroup);


#############################################################################
##
#A  IndexInFreeGroup(<G>)
##
DeclareAttribute("IndexInFreeGroup", IsAutomGroup, "mutable");

###############################################################################
##
#A  LevelOfFaithfulAction (<G>)
##
DeclareAttribute("LevelOfFaithfulAction", IsAutomGroup and IsSelfSimilar);


###############################################################################
##
#P  IsAutomatonGroup (<G>)  'true' if generators of <G> coincide with generators
##                             of GroupOfAutomFamily(UnderlyingAutomFamily(<G>))
##                            means that the group is generated by its automaton
DeclareProperty("IsAutomatonGroup", IsAutomGroup);
InstallTrueMethod(IsGroupOfAutomFamily, IsAutomatonGroup);


###############################################################################
##
#P  IsGeneratedByAutomatonOfPolynomialGrowth(<G>)
##
##
DeclareProperty("IsGeneratedByAutomatonOfPolynomialGrowth", IsAutomatonGroup);


###############################################################################
##
#P  IsGeneratedByBoundedAutomaton(<G>)
##
##
DeclareProperty("IsGeneratedByBoundedAutomaton", IsAutomatonGroup);


###############################################################################
##
#A  PolynomialDegreeOfGrowthOfAutomaton(<G>)
##
##
DeclareAttribute("PolynomialDegreeOfGrowthOfAutomaton", IsAutomatonGroup);


#E