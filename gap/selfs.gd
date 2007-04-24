#############################################################################
##
#W  selfs.gd             automata package                      Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2006 Yevgen Muntyan, Dmytro Savchuk
##


################################################################################
##
#A  AutomNucleus (<G>)
##
##  Tries to compute the "nucleus" (the minimal set that need not contain original generators)
##  of a self-similar group <G>. It uses "FindNucleus" operation
##  and behaves accordingly: if the group is not contracting
##  it will loop forever (modulo memory constraints, of course).
##  See also "NucleusIncludingGeneratingSet".
##
##  \beginexample
##  gap> AutomNucleus(Basilica);
##  [ e, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##  \endexample
##
DeclareAttribute( "AutomNucleus", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#A  NucleusIncludingGeneratingSet (<G>)
##
##  Tries to compute the generating set of the group which includes original
##  generators and the "nucleus" (the minimal set that need not contain original generators)
##  of a self-similar group <G>. It uses "FindNucleus" operation
##  and behaves accordingly: if the group is not contracting
##  it will loop forever (modulo memory constraints, of course).
##  See also "AutomNucleus".
##
##  \beginexample
##  gap> NucleusIncludingGeneratingSet(Basilica);
##  [ e, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##  \endexample
##
DeclareAttribute( "NucleusIncludingGeneratingSet", IsTreeAutomorphismGroup, "mutable" );


###############################################################################
##
#A  NucleusIncludingGeneratingSetAutom (<G>)
##
##  Computes automaton of nucleus.
##
DeclareAttribute( "NucleusIncludingGeneratingSetAutom", IsTreeAutomorphismGroup, "mutable" );


######################################################################################
##
#A  ContractingLevel (<G>)
##
##  Given a contracting group <G> with nucleus $N$, stored in
##  'NucleusIncludingGeneratingSet(<G>)' (see "NucleusIncludingGeneratingSet") computes the
##  minimal level $n$, such that for every vertex $v$ of the $n$-th
##  level and all $g, h \in N$ the section $gh|_v \in N$.<P/>
##
##  In case if it is not known whether <G> is contracting it first tries to compute
##  the nucleus. If <G> is happened to be noncontracting, it will loop forever. One can
##  also use "IsNoncontracting" or "FindNucleus" directly.
##  \beginexample
##  gap> ContractingLevel(GrigorchukGroup);
##  1
##  gap> ContractingLevel(Basilica);
##  2
##  \endexample
##
DeclareAttribute( "ContractingLevel", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#A  ContractingTable (<G>)
##
##  Given a contracting group <G> with nucleus $N$ of size $k$, stored in
##  "NucleusIncludingGeneratingSet"(<G>) computes the $k\times k$ table, whose
##  [i][j]-th entry contains decomposition of $N$[i]$N$[j] on
##  the "ContractingLevel"(<G>) level. By construction the sections of
##  $N$[i]$N$[j] on this level belong to $N$. This table is used in the
##  algorithm solving the word problem in polynomial time.
##
##  In case if it is not known whether <G> is contracting it first tries to compute
##  the nucleus. If <G> is happened to be noncontracting, it will loop forever. One can
##  also use "IsNoncontracting" or "FindNucleus" directly.
##  \beginexample
##  gap> ContractingTable(GrigorchukGroup);
##  [ [ [ e, e, () ], [ e, e, (1,2) ], [ a, c, () ], [ a, d, () ], [ e, b, () ] ],
##    [ [ e, e, (1,2) ], [ e, e, () ], [ c, a, (1,2) ], [ d, a, (1,2) ], [ b, e, (1,2) ] ],
##    [ [ a, c, () ], [ a, c, (1,2) ], [ e, e, () ], [ e, b, () ], [ a, d, () ] ],
##    [ [ a, d, () ], [ a, d, (1,2) ], [ e, b, () ], [ e, e, () ], [ a, c, () ] ],
##    [ [ e, b, () ], [ e, b, (1,2) ], [ a, d, () ], [ a, c, () ], [ e, e, () ] ] ]
##  \endexample
##
DeclareAttribute( "ContractingTable", IsTreeAutomorphismGroup, "mutable" );
DeclareAttribute( "_ContractingTable", IsTreeAutomorphismGroup, "mutable" );

################################################################################
##
#A  UseContraction (<G>)
##
##  For a contracting automaton group <G> determines whether to use the algorithm
##  of polynomial complexity solving the word problem in the group. By default
##  it is set to <true> as soon as the nucleus of the group was computed. Sometimes
##  when the nucleus is very big, the standard algorithm of exponential complexity
##  is faster for short words, but this heavily depends on the group. Therefore
##  the decision on which algorithm to use is left to the user. To use the
##  exponential algorithm one can change the value of UseContraction(G) by
##  SetUseContraction(<G>, <false>).
##
##  Below we provide an example which shows that both methods can be of use.
##  \beginexample
##  gap> G:=AutomGroup("a=(b,b)(1,2),b=(c,a),c=(a,a)");;
##  gap> IsContracting(G);
##  true
##  gap> Length(AutomNucleus(G));
##  41
##  gap> Order(a); Order(b); Order(c);
##  2
##  2
##  2
##  gap> SetUseContraction(G,true);
##  gap> H:=Group(a*b,b*c);;
##  gap> St2:=StabilizerOfLevel(H,2);time;
##  < a*b*c^-1*b^-1*c^-1*b^-2*a^-1, c^-1*b^-1*c^-1*b^-1, b^-1*a^-1*b^-1*a^-1*b^-1*a^-1*b^-1*a^-1,
##  b*c*a*b*c^-1*b^-1*a*b, a*b^2*c*b^-1*a^-1*c^-1*b^-2*a^-1*b^-1*a^-1,
##  b*c*b^-1*a^-1*c^-1*b^-2*a^-1 >
##  15723
##  gap> IsAbelian(St2);time;
##  true
##  7832
##  gap> SetUseContraction(G,false);
##  gap> H:=Group(a*b,b*c);
##  gap> St2:=StabilizerOfLevel(H,2);;time;
##  8692
##  gap> IsAbelian(St2);time;
##  true
##  216551
##  \endexample
##  Here we show that the group <G> is virtually abelian. First we check that the group
##  is contracting. Then we see that the size of the nucleus is 41. Since all of generators have
##  order 2, the subgroup $H = \langle ab,bc \rangle$ has index 2 in <G>. Now we compute
##  the stabilizer of the second level in $H$ and verify, that it is abelian by 2 methods:
##  with and without using the contraction. We see, that the time required to compute the stabilizer
##  is approximately the same in both methods, while verification of commutativity works much faster
##  with contraction.
##
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
#O  OrbitOfVertex(<v>, <g>)
##
##  Computes the first n elements of the orbit of vertex <v>
##  under the element <g> of a self-similat group G
##
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
#F  IsOneContr. . . . . . . . . . . . . . . . . . . .does something
##
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
#O  FindNucleus (<G>)
#O  FindNucleus (<G>, <max_nucl>)
##
##  Given a self-similar group <G> it tries to find its nucleus. If the group
##  is not contracting it will loop forever. When it finds the nucleus it returns
##  the triple ["NucleusIncludingGeneratingSet"(<G>), "AutomNucleus"(<G>),
##  "NucleusIncludingGeneratingSetAutom"(<G>)].
##
##  If <max_nucl> is given stops after finding <max_nucl> elements that need to be in
##  the nucleus and returns 'fail' if the nucleus was not found.
##
##  Use "IsNoncontracting" to try to show that <G> is noncontracting.
##
##  \beginexample
##  gap> FindNucleus(Basilica);
##  [ [ e, u, v, u^-1, v^-1, u^-1*v, v^-1*u ], [ e, u, v, u^-1, v^-1, u^-1*v, v^-1*u ],
##    [ [ 1, 1, () ], [ 3, 1, (1,2) ], [ 2, 1, () ], [ 1, 5, (1,2) ], [ 4, 1, () ], [ 1, 7, (1,2) ],
##      [ 6, 1, (1,2) ] ] ]
##  \endexample
##
DeclareOperation("FindNucleus",[IsAutomatonGroup]);
DeclareOperation("FindNucleus",[IsAutomatonGroup, IsCyclotomic]);


################################################################################
##
#F  InversePerm. . . . . . . . . . . .Gives permutation on the set of generators
##                                      which pushes each element to its inverse
DeclareGlobalFunction("InversePerm");


################################################################################
##
#F  AutomPortrait (<a>)
#F  AutomPortraitBoundary (<a>)
#F  AutomPortraitDepth (<a>)
##
##  "AutomPortrait"(<a>) constructs the portrait of an element <a> of a
##  contracting group $G$. The portrait of <a> is defined recursively as follows.
##  For $g$ in the nucleus of $G$ the portrait is just $[g]$. For any other
##  element $g=(g_1,g_2,...,g_d)\sigma$ the portrait of $g$ is
##  $[\sigma, "AutomPortrait"(g_1), ..., "AutomPortrait"(g_d)]$, where $d$ is
##  the degree of the tree. This structure describes a tree whose inner vertices
##  are labelled by permutations from $S_d$ and the leaves are labelled by
##  the elements of the nucleus. The contraction in $G$ guarantees that the
##  portrait of any element is finite.
##
##  The portraits may be considered as a ``normal forms''
##  of the elements of $G$, since different elements have different portraits.
##
##  One also can be interested only in the boundary of a portrait, which consists
##  of all leaves of the portrait. This boundary can be described by an ordered set of
##  pairs $[level_i, g_i]$, $i=1..r$ representing the leaves of the tree ordered from left
##  to right (where $level_i$ and $g_i$ are the level and the label if the $i$-th leaf
##  correspondingly). 'AutomPortraitBoundary (<a>)' computes this boundary. It returns a list
##  consisting of 2 components. The first one is just the degree of the tree, and the
##  second one is a list of pairs described above.
##
##  "AutomPortraitDepth"(<a>) returns the depth of the portrait, i.e. the minimal
##  level such that all sections of <a> at this level belong to the nucleus of $G$.
##
##  \beginexample
##  gap> B:=AutomGroup("a=(b,1)(1,2),b=(a,1)");
##  < a, b >
##  gap> AutomPortrait(a^3*b^-2*a);
##  [ (), [ (), [ (), [ b ], [ b ] ], [ e ] ], [ (), [ (), [ b ], [ a^-1*b ] ], [ b^-1 ] ] ]
##  gap> AutomPortrait(a^3*b^-2*a^3);
##  [ (), [ (), [ (1,2), [ (), [ (), [ b ], [ b ] ], [ e ] ], [ b ] ], [ e ] ],
##    [ (), [ (1,2), [ (), [ (), [ b ], [ b ] ], [ e ] ], [ a^-1*b ] ], [ b^-1 ] ] ]
##  gap> AutomPortraitBoundary(a^3*b^-2*a^3);
##  [ 2, [ [ 5, b ], [ 5, b ], [ 4, e ], [ 3, b ], [ 2, e ], [ 5, b ], [ 5, b ], [ 4, e ], [ 3, a^-1*b ],
##        [ 2, b^-1 ] ] ]
##  gap> AutomPortraitDepth(a^3*b^-2*a^3);
##  5
##  \endexample
##
DeclareGlobalFunction("_AutomPortraitMain");
DeclareGlobalFunction("AutomPortrait");
DeclareGlobalFunction("AutomPortraitBoundary");
DeclareGlobalFunction("AutomPortraitDepth");



# ################################################################################
# ##
# #F  WritePortraitToFile. . . . . . . . . . .Writes portrait in a file in the form
# ##                                                       understandable by Maple
# #DeclareGlobalFunction("WritePortraitToFile");


# ################################################################################
# ##
# #F  WritePortraitsToFile. . . . . . . . . . . . .Writes portraitso of elements of
# ##                          a list in a file in the form understandable by Maple
#
# #DeclareGlobalFunction("WritePortraitsToFile");


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
#F  MarkovOperator(<G>, <n>)
##
##  Computes a matrix of Markov operator related to group G on the n-th level
##  of a tree.
##
DeclareGlobalFunction("MarkovOperator");


################################################################################
##
#F  IsOneWordSubs. . . . . . . . . . . . Determines if the word in terms of given
##                                                         generators is trivial
DeclareGlobalFunction("IsOneWordSubs");


################################################################################
##
#O  FindRelsSubs(<subs_words>, <names>, <G>)
#O  FindRelsSubs(<subs_words>, <names>, <G>, <max_len>)
#O  FindRelsSubs(<subs_words>, <names>, <G>, <max_len>, <max_num_rels>)
##
##  Finds relations between given elements stops after investigating all words
##  of length up to <max_len> elements or when it finds <max_num_rels>
##  relations. If <max_len> or <max_num_rels> are not specified, they are
##  assumed to be infinity.
##
DeclareOperation("FindRelsSubs", [IsList, IsList, IsAutomGroup]);
DeclareOperation("FindRelsSubs", [IsList, IsList, IsAutomGroup, IsCyclotomic]);
DeclareOperation("FindRelsSubs", [IsList, IsList, IsAutomGroup, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#O  FindRelsSubsSG(<subs_words>, <names>, <G>)
#O  FindRelsSubsSG(<subs_words>, <names>, <G>, <max_len>)
#O  FindRelsSubsSG(<subs_words>, <names>, <G>, <max_len>, <max_num_rels>)
##
##  Finds relations between given elements in the subsemigroup generated by them.
##  Arguments have the same meaning as in "FindRelsSubs".
##
DeclareOperation("FindRelsSubsSG", [IsList, IsList, IsAutomGroup]);
DeclareOperation("FindRelsSubsSG", [IsList, IsList, IsAutomGroup, IsCyclotomic]);
DeclareOperation("FindRelsSubsSG", [IsList, IsList, IsAutomGroup, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#O  FindRels(<G>)
#O  FindRels(<G>, <max_len>)
#O  FindRels(<G>, <max_len>, <max_num_rels>)
##
##  Find relatoins in terms of the original generators. Meaning of <max_len>
##  and <max_num_rels> arguments is the same as in "FindRelsSubs".
##
##
DeclareOperation("FindRels", [IsAutomGroup]);
DeclareOperation("FindRels", [IsAutomGroup, IsCyclotomic]);
DeclareOperation("FindRels", [IsAutomGroup, IsCyclotomic, IsCyclotomic]);


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
#F  IsNoncontracting (<G>, <max_len>, <depth>)
##
##  Tries to show that the group <G> is not contracting.
##  Enumerates the elements of the group <G> up to length <max_len>
##  until it finds an element which has a section <g> of infinite order, such that
##  "ORDER_USING_SECTIONS"(<g>, <depth>) is infinity and such that <g>
##  stabilizes some vertex and has itself as a section at this vertex.
##  See also "IsContracting".
##
##  \beginexample
##  gap> G:=AutomGroup("a=(b,a)(1,2),b=(c,b)(),c=(c,a)");
##  < a, b, c >
##  gap> IsNoncontracting(G,10,10);
##  true
##  \endexample
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
