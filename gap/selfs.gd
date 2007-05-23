#############################################################################
##
#W  selfs.gd             automgrp package                      Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2007 Yevgen Muntyan, Dmytro Savchuk
##


################################################################################
##
#A  GroupNucleus (<G>)
##
##  Tries to compute the <nucleus> (the minimal set that need not contain original
##  generators) of a self-similar group <G>. It uses `FindNucleus' (see "FindNucleus")
##  operation and behaves accordingly: if the group is not contracting it will loop
##  forever. See also "NucleusIncludingGeneratingSet".
##
##  \beginexample
##  gap> GroupNucleus(Basilica);
##  [ e, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##  \endexample
##
DeclareAttribute( "GroupNucleus", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#A  NucleusIncludingGeneratingSet (<G>)
##
##  Tries to compute the generating set of the group which includes original
##  generators and the <nucleus> (the minimal set that need not contain original
##  generators) of a self-similar group <G>. It uses `FindNucleus' operation
##  and behaves accordingly: if the group is not contracting
##  it will loop forever (modulo memory constraints, of course).
##  See also "GroupNucleus".
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
##  `NucleusIncludingGeneratingSet'(<G>) (see "NucleusIncludingGeneratingSet") computes the
##  minimal level $n$, such that for every vertex $v$ of the $n$-th
##  level and all $g, h \in N$ the section $gh|_v \in N$.
##
##  In case if it is not known whether <G> is contracting it first tries to compute
##  the nucleus. If <G> is happened to be noncontracting, it will loop forever. One can
##  also use `IsNoncontracting' (see "IsNoncontracting") or `FindNucleus' (see
##  "FindNucleus") directly.
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
##  `NucleusIncludingGeneratingSet'(<G>)~(see "NucleusIncludingGeneratingSet")
##  computes the $k\times k$ table, whose
##  [i][j]-th entry contains decomposition of $N$[i]$N$[j] on
##  the `ContractingLevel'(<G>) level~(see "ContractingLevel"). By construction the sections of
##  $N$[i]$N$[j] on this level belong to $N$. This table is used in the
##  algorithm solving the word problem in polynomial time.
##
##  In case if it is not known whether <G> is contracting it first tries to compute
##  the nucleus. If <G> is happened to be noncontracting, it will loop forever. One can
##  also use `IsNoncontracting' (see "IsNoncontracting") or `FindNucleus' (see
##  "FindNucleus") directly.
##  \beginexample
##  gap> ContractingTable(GrigorchukGroup);
##  [ [ (1, 1), (1, 1)(1,2), (a, c), (a, d), (1, b) ],
##    [ (1, 1)(1,2), (1, 1), (c, a)(1,2), (d, a)(1,2), (b, 1)(1,2) ],
##    [ (a, c), (a, c)(1,2), (1, 1), (1, b), (a, d) ],
##    [ (a, d), (a, d)(1,2), (1, b), (1, 1), (a, c) ],
##    [ (1, b), (1, b)(1,2), (a, d), (a, c), (1, 1) ] ]
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
##  exponential algorithm one can change the value of `UseContraction'(<G>) by
##  `SetUseContraction'(<G>, <false>).
##
##  Below we provide an example which shows that both methods can be of use.
##  \beginexample
##  gap> G:=AutomGroup("a=(b,b)(1,2),b=(c,a),c=(a,a)");;
##  gap> IsContracting(G);
##  true
##  gap> Length(GroupNucleus(G));
##  41
##  gap> Order(a); Order(b); Order(c);
##  2
##  2
##  2
##  gap> SetUseContraction(G,true);
##  gap> H:=Group(a*b,b*c);;
##  gap> St2:=StabilizerOfLevel(H,2);time;
##  < b*c*b*c, b^-1*a^-1*b*c*b^-1*a^-1*c^-1*b^-1, a*b*a*b*a*b*a*b, a*b^2*c*a*b*c^-1*b^
##  -1, a*b^2*c*b*c*b^-1*a^-1, b*c*a*b^2*c*a*b, b*c*a*b*a*b*c^-1*b^-2*a^-1*b^-1*a^
##  -1, a*b*a*b^2*c*a*b*c^-1*b^-2*a^-1, a*b*a*b^2*c*b*c*b^-1*a^-1*b^-1*a^-1 >
##  741
##  gap> IsAbelian(St2);time;
##  true
##  11977
##  gap> SetUseContraction(G,false);
##  gap> H:=Group(a*b,b*c);
##  gap> St2:=StabilizerOfLevel(H,2);;time;
##  240
##  gap> IsAbelian(St2);time;
##  true
##  542060
##  \endexample
##  Here we show that the group <G> is virtually abelian. First we check that the group
##  is contracting. Then we see that the size of the nucleus is 41. Since all of generators have
##  order 2, the subgroup $H = \langle ab,bc \rangle$ has index 2 in <G>. Now we compute
##  the stabilizer of the second level in $H$ and verify, that it is abelian by 2 methods:
##  with and without using the contraction. We see, that the time required to compute the stabilizer
##  is approximately the same in both methods, while verification of commutativity works much faster
##  with contraction. Here it was enough to consider the first level stabilizer, but the difference
##  in performance of two methods is better seen for the second level stabilizer.
##
DeclareAttribute( "UseContraction", IsTreeAutomorphismGroup, "mutable");



################################################################################
##
#A  MINIMIZED_AUTOMATON_LIST ( <G> )
##
##  Returns a minimized automaton, which contains generators of group <G> and their inverses
##
DeclareAttribute( "MINIMIZED_AUTOMATON_LIST", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#F  CONVERT_ASSOCW_TO_LIST( <w> )
##
##  Converts elements of AutomGroup into lists.
##
DeclareGlobalFunction("CONVERT_ASSOCW_TO_LIST");


###############################################################################
##
#A  INFO_FLAG (<G>)
##
DeclareAttribute( "INFO_FLAG", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#F  ReduceWord( <v> )
##
##  Cuts 1s from the word.
##
DeclareGlobalFunction("ReduceWord");


################################################################################
##
#F  ProjectWord( <w>, <s>, <G> )
##
##  Computes the projection of the word <w> onto a subtree #<s> in a self-similar
##  group <G>.
##
DeclareGlobalFunction("ProjectWord");


################################################################################
##
#F  WordActionOnFirstLevel( <w>, <G> )
##
##  Computes the permutation of the first level vertices generated by an element <w>
##  of a self-similar group <G>.
##
DeclareGlobalFunction("WordActionOnFirstLevel");


################################################################################
##
#F  WordActionOnVertex (<w>, <ver>, <G> )
##
##  Computes the image of the vertex <ver> under the action of an element <w> of a
##  self-similar group <G>.
##
DeclareGlobalFunction("WordActionOnVertex");


######################################################################################
##
#O  OrbitOfVertex (<ver>, <g>[, <n>])
##
##  Returns the list of vertices in the orbit of vertex <ver> under the
##  action of a semigroup generated by an automorphism <g>.
##  If <n> is specified, it returns only first <n> elements of the orbit.
##  Vertices are defined either as lists with entries from `[1..d]', or as
##  strings containing characters `1,...,d', where `d'
##  is the degree of the tree.
##  \beginexample
##  gap> g:=AutomGroup("t=(1,t)(1,2)");;
##  gap> OrbitOfVertex([1,1,1],t);
##  [ [ 1, 1, 1 ], [ 2, 1, 1 ], [ 1, 2, 1 ], [ 2, 2, 1 ], [ 1, 1, 2 ], [ 2, 1, 2 ],
##  [ 1, 2, 2 ], [ 2, 2, 2 ] ]
##  gap> OrbitOfVertex("111111111111",t,6);
##  [ [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
##  [ 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
##  [ 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ]
##  \endexample
##
DeclareOperation("OrbitOfVertex",[IsList, IsTreeHomomorphism]);
DeclareOperation("OrbitOfVertex",[IsList, IsTreeHomomorphism, IsCyclotomic]);


######################################################################################
##
#O  PrintOrbitOfVertex (<ver>, <g>[, <n>])
##
##  Prints the orbit of vertex <A>ver</A> under the action of a semigroup generated by
##  <g>. Each vertex is printed as a string containing characters 1, ..., d, where `d'
##  is the degree of the tree. In case of binary tree the symbols `` '' and ```x'''
##  are used to represent `1' and `2'.
##  If <n> is specified only first <n> elements of the orbit are printed.
##  Vertices are defined either as lists with entries from `[1..d]', or as
##  strings.
##  \beginexample
##  gap> g:=AutomGroup("a=(b,a)(1,2),b=(b,a)");
##  < a, b >
##  gap> PrintOrbitOfVertex("2222222222222222222222222222222",a*b^-2,6);
##  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
##
##  x x x x x x x x x x x x x x x x
##   xx  xx  xx  xx  xx  xx  xx  xx
##  xxx xxx xxx xxx xxx xxx xxx xxx
##     xxxx    xxxx    xxxx    xxxx
##  gap> h:=AutomGroup("a=(b,1,1)(1,2,3),b=(a,b,a)(1,2)");;
##  gap> PrintOrbitOfVertex([1,2,1],b^2);
##  121
##  132
##  123
##  131
##  122
##  133
##  \endexample
##
DeclareOperation("PrintOrbitOfVertex", [IsList, IsTreeHomomorphism]);
DeclareOperation("PrintOrbitOfVertex", [IsList, IsTreeHomomorphism, IsCyclotomic]);


################################################################################
##
#F  IsOneWordSelfSim ( <word>, <G> )
##
##  Checks if the word <word> is trivial in a self-similar group <G>.
##
DeclareGlobalFunction("IsOneWordSelfSim");


################################################################################
##
#F  IsOneWordContr ( <word>, <G> )
##
##  Checks if the word <word> is trivial in a contracting group <G>.
##
DeclareGlobalFunction("IsOneWordContr");


################################################################################
##
#F  IS_ONE_LIST ( <w>, <G> )
##
##  Checks if the word <w> is trivial in a self-similar group <G> (chooses appropriate
##  algorithm).
##
DeclareGlobalFunction("IS_ONE_LIST");


###############################################################################
##
#F  IsOneContr ( <a> )
##
##  Returns `true' if <a> is trivial automorphism and `false' otherwise. Works for
##  contracting groups only. Uses polynomial time algorithm.
##
DeclareGlobalFunction("IsOneContr");


###############################################################################
##
#F  CHOOSE_AUTOMATON_LIST( <G> )
##
##  Chooses appropriate representation for <G>.
##

DeclareGlobalFunction("CHOOSE_AUTOMATON_LIST");


################################################################################
##
#O  ORDER_OF_ELEMENT ( <a>, <G>, <max_order> )
##
##  Tries to find the order of an element <a>. Checks up to order size <max_order>
##
DeclareOperation("ORDER_OF_ELEMENT",[IsList,IsList]);
DeclareOperation("ORDER_OF_ELEMENT",[IsList,IsList,IsCyclotomic]);



################################################################################
##
#F  GeneratorActionOnVertex( <G>, <g>, <w> )
##
##  Computes the action of the generator <g> of group <G> on the vertex <w>.
##
DeclareGlobalFunction("GeneratorActionOnVertex");


######################################################################################
##
#F  NumberOfVertex (<ver>, <deg>)
##
##  Let <ver> belong to $n$-th level of the <deg>-ary tree. One can
##  naturally enumerate all the vertices of this level by numbers $1,\ldots,<deg>^{<n>}$.
##  This function returns the number, which corresponds to the vertex <ver>.
##  \beginexample
##  gap> NumberOfVertex([1,2,1,2],2);
##  6
##  gap> NumberOfVertex("333",3);
##  27
##  \endexample
##
DeclareGlobalFunction("AG_NumberOfVertex");  # over alphabet [0,...,d-1]
DeclareGlobalFunction("NumberOfVertex");     # over alphabet [1,...,d]


######################################################################################
##
#F  VertexNumber (<num>, <lev>, <deg>)
##
##  One can naturally enumerate all the vertices of the <lev>-th level of
##  the <deg>-ary tree by numbers $1,\ldots,<deg>^{<n>}$.
##  This function returns the vertex of this level, which has number <num>.
##  \beginexample
##  gap> VertexNumber(1,3,2);
##  [ 1, 1, 1 ]
##  gap> VertexNumber(4,4,3);
##  [ 1, 1, 2, 1 ]
##  \endexample
##
DeclareGlobalFunction("AG_VertexNumber"); # over alphabet [0,...,d-1]
DeclareGlobalFunction("VertexNumber");    # over alphabet [1,...,d]


################################################################################
##
#F  GeneratorActionOnLevel( <G>, <g>, <n> )
##
##  Computes the action of the element <g> of group <G> at the <n>-th level.
##
DeclareGlobalFunction("GeneratorActionOnLevel");


######################################################################################
##
#F  PermActionOnLevel( <perm>, <big_lev>, <sm_lev>, <deg> )
##
##  Given a permutation <perm> on the <big_lev>-th level of the tree of degree
##  <deg> returns the permutation induced by <perm> on a smaller level
##  <sm_lev>.
##  \beginexample
##  gap> PermActionOnLevel((1,4,2,3),2,1,2);
##  (1,2)
##  gap> PermActionOnLevel((1,13,5,9,3,15,7,11)(2,14,6,10,4,16,8,12),4,2,2);
##  (1,4,2,3)
##  \endexample
##
DeclareGlobalFunction("PermActionOnLevel");


################################################################################
##
#F  WordActionOnLevel( <G>, <w>, <lev> )
##
##  Computes the action of word <w> in group <G> on the <lev>-th level.
##
DeclareGlobalFunction("WordActionOnLevel");


################################################################################
##
#F  AG_IsWordTransitiveOnLevel ( <G>, <w>, <lev> )
##
##  Returns `true' if element <w> of <G> acts
##  transitively on level <lev> and `false' otherwise
##
DeclareGlobalFunction("AG_IsWordTransitiveOnLevel");


################################################################################
##
#F  AG_GeneratorActionOnLevelAsMatrix ( <G>, <g>, <lev> )
##
##  Computes the action of the generator on the n-th level as permutational matrix
##
DeclareGlobalFunction("AG_GeneratorActionOnLevelAsMatrix");


################################################################################
##
#F  PermOnLevelAsMatrix ( <g>, <lev> )
##
##  Computes the action of the element <g> on the <lev>-th level as a permutational matrix.
##  \beginexample
##  gap> PermOnLevelAsMatrix(a*b,2);
##  [ [ 0, 0, 0, 1 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], [ 1, 0, 0, 0 ] ]
##  \endexample
DeclareGlobalFunction("PermOnLevelAsMatrix");


################################################################################
##
##  InvestigatePairs ( <G> )
##
##  Finds all relations of the form $ab=c$, where $a,b,c$ are the states of automaton <G>
##
DeclareGlobalFunction("InvestigatePairs");


################################################################################
##
#F  AG_MinimizationOfAutomatonList ( <G> )
##
##  Returns an automaton obtained from automaton <G> by minimization.
##
DeclareGlobalFunction("AG_MinimizationOfAutomatonList");


################################################################################
##
#F  AG_MinimizationOfAutomatonListTrack ( <G> )
##
##  Finds an automaton `G_new' obtained from automaton <G> by minimization. Returns the list
##  `[G_new,track_s,track_l]', where
##  `track_s' is how new states are expressed in terms of the old ones, and
##  `track_l' is how old states are expressed in terms of the new ones.
##
DeclareGlobalFunction("AG_MinimizationOfAutomatonListTrack");


################################################################################
##
#F  AG_AddInversesList ( <G> )
##
##  Returns an automaton obtained from automaton <G> by adding inverse elements and
##  the identity element, and minimizing the result.
##
DeclareGlobalFunction("AG_AddInversesList");


################################################################################
##
#F  AG_AddInversesListTrack ( <G> )
##
##  Finds an automaton `G_new' obtained from automaton <G> by adding inverse elements and
##  the identity element, and minimizing the result. Returns the list
##  `[G_new,track_s,track_l]', where
##  `track_s' is how new states are expressed in terms of the old ones, and
##  `track_l' is how old states are expressed in terms of the new ones.
##
DeclareGlobalFunction("AG_AddInversesListTrack");


################################################################################
##
#O  FindNucleus (<G>[, <max_nucl>])
##
##  Given a self-similar group <G> it tries to find its nucleus. If the group
##  is not contracting it will loop forever. When it finds the nucleus it returns
##  the triple [`NucleusIncludingGeneratingSet'(<G>), `GroupNucleus'(<G>),
##  `NucleusIncludingGeneratingSetAutom'(<G>)] (see "NucleusIncludingGeneratingSet",
##  "GroupNucleus", "NucleusIncludingGeneratingSetAutom").
##
##  If <max_nucl> is given stops after finding <max_nucl> elements that need to be in
##  the nucleus and returns `fail' if the nucleus was not found.
##
##  Use `IsNoncontracting'~(see "IsNoncontracting") to try to show that <G> is
##  noncontracting.
##
##  \beginexample
##  gap> FindNucleus(Basilica);
##  [ [ e, u, v, u^-1, v^-1, u^-1*v, v^-1*u ], [ e, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##    , [ [ 1, 1, () ], [ 3, 1, (1,2) ], [ 2, 1, () ], [ 1, 5, (1,2) ],
##      [ 4, 1, () ], [ 1, 7, (1,2) ], [ 6, 1, (1,2) ] ] ]
##  \endexample
##
DeclareOperation("FindNucleus",[IsAutomatonGroup]);
DeclareOperation("FindNucleus",[IsAutomatonGroup, IsCyclotomic]);


################################################################################
##
##  InversePerm ( <G> )
##
##  returns the permutation on the set of generators of <G>
##  which pushes each element to its inverse
##
DeclareGlobalFunction("InversePerm");


################################################################################
##
#F  AutomPortrait ( <a> )
#F  AutomPortraitBoundary ( <a> )
#F  AutomPortraitDepth ( <a> )
##
##  Constructs the portrait of an element <a> of a
##  contracting group $G$. The portrait of <a> is defined recursively as follows.
##  For $g$ in the nucleus of $G$ the portrait is just $[g]$. For any other
##  element $g=(g_1,g_2,...,g_d)\sigma$ the portrait of $g$ is
##  $[\sigma, `AutomPortrait'(g_1), ..., `AutomPortrait'(g_d)]$, where $d$ is
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
##  pairs $[level_i, g_i]$, $i=1,\ldots,r$ representing the leaves of the tree ordered from left
##  to right (where $level_i$ and $g_i$ are the level and the label of the $i$-th leaf
##  correspondingly). `AutomPortraitBoundary'(<a>) computes this boundary. It returns a list
##  consisting of 2 components. The first one is just the degree of the tree, and the
##  second one is a list of pairs described above.
##
##  `AutomPortraitDepth'( <a> ) returns the depth of the portrait, i.e. the minimal
##  level such that all sections of <a> at this level belong to the nucleus of $G$.
##
##  \beginexample
##  gap> B:=AutomGroup("a=(b,1)(1,2),b=(a,1)");
##  < a, b >
##  gap> AutomPortrait(a^3*b^-2*a);
##  [ (), [ (), [ (), [ b ], [ b ] ], [ 1 ] ],
##    [ (), [ (), [ b ], [ a^-1*b ] ], [ b^-1 ] ] ]
##  gap> AutomPortrait(a^3*b^-2*a^3);
##  [ (), [ (), [ (1,2), [ (), [ (), [ b ], [ b ] ], [ 1 ] ], [ b ] ], [ 1 ] ],
##    [ (), [ (1,2), [ (), [ (), [ b ], [ b ] ], [ 1 ] ], [ a^-1*b ] ], [ b^-1 ] ] ]
##  gap> AutomPortraitBoundary(a^3*b^-2*a^3);
##  [ 2, [ [ 5, b ], [ 5, b ], [ 4, 1 ], [ 3, b ], [ 2, 1 ], [ 5, b ], [ 5, b ],
##        [ 4, 1 ], [ 3, a^-1*b ], [ 2, b^-1 ] ] ]
##  gap> AutomPortraitDepth(a^3*b^-2*a^3);
##  5
##  \endexample
##
DeclareGlobalFunction("AG_AutomPortraitMain");
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
#F AutomGroupGrowth
##
##  Computes the first <max_len> values of the growth function of a group <G>
##
DeclareGlobalFunction("AutomGroupGrowth");


################################################################################
##
#F  AutomGroupGrowthFast ( <G>, <max_num>, <max_len> )
##
##  Computes the growth function of the group <G> while the number of elements
##  is not greater than <max_num> and length is not greater than <max_len>.
##
DeclareGlobalFunction("AutomGroupGrowthFast");


################################################################################
##
#F  AutomGroupElements ( <G>, <max_len> )
##
##  Enumerates all elements of a self-similar group <G> up to length <max_len>
##
DeclareGlobalFunction("AutomGroupElements");


################################################################################
##
#O  AG_FiniteGroupId ( <G>, <max_size> )
##
##  Computes a finite group of permutations
##  generated by a self-similar group <G> (in case of infinite group doesn't stop).
##  If <max_size> is given and the group contains more than <max_size> elements
##  returns `fail'
##
DeclareOperation("AG_FiniteGroupId",[IsAutomGroup]);
DeclareOperation("AG_FiniteGroupId",[IsAutomGroup,IsCyclotomic]);


################################################################################
##
#F  MarkovOperator ( <G>, <lev> )
##
##  Computes the matrix of Markov operator related to group <G> on the <lev>-th level
##  of a tree.
##
DeclareGlobalFunction("MarkovOperator");


################################################################################
##
##  AG_IsOneWordSubs( <w>, <subs>, <G> )
##
##  Determines if the word <w> given as list of given generators is trivial in <G>
##
DeclareGlobalFunction("AG_IsOneWordSubs");


################################################################################
##
#O  FindRelationsSubs(<subs_words>, [<names>, <max_len>, <max_num_rels>])
##
##  Finds relations between the given elements, stops after investigating all words
##  of length up to <max_len> elements or when it finds <max_num_rels>
##  relations. The optional argument <names> is a list of names of generators of the same length 
##  as <subs_words>. If this argument is given the relations are given in terms of these names.
##  Otherwise they are given in terms of letters constituting elements of <subs_words>.
##  If <max_len> or <max_num_rels> are not specified, they are
##  assumed to be `infinity'.
##  \beginexample
##  gap> B:=AutomGroup("u=(v,1)(1,2),v=(u,1)");;
##  gap> FindRelationsSubs([u*v^-1,v*u],["x","y"],5);
##  #I  y*x^2*y*x^-1*y^-2*x^-1
##  [ y*x^2*y*x^-1*y^-2*x^-1 ]
##  gap> FindRelationsSubs([u*v^-1,v*u],5);
##  #I  v*u^2*v^-1*u^2*v*u^-2*v^-1*u^-2
##  [ v*u^2*v^-1*u^2*v*u^-2*v^-1*u^-2 ]
##  \endexample
##
DeclareOperation("FindRelationsSubs", [IsList, IsList]);
DeclareOperation("FindRelationsSubs", [IsList, IsList, IsCyclotomic]);
DeclareOperation("FindRelationsSubs", [IsList, IsList, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindRelationsSubs", [IsList]);
DeclareOperation("FindRelationsSubs", [IsList, IsCyclotomic]);
DeclareOperation("FindRelationsSubs", [IsList, IsCyclotomic, IsCyclotomic]);



################################################################################
##
#O  FindRelationsSubsSG(<subs_words>, <names>[, <max_len>[, <max_num_rels>]])
##
##  Finds relations between given elements in the subsemigroup generated by them.
##  Arguments have the same meaning as in `FindRelationsSubs'~("FindRelationsSubs").
##  It returns the list of pairs of equal words.
##  \beginexample
##  gap> FindRelationsSubsSG([u*v^-1,v*u],["x","y"],6);
##  #I  y*x^2*y=x*y^2*x
##  #I  y*x^3*y^2=x^2*y^3*x
##  #I  y^2*x^3*y=x*y^3*x^2
##  [ [ y*x^2*y, x*y^2*x ], [ y*x^3*y^2, x^2*y^3*x ], [ y^2*x^3*y, x*y^3*x^2 ] ]
##  gap> FindRelationsSubsSG([u*v^-1,v*u],6);
##  #I  v*u^2*v^-1*u^2=u^2*v*u^2*v^-1
##  #I  v*u^2*v^-1*u*v^-1*u^2*v*u=u*v^-1*u^2*v*u*v*u^2*v^-1
##  #I  v*u*v*u^2*v^-1*u*v^-1*u^2=u^2*v*u*v*u^2*v^-1*u*v^-1
##  [ [ v*u^2*v^-1*u^2, u^2*v*u^2*v^-1 ],
##    [ v*u^2*v^-1*u*v^-1*u^2*v*u, u*v^-1*u^2*v*u*v*u^2*v^-1 ],
##    [ v*u*v*u^2*v^-1*u*v^-1*u^2, u^2*v*u*v*u^2*v^-1*u*v^-1 ] ]
##  \endexample
##
DeclareOperation("FindRelationsSubsSG", [IsList, IsList]);
DeclareOperation("FindRelationsSubsSG", [IsList, IsList, IsCyclotomic]);
DeclareOperation("FindRelationsSubsSG", [IsList, IsList, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindRelationsSubsSG", [IsList]);
DeclareOperation("FindRelationsSubsSG", [IsList, IsCyclotomic]);
DeclareOperation("FindRelationsSubsSG", [IsList, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#O  FindRelations (<G>[, <max_len>, <max_num_rels>] )
##
##  Finds relatoins between the generators of the group.
##  Stops after investigating all words
##  of length up to <max_len> or when it finds <max_num_rels>
##  relations. If <max_len> or <max_num_rels> are not specified, they are
##  assumed to be `infinity'.  In order to make the list of relations shorter
##  it also tries to remove the relations that can
##  be derived from the known ones. See also `FindRelationsSubs' ("FindRelationsSubs").
##  \beginexample
##  gap> FindRelations(B,5);
##  #I  v*u*v*u^-1*v^-1*u*v^-1*u^-1
##  #I  v*u*v^2*u^-1*v^-1*u*v^-2*u^-1
##  #I  v^2*u*v*u^-1*v^-2*u*v^-1*u^-1
##  [ v*u*v*u^-1*v^-1*u*v^-1*u^-1, v*u*v^2*u^-1*v^-1*u*v^-2*u^-1,
##    v^2*u*v*u^-1*v^-2*u*v^-1*u^-1 ]
##  \endexample
##
DeclareOperation("FindRelations", [IsAutomGroup]);
DeclareOperation("FindRelations", [IsAutomGroup, IsCyclotomic]);
DeclareOperation("FindRelations", [IsAutomGroup, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#O  OrderUsingSections ( <a>[, <max_depth>] )
##
##  Tries to compute the order of an element <a> by looking at its sections
##  of depth up to <max_depth>-th level.
##  If <max_depth> is omitted it is assumed to be `infinity', but then it may not stop. Also note,
##  that if <max_depth> is not given, it searches the tree in depth first and may be trapped
##  in some infinite ray, while specifying finite <max_depth> may produce a result by looking at
##  the section not in that ray.
##  For bounded automata will always produce a result.
##  \beginexample
##  gap> G:=AutomGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> OrderUsingSections(a*b*a*c*b);
##  16
##  gap> H:=AutomGroup("u=(v,1)(1,2),v=(u,1)");
##  < u, v >
##  gap> OrderUsingSections(u^23*v^-2*u^3*v^15,10);
##  #I  (u^23*v^-2*u^3*v^15)^1 has v^13*u^15 as a section at vertex [ 1 ]
##  #I  (v^13*u^15)^4 has congutate of v^13*u^15 as a section at vertex [ 1, 1 ]
##  infinity
##  gap> OrderUsingSections(u^23*v^-2*u^3*v^15,2);
##  fail
##  \endexample
DeclareOperation("OrderUsingSections",[IsAutom]);
DeclareOperation("OrderUsingSections",[IsAutom,IsCyclotomic]);




################################################################################
##
#F  SUSPICIOUS_FOR_NONCONTRACTION ( <a> )
##
##  Returns `true' if there is a vertex <v>, such that $a(v) = v$, $a|_v=a$ or
##  $a|_v=a^-1$.
##
DeclareGlobalFunction("SUSPICIOUS_FOR_NONCONTRACTION");


################################################################################
##
#F  FindGroupElement (<G>, <func>, <val>, <max_len>)
#F  FindGroupElements (<G>, <func>, <val>, <max_len>)
##
##  The first function enumerates elements of the group <G> until it finds
##  an element $g$ of length at most <max_len>, for which <func>($g$)=<val>. Returns $g$.
##
##  The second function enumerates elements of the group of length at most <max_len>
##  and returns the list of elements $g$, for which <func>($g$)=<val>.
##
##  The following examlpe illustrates how one can find an element of order 16 in
##  Grigorchuk group and the list of all such elements of length at most 5.
##  \beginexample
##  gap> FindGroupElement(GrigorchukGroup,Order,16,5);
##  a*b
##  gap> FindGroupElements(GrigorchukGroup,Order,16,5);
##  [ a*b, b*a, c*a*d, d*a*c, a*b*a*d, a*c*a*d, a*d*a*b, a*d*a*c, b*a*d*a, c*a*d*a,
##    d*a*b*a, d*a*c*a, a*c*a*d*a, a*d*a*c*a, b*a*b*a*c, b*a*c*a*c, c*a*b*a*b,
##    c*a*c*a*b ]
##  \endexample
##
DeclareGlobalFunction("FindGroupElement");
DeclareGlobalFunction("FindGroupElements");


################################################################################
##
#F  FindElementOfInfiniteOrder (<G>, <max_len>, <depth>)
#F  FindElementsOfInfiniteOrder (<G>, <max_len>, <depth>)
##
##  The first function enumerates elements of the group <G> up to length <max_len>
##  until it finds an element $g$ of infinite order, such that
##  `OrderUsingSections'($g$,<depth>) is `infinity' (see "OrderUsingSections").
##  In other words all sections of every element up to depth <depth> are
##  investigated. In case if the element belongs to the group generated by bounded
##  automaton (see "IsGeneratedByBoundedAutomaton") one can set <depth> to be `infinity'.
##
##  The second function returns the list of all such elements up to length <max_len>.
##
##  \beginexample
##  gap> G:=AutomGroup("a=(1,1)(1,2),b=(a,c),c=(b,1)");
##  < a, b, c >
##  gap> FindElementOfInfiniteOrder(G,5,10);
##  a*b*c
##  \endexample
##
DeclareGlobalFunction("FindElementOfInfiniteOrder");
DeclareGlobalFunction("FindElementsOfInfiniteOrder");


################################################################################
##
#F  IsNoncontracting (<G>[, <max_len>, <depth>] )
##
##  Tries to show that the group <G> is not contracting.
##  Enumerates the elements of the group <G> up to length <max_len>
##  until it finds an element which has a section <g> of infinite order, such that
##  `OrderUsingSections'(<g>, <depth>) (see "OrderUsingSections")
##  is infinity and such that <g> stabilizes some vertex and has itself as a
##  section at this vertex. See also `IsContracting'~("IsContracting").
##
##  \beginexample
##  gap> G:=AutomGroup("a=(b,a)(1,2),b=(c,b)(),c=(c,a)");
##  < a, b, c >
##  gap> IsNoncontracting(G,10,10);
##  true
##  \endexample
##
DeclareGlobalFunction("IsNoncontracting");


###############################################################################
##
#P  IsAmenable( <G> )
##
##  In certain cases (for groups generated by bounded automata~\cite{bknv:amenab},
##  some virtually abelian groups or finite groups) returns `true' if <G> is
##  amenable.
##
DeclareProperty("IsAmenable", IsTreeAutomorphismGroup);
InstallTrueMethod(IsAmenable, IsAbelian);
InstallTrueMethod(IsAmenable, IsFinite);


################################################################################
##
#F  OrdersOfGroupElementsMain( <n>, <O>, <stop>, <G> )
##
##  Enumerates all elements of a self-similar group up to length <n> and tries
##  to find their orders up to order <O>. Returns `true' if all the orders are
##  finite and `fail' otherwise. In case <stop>=`true' returns `fail' as soon as
##  it finds suspicious element.
##
DeclareGlobalFunction("OrdersOfGroupElementsMain");


################################################################################
##
#F  OrdersOfGroupElements( <n>, <O>, <G> )
##
##  Enumerates all elements of a self-similar group up to length <n> and tries
##  to find their orders up to order <O>. Returns `true' if all the orders are
##  finite and `fail' otherwise.
##
DeclareGlobalFunction("OrdersOfGroupElements");


################################################################################
##
#F  PeriodicityGuess( <n>, <O>, <G> )
##
##  Enumerates all elements of a self-similar
##  group <G> up to length <n> and tries to find their orders up to order <O>
##  returns true if all the orders are finite and fail otherwise
##  returns fail as soon as it finds suspicious element
##
DeclareGlobalFunction("PeriodicityGuess");


################################################################################
##
#F  FindTransitiveElements( <n>, <lev>, <stop>, <G> )
##
##  Finds all elements of the group <G> which are transitive on a level <lev>
##  and have length not greater than <n>. In case <stop>=`true' stops when it
##  finds first transitive element
##
DeclareGlobalFunction("FindTransitiveElements");


################################################################################
##
#P  IsGeneratedByAutomatonOfPolynomialGrowth (<G>)
##
##  For a group <G> generated by all states of finite automaton (see "IsAutomatonGroup")
##  determines whether this automaton has polynomial growth in terms of Sidki~\cite{sidki:circuit}.
##
##  See also `IsGeneratedByBoundedAutomaton' ("IsGeneratedByBoundedAutomaton" and
##  `PolynomialDegreeOfGrowthOfAutomaton' ("PolynomialDegreeOfGrowthOfAutomaton").
##  \beginexample
##  gap> B:=AutomGroup("a=(b,1)(1,2),b=(a,1)");
##  < a, b >
##  gap> IsGeneratedByAutomatonOfPolynomialGrowth(B);
##  true
##  gap> D:=AutomGroup("a=(a,b)(1,2),b=(b,a)");
##  < a, b >
##  gap> IsGeneratedByAutomatonOfPolynomialGrowth(D);
##  false
##  \endexample
##
DeclareProperty("IsGeneratedByAutomatonOfPolynomialGrowth", IsAutomatonGroup);


################################################################################
##
#P  IsGeneratedByBoundedAutomaton (<G>)
##
##  For a group <G> generated by all states of finite automaton (see "IsAutomatonGroup")
##  determines whether this automaton is bounded in terms of Sidki~\cite{sidki:circuit}.
##
##  See also `IsGeneratedByAutomatonOfPolynomialGrowth' ("IsGeneratedByAutomatonOfPolynomialGrowth")
##  and `PolynomialDegreeOfGrowthOfAutomaton' ("PolynomialDegreeOfGrowthOfAutomaton").
##  \beginexample
##  gap> B:=AutomGroup("a=(b,1)(1,2),b=(a,1)");
##  < a, b >
##  gap> IsGeneratedByBoundedAutomaton(B);
##  true
##  gap> C:=AutomGroup("a=(a,b)(1,2),b=(b,c),c=(c,1)(1,2)");
##  < a, b >
##  gap> IsGeneratedByBoundedAutomaton(C);
##  false
##  \endexample
##
DeclareProperty("IsGeneratedByBoundedAutomaton", IsAutomatonGroup);


################################################################################
##
#A  PolynomialDegreeOfGrowthOfAutomaton (<G>)
##
##  For a group <G> generated by all states of finite automaton (see "IsAutomatonGroup")
##  of polynomial growth in terms of Sidki~\cite{sidki:circuit} determines the degree of
##  polynomial growth of this automaton. This degree is 0 if and only if automaton is bounded.
##  If the growth of automaton is exponential returns `fail'.
##
##  See also `IsGeneratedByAutomatonOfPolynomialGrowth' ("IsGeneratedByAutomatonOfPolynomialGrowth")
##  and `IsGeneratedByBoundedAutomaton' ("IsGeneratedByBoundedAutomaton").
##  \beginexample
##  gap> B:=AutomGroup("a=(b,1)(1,2),b=(a,1)");
##  < a, b >
##  gap> PolynomialDegreeOfGrowthOfAutomaton(B);
##  0
##  gap> C:=AutomGroup("a=(a,b)(1,2),b=(b,c),c=(c,1)(1,2)");
##  < a, b >
##  gap> PolynomialDegreeOfGrowthOfAutomaton(C);
##  2
##  \endexample
##
DeclareAttribute("PolynomialDegreeOfGrowthOfAutomaton", IsAutomatonGroup);

#E
