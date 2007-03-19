#############################################################################
##
#W  selfs.gd             automata package                      Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#A  AutomNucleus (<G>)
##
DeclareAttribute( "AutomNucleus", IsTreeAutomorphismGroup, "mutable" );


###############################################################################
##
#A  NucleusIncludingGeneratingSet (<G>)
##
DeclareAttribute( "NucleusIncludingGeneratingSet", IsTreeAutomorphismGroup, "mutable" );


###############################################################################
##
#A  NucleusIncludingGeneratingSetAutom (<G>)
##
DeclareAttribute( "NucleusIncludingGeneratingSetAutom", IsTreeAutomorphismGroup, "mutable" );


###############################################################################
##
#A  ContractingLevel (<G>)                             Computes the level where
##                           all pairs from the nucleus contract to the nucleus
DeclareAttribute( "ContractingLevel", IsTreeAutomorphismGroup, "mutable" );


###############################################################################
##
#A  ContractingTable (<G>)         Computes the contracting table of the kernel
##
DeclareAttribute( "_ContractingTable", IsTreeAutomorphismGroup, "mutable" );
DeclareAttribute( "ContractingTable", IsTreeAutomorphismGroup, "mutable" );

###############################################################################
##
#A  UseContraction (<G>)          If 'true', the contraction algorithm for word
##                                          problem is used. By default 'false'
DeclareAttribute( "UseContraction", IsTreeAutomorphismGroup, "mutable");


###############################################################################
##
#A  MINIMIZED_AUTOMATON_LIST (<G>)       AddInversesTrack(AutomatonList(H));
##
DeclareAttribute( "MINIMIZED_AUTOMATON_LIST", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#F  CONVERT_ASSOCW_TO_LIST. . . . . . .Converts elements of AutomGroup into lists
##
DeclareGlobalFunction("CONVERT_ASSOCW_TO_LIST");


###############################################################################
##
#A  INFO_FLAG (<G>)
##
DeclareAttribute( "INFO_FLAG", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#F  ReduceWord . . . . . . . . . . . . . . . . . . . . . . .cuts 1s from the word
##
DeclareGlobalFunction("ReduceWord");


################################################################################
##
#F  ProjectWord. . . . . . . . . . . . . . . .computes the projection of the word
##                                     onto a subtree #s in a self-similar group
DeclareGlobalFunction("ProjectWord");


################################################################################
##
#F  WordActionOnFirstLevel . . . . . . . . . . . .computes the permutation of the
##          first level vertices generated by an element of a self-similar group
DeclareGlobalFunction("WordActionOnFirstLevel");


################################################################################
##
#F  WordActionOnVertex . . . . . . . . . . . . . computes the image of the vertex
##                        under the action of an element of a self-similar group
DeclareGlobalFunction("WordActionOnVertex");


################################################################################
##
#O  OrbitOfVertex . . . .Computes the first n elements of the orbit of vertex ver
##                                   under the element w of self-similat group G
DeclareOperation("OrbitOfVertex",[IsList,IsAutomaton]);
DeclareOperation("OrbitOfVertex",[IsList,IsAutomaton,IsCyclotomic]);


################################################################################
##
#O  PrintOrbitOfVertex . . . .Computes the first n elements of the orbit of vertex ver
##                                   under the element w of self-similat group G
DeclareOperation("PrintOrbitOfVertex",[IsList,IsAutomaton]);
DeclareOperation("PrintOrbitOfVertex",[IsList,IsAutomaton,IsCyclotomic]);


################################################################################
##
#F  IsOneWordSelfSim. . . . . . . . . . . . . . . . checks if the word is trivial
##                             in any self-similar group (exponential algorithm)
DeclareGlobalFunction("IsOneWordSelfSim");

################################################################################
##
#F  IsOneWordContr. . . . . . . . . . . . . . . . . checks if the word is trivial
##                                                          in contracting group
DeclareGlobalFunction("IsOneWordContr");


################################################################################
##
#F  IS_ONE_LIST. . . . . . . . . . . . . . . . . . . .checks if the word is trivial
##                     in any self-similar group (chooses appropriate algorithm)
DeclareGlobalFunction("IS_ONE_LIST");


################################################################################
##
#F  IS_ONE_LIST. . . . . . . . . . . . . . . . . . . .checks if the word is trivial
##                     in any self-similar group
DeclareGlobalFunction("IsOneContr");


################################################################################
##
#F  CHOOSE_AUTOMATON_LIST        chooses appropriate representation for G
##
DeclareGlobalFunction("CHOOSE_AUTOMATON_LIST");


################################################################################
##
#F  PowerOfWord. . . . . . . . . . . . . . . . . . Construct n-th power of a given word
##                                                 It is NOT sophisticated at all (Do I use it at all???)
DeclareGlobalFunction("PowerOfWord");


################################################################################
##
#O  ORDER_OF_ELEMENT. . . . . . . . . Tries to find the order of a periodic element
##                                                       Checks up to order size

DeclareOperation("ORDER_OF_ELEMENT",[IsList,IsList]);
DeclareOperation("ORDER_OF_ELEMENT",[IsList,IsList,IsCyclotomic]);



################################################################################
##
#F  GeneratorActionOnVertex. . . . . . . . . . . . . . . . Computes the action of
##                                             the generator on the fixed vertex
DeclareGlobalFunction("GeneratorActionOnVertex");





################################################################################
##
#F  NumberOfVertex. . . . . . . . . . . . . . .Computes the number (1..d^Length(w))
##                                           of a given vertex w of a d-ary tree
DeclareGlobalFunction("_NumberOfVertex");
DeclareGlobalFunction("NumberOfVertex");


################################################################################
##
#F  VertexNumber. . . . . . . . . . . . . Constructs the vertex on the n-th level
##                                               of the d-ary tree with number k
DeclareGlobalFunction("_VertexNumber");
DeclareGlobalFunction("VertexNumber");


################################################################################
##
#F  GeneratorActionOnLevel . . . . . . . . . . . . . . . . Computes the action of
##                                               the generator on the n-th level
DeclareGlobalFunction("GeneratorActionOnLevel");


################################################################################
##
#F  PermActionOnLevel            Given a permutation on <big_lev>-th level
##of <deg>-ary tree computes a permutation on <sm_lev>-th level, sm_lev<=big_lev
##
DeclareGlobalFunction("PermActionOnLevel");

################################################################################
##
#F  WordActionOnLevel . . . . . . . . . . . . . . . . . . .Computes the action of
##                                              the given word on the n-th level
DeclareGlobalFunction("WordActionOnLevel");


################################################################################
##
#F  _IsWordTransitiveOnLevel. . . . . . . . . .Returns true if element w of G acts
##                                 transitively on level lev and false otherwise
DeclareGlobalFunction("_IsWordTransitiveOnLevel");



################################################################################
##
#F  _GeneratorActionOnLevelAsMatrix. . . . . . . . . . . . . Computes the action of
##                       the generator on the n-th level as permutational matrix
DeclareGlobalFunction("_GeneratorActionOnLevelAsMatrix");
DeclareGlobalFunction("PermOnLevelAsMatrix");


################################################################################
##
#F  InvestigatePairs . . . . . . . . . . . . . . . . . . . Searches out relations
##                                               in the recurent group like ab=c
DeclareGlobalFunction("InvestigatePairs");


################################################################################
##
#F  MinimizeAutom . . . . . . . . . . . . . . . . . . .Glues equivalent states of
##                                                          noninitial automaton
DeclareGlobalFunction("MinimizeAutom");


################################################################################
##
#F  MinimizeAutomTrack  . . . . . . . . . . . . . . . .Glues equivalent states of
##   noninitial automaton and returns correspondence between old and new numbers
##  track_list_short - new generators in terms of old ones
##  track_list_long  - old generators in terms of new ones
DeclareGlobalFunction("MinimizeAutomTrack");


################################################################################
##
#F  AddInverses. . . . . . . . . . Adds to the generating set of the self-similar
##                               group inverse elements and the identity element
DeclareGlobalFunction("AddInverses");


################################################################################
##
#F  AddInversesTrack. . . . . . . .Adds to the generating set of the self-similar
##                               group inverse elements and the identity element
DeclareGlobalFunction("AddInversesTrack");


################################################################################
##
#O  FindNucleus. . . . . . . . . . . . . . . . . . . . .Tries to find the nucleus
##                                                     of the self-similar group
DeclareOperation("FindNucleus",[IsAutomatonGroup]);
DeclareOperation("FindNucleus",[IsAutomatonGroup, IsCyclotomic]);


################################################################################
##
#F  InversePerm. . . . . . . . . . . .Gives permutation on the set of generators
##                                      which pushes each element to its inverse
DeclareGlobalFunction("InversePerm");


################################################################################
##
#F  AutomPortrait. . . . . . . . . . . . . . . Finds the portrait boundary of an
##                                                element in a contracting group
DeclareGlobalFunction("_AutomPortraitMain");
DeclareGlobalFunction("AutomPortrait");
DeclareGlobalFunction("AutomPortraitBoundary");
DeclareGlobalFunction("AutomPortraitDepth");



################################################################################
##
#F  WritePortraitToFile. . . . . . . . . . .Writes portrait in a file in the form
##                                                       understandable by Maple
#DeclareGlobalFunction("WritePortraitToFile");


################################################################################
##
#F  WritePortraitsToFile. . . . . . . . . . . . .Writes portraitso of elements of
##                          a list in a file in the form understandable by Maple

#DeclareGlobalFunction("WritePortraitsToFile");


################################################################################
##
#F  AutomGroupGrowth. . . . . . . . . . . . . . . . . . . . . . . .Finds number of elements
##                                                         of the length up to n
DeclareGlobalFunction("AutomGroupGrowth");


################################################################################
##
#F  AutomGroupGrowthFast. . . . . . . . . .Computes the growth function while the number of
##               elements is not greater than n and length is not greater than m
DeclareGlobalFunction("AutomGroupGrowthFast");


################################################################################
##
#F  AutomGroupElements . . . . . . . . . . . . . . . . . . .Enumerates all elements of
##                                     a self-similar group up to a given length
DeclareGlobalFunction("AutomGroupElements");


################################################################################
##
#O  FiniteGroupId . . . . . . . . . . Computes a finite group of permutations
##    generated by a self-similar group (in case of infinite group doesn't stop)
DeclareOperation("_FiniteGroupId",[IsAutomGroup]);
DeclareOperation("_FiniteGroupId",[IsAutomGroup,IsCyclotomic]);


################################################################################
##
#F  MarkovOperator. . . . . . . . . . . . . .Computes a matrix of Markov operator
##                                related to group G on the n-th level of a tree
DeclareGlobalFunction("MarkovOperator");


################################################################################
##
#F  IsOneWordSubs. . . . . . . . . . . . Determines if the word in terms of given
##                                                         generators is trivial
DeclareGlobalFunction("IsOneWordSubs");


################################################################################
##
#F  FindRelsSubs. . . . . . . . . . . .Finds relations between given elements
##                                     stops after investigating "size" elements
##                                      or when it finds "num_of_rels" relations
DeclareOperation("FindRelsSubs",[IsList,IsList,IsAutomGroup]);
DeclareOperation("FindRelsSubs",[IsList,IsList,IsAutomGroup,IsCyclotomic]);
DeclareOperation("FindRelsSubs",[IsList,IsList,IsAutomGroup,IsCyclotomic,IsCyclotomic]);


################################################################################
##
#F  FindRelsSubsSG. . . . . . . . . . .Finds relations between given elements
##                                         in the subsemigroup generated by them
##                                     stops after investigating "size" elements
##                                     and when it finds "num_of_rels" relations
DeclareOperation("FindRelsSubsSG",[IsList,IsList,IsAutomGroup]);
DeclareOperation("FindRelsSubsSG",[IsList,IsList,IsAutomGroup,IsCyclotomic]);
DeclareOperation("FindRelsSubsSG",[IsList,IsList,IsAutomGroup,IsCyclotomic,IsCyclotomic]);


################################################################################
##
#F  FindRels . . . . . . . . . Fing relatoins in terms of the original generators
##
##
DeclareOperation("FindRels",[IsAutomGroup]);
DeclareOperation("FindRels",[IsAutomGroup,IsCyclotomic]);
DeclareOperation("FindRels",[IsAutomGroup,IsCyclotomic,IsCyclotomic]);


################################################################################
##
#O  ORDER_USING_SECTIONS     returns true if there is a section h<>1 of a
##   such that h^k has h as a section
##
DeclareOperation("ORDER_USING_SECTIONS",[IsAutom]);
DeclareOperation("ORDER_USING_SECTIONS",[IsAutom,IsCyclotomic]);




################################################################################
##
#F  SUSPICIOUS_FOR_NONCONTRACTION   returns 'true' if there is a vertex v,
##                                        such that a(v)=v, a|_v=a or a|_v=a^-1
DeclareGlobalFunction("SUSPICIOUS_FOR_NONCONTRACTION");


################################################################################
##
#F  FindGroupElement              enumerates elements of the group until it finds
##          an element g of length at most n, for which func(g)=val. Returns g
##
DeclareGlobalFunction("FindGroupElement");


################################################################################
##
#F  FindGroupElements              enumerates elements of the group of length at most n
##          and returns the list of elements g, for which func(g)=val.
##
DeclareGlobalFunction("FindGroupElements");


################################################################################
##
#F  FindElementOfInfiniteOrder
#F  FindElementsOfInfiniteOrder
##  enumerates elements of the group until it finds
##                              an element of infinite order of length at most <n>
##                              each element is investigated up to depth <depth>
DeclareGlobalFunction("FindElementOfInfiniteOrder");
DeclareGlobalFunction("FindElementsOfInfiniteOrder");

################################################################################
##
#F  IsNoncontracting             enumerates elements of the group until it finds
##                              an element of infinite order of length at most <n>
##                              which stabilizes some vertex and has itself as a
##                              section at this vertex
##                              each element is investigated up to depth <depth>
DeclareGlobalFunction("IsNoncontracting");




################################################################################
##
#F  OrdersOfGroupElementsMain . . . . . Enumerates all elements of a self-similar
##             group up to length n and tries to find their orders up to order O
##                  returns true if all the orders are finite and fail otherwise
##         in case stop=true returns fail as soon as it finds suspicious element
DeclareGlobalFunction("OrdersOfGroupElementsMain");


################################################################################
##
#F  OrdersOfGroupElements . . . . . . . Enumerates all elements of a self-similar
##             group up to length n and tries to find their orders up to order O
##                  returns true if all the orders are finite and fail otherwise
DeclareGlobalFunction("OrdersOfGroupElements");


################################################################################
##
#F  PeriodicityGuess. . . . . . . . . . Enumerates all elements of a self-similar
##             group up to length n and tries to find their orders up to order O
##                  returns true if all the orders are finite and fail otherwise
##                           returns fail as soon as it finds suspicious element
DeclareGlobalFunction("PeriodicityGuess");


################################################################################
##
#F  FindTransitiveElements . . . . . . .Finds all elements of a group G which are
##                      transitive on a level lev and have length no more than n
##                in case stop=true stops when it finds first transitive element
DeclareGlobalFunction("FindTransitiveElements");


#E
