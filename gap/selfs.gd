#############################################################################
##
#W  selfs.gd             automgrp package                      Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


################################################################################
##
#A  GroupNucleus( <G> )
##
##  Tries to compute the <nucleus> (see the definition in "Short math background") of
##  a self-similar group <G>. Note that this set need not contain the original
##  generators of <G>. It uses `FindNucleus' (see "FindNucleus")
##  operation and behaves accordingly: if the group is not contracting it will loop
##  forever. See also `GeneratingSetWithNucleus' ("GeneratingSetWithNucleus").
##
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> GroupNucleus(Basilica);
##  [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##  \endexample
##
DeclareAttribute( "GroupNucleus", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#A  GeneratingSetWithNucleus( <G> )
##
##  Tries to compute the generating set of a self-similar group <G> that includes
##  the original generators and the <nucleus> (see "Short math background") of <G>.
##  It uses `FindNucleus' operation
##  and behaves accordingly: if the group is not contracting
##  it will loop forever (modulo memory constraints, of course).
##  See also `GroupNucleus' ("GroupNucleus").
##
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> GeneratingSetWithNucleus(Basilica);
##  [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##  \endexample
##
DeclareAttribute( "GeneratingSetWithNucleus", IsTreeAutomorphismGroup, "mutable" );


###############################################################################
##
#A  GeneratingSetWithNucleusAutom( <G> )
##
##  Computes the automaton of the generating set that includes the nucleus of a contracting group <G>.
##  See also `GeneratingSetWithNucleus' ("GeneratingSetWithNucleus").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> B_autom := GeneratingSetWithNucleusAutom(Basilica);
##  <automaton>
##  gap> Display(B_autom);
##  a1 = (a1, a1), a2 = (a3, a1)(1,2), a3 = (a2, a1), a4 = (a1, a5)
##  (1,2), a5 = (a4, a1), a6 = (a1, a7)(1,2), a7 = (a6, a1)(1,2)
##  \endexample
##
DeclareAttribute( "GeneratingSetWithNucleusAutom", IsTreeAutomorphismGroup, "mutable" );
DeclareAttribute( "AG_GeneratingSetWithNucleusAutom", IsTreeAutomorphismGroup, "mutable" );
# the second attribute stores the list of automaton


######################################################################################
##
#A  ContractingLevel( <G> )
##
##  Given a contracting group <G> with generating set $N$ that includes the nucleus, stored in
##  `GeneratingSetWithNucleus'(<G>) (see "GeneratingSetWithNucleus") computes the
##  minimal level $n$, such that for every vertex $v$ of the $n$-th
##  level and all $g, h \in N$ the section $gh|_v \in N$.
##
##  In the case if it is not known whether <G> is contracting, it first tries to compute
##  the nucleus. If <G> happens to be noncontracting, it will loop forever. One can
##  also use `IsNoncontracting' (see "IsNoncontracting") or `FindNucleus' (see
##  "FindNucleus") directly.
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> ContractingLevel(Grigorchuk_Group);
##  1
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> ContractingLevel(Basilica);
##  2
##  \endexample
##
DeclareAttribute( "ContractingLevel", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#A  ContractingTable( <G> )
##
##  Given a contracting group <G> with a generating set $N$  of size $k$ that includes the nucleus, stored in
##  `GeneratingSetWithNucleus'(<G>)~(see "GeneratingSetWithNucleus")
##  computes the $k\times k$ table, whose
##  [i][j]-th entry contains decomposition of $N$[i]$N$[j] on
##  the `ContractingLevel'(<G>) level~(see "ContractingLevel"). By construction the sections of
##  $N$[i]$N$[j] on this level belong to $N$. This table is used in the
##  algorithm solving the word problem in polynomial time.
##
##  In the case if it is not known whether <G> is contracting it first tries to compute
##  the nucleus. If <G> happens to be noncontracting, it will loop forever. One can
##  also use `IsNoncontracting' (see "IsNoncontracting") or `FindNucleus' (see
##  "FindNucleus") directly.
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> ContractingTable(Grigorchuk_Group);
##  [ [ (1, 1), (1, 1)(1,2), (a, c), (a, d), (1, b) ],
##    [ (1, 1)(1,2), (1, 1), (c, a)(1,2), (d, a)(1,2), (b, 1)(1,2) ],
##    [ (a, c), (a, c)(1,2), (1, 1), (1, b), (a, d) ],
##    [ (a, d), (a, d)(1,2), (1, b), (1, 1), (a, c) ],
##    [ (1, b), (1, b)(1,2), (a, d), (a, c), (1, 1) ] ]
##  \endexample
##
DeclareAttribute( "ContractingTable", IsTreeAutomorphismGroup, "mutable" );
DeclareAttribute( "AG_ContractingTable", IsTreeAutomorphismGroup, "mutable" );

################################################################################
##
#O  UseContraction( <G> )
#O  DoNotUseContraction( <G> )
##
##  For a contracting automaton group <G> these two operations determine whether to
##  use the algorithm
##  of polynomial complexity solving the word problem in the group. By default
##  it is set to <true> as soon as the nucleus of the group was computed. Sometimes
##  when the nucleus is very big, the standard algorithm of exponential complexity
##  is faster for short words, but this heavily depends on the group. Therefore
##  the decision on which algorithm to use is left to the user. To use the
##  exponential algorithm one can use the second operation `DoNotUseContraction'(<G>).
##
##  Note also then in order to use the polynomial time algorithm the `ContractingTable(G)'
##  (see "ContractingTable") has to be computed first, which takes some time when the
##  nucleus is big. This attribute is computed automatically when the word problem is solved
##  for the first time. This sometimes causes some delay.
##
##  Below we provide an example which shows that both methods can be of use.
##  \testexamplefalse
##  \beginexample
##  gap> G := AutomatonGroup("a=(b,b)(1,2), b=(c,a), c=(a,a)");
##  < a, b, c >
##  gap> IsContracting(G);
##  true
##  gap> Size(GroupNucleus(G));
##  41
##  gap> ContractingLevel(G);
##  6
##  gap> ContractingTable(G);; time;
##  4719
##  gap> v := a*b*a*b^2*c*b*c*b^-1*a^-1*b^-1*a^-1;;
##  gap> w := b*c*a*b*a*b*c^-1*b^-2*a^-1*b^-1*a^-1;;
##  gap> UseContraction(G);;
##  gap> IsOne(Comm(v,w)); time;
##  true
##  110
##  gap> FindGroupRelations(G, 9);; time;
##  a^2
##  b^2
##  c^2
##  (b*a*b*c*a)^2
##  (b*(c*a)^2)^2
##  (b*c*b*a*(b*c)^2*a)^2
##  (b*(c*b*c*a)^2)^2
##  11578
##  gap> DoNotUseContraction(G);;
##  gap> IsOne(Comm(v,w)); time;
##  true
##  922
##  gap> FindGroupRelations(G, 9);; time;
##  a^2
##  b^2
##  c^2
##  (b*a*b*c*a)^2
##  (b*(c*a)^2)^2
##  (b*c*b*a*(b*c)^2*a)^2
##  (b*(c*b*c*a)^2)^2
##  23719
##  \endexample
##
DeclareOperation( "UseContraction", [IsTreeAutomorphismGroup]);
DeclareOperation( "DoNotUseContraction", [IsTreeAutomorphismGroup]);


################################################################################
##
#A  AG_MinimizedAutomatonList( <G> )
##
##  Returns a minimized automaton, which contains generators of group <G> and their inverses
##
DeclareAttribute( "AG_MinimizedAutomatonList", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#F  CONVERT_ASSOCW_TO_LIST( <w> )
##
##  Converts elements of AutomGroup into lists.
##
DeclareGlobalFunction("CONVERT_ASSOCW_TO_LIST");


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
#F  WordActionOnVertex( <w>, <ver>, <G> )
##
##  Computes the image of the vertex <ver> under the action of an element <w> of a
##  self-similar group <G>.
##
DeclareGlobalFunction("WordActionOnVertex");


######################################################################################
##
#O  OrbitOfVertex( <ver>, <g>[, <n>] )
##
##  Returns the list of vertices in the orbit of the vertex <ver> under the
##  action of the semigroup generated by the automorphism <g>.
##  If <n> is specified, it returns only the first <n> elements of the orbit.
##  Vertices are defined either as lists with entries from $\{1,\ldots,d\}$, or as
##  strings containing characters $1,\ldots,d$, where $d$
##  is the degree of the tree.
##  \beginexample
##  gap> T := AutomatonGroup("t=(1,t)(1,2)");
##  < t >
##  gap> OrbitOfVertex([1,1,1], t);
##  [ [ 1, 1, 1 ], [ 2, 1, 1 ], [ 1, 2, 1 ], [ 2, 2, 1 ], [ 1, 1, 2 ],
##    [ 2, 1, 2 ], [ 1, 2, 2 ], [ 2, 2, 2 ] ]
##  gap> OrbitOfVertex("11111111111", t, 6);
##  [ [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
##    [ 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
##    [ 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1 ] ]
##  \endexample
##
DeclareOperation("OrbitOfVertex",[IsList, IsTreeHomomorphism]);
DeclareOperation("OrbitOfVertex",[IsList, IsTreeHomomorphism, IsCyclotomic]);


######################################################################################
##
#O  PrintOrbitOfVertex( <ver>, <g>[, <n>] )
##
##  Prints the orbit of the vertex <ver> under the action of the semigroup generated by
##  <g>. Each vertex is printed as a string containing characters $1,\ldots,d$, where $d$
##  is the degree of the tree. In case of binary tree the symbols `` '' and ```x'''
##  are used to represent `1' and `2'.
##  If <n> is specified only the first <n> elements of the orbit are printed.
##  Vertices are defined either as lists with entries from $\{1,\ldots,d\}$, or as
##  strings. See also `OrbitOfVertex' ("OrbitOfVertex").
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> PrintOrbitOfVertex("2222222222222222222222222222222", p*q^-2, 6);
##  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
##   x x x x x x x x x x x x x x x
##  x  xx  xx  xx  xx  xx  xx  xx
##     x   x   x   x   x   x   x
##  xxx    xxxx    xxxx    xxxx
##   x     x x     x x     x x
##  gap> H := AutomatonGroup("t=(s,1,1)(1,2,3), s=(t,s,t)(1,2)");
##  < t, s >
##  gap> PrintOrbitOfVertex([1,2,1], s^2);
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
#F  AG_IsOneList ( <w>, <G> )
##
##  Checks if the word <w> is trivial in a self-similar group <G> (chooses appropriate
##  algorithm).
##
DeclareGlobalFunction("AG_IsOneList");


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
#F  AG_ChooseAutomatonList( <G> )
##
##  Chooses appropriate representation for <G>.
##

DeclareGlobalFunction("AG_ChooseAutomatonList");


################################################################################
##
#O  AG_OrderOfElement( <a>, <G>, <max_order> )
##
##  Tries to find the order of an element <a>. Checks up to order size <max_order>
##
DeclareOperation("AG_OrderOfElement",[IsList,IsList]);
DeclareOperation("AG_OrderOfElement",[IsList,IsList,IsCyclotomic]);



################################################################################
##
#F  GeneratorActionOnVertex( <G>, <g>, <w> )
##
##  Computes the action of the generator <g> of group <G> on the vertex <w>.
##
DeclareGlobalFunction("GeneratorActionOnVertex");


######################################################################################
##
#F  NumberOfVertex( <ver>, <deg> )
##
##  One can naturally enumerate all the vertices of the $n$-th level of the tree
##  by the numbers $1,\ldots,<deg>^{<n>}$.
##  This function returns the number that corresponds to the vertex <ver>
##  of the <deg>-ary tree. The vertex can be defined either as a list or as a string.
##  \beginexample
##  gap> NumberOfVertex([1,2,1,2], 2);
##  6
##  gap> NumberOfVertex("333", 3);
##  27
##  \endexample
##
DeclareGlobalFunction("AG_NumberOfVertex");  # over alphabet [0,...,d-1]
DeclareGlobalFunction("NumberOfVertex");     # over alphabet [1,...,d]


######################################################################################
##
#F  VertexNumber( <num>, <lev>, <deg> )
##
##  One can naturally enumerate all the vertices of the <lev>-th level of
##  the <deg>-ary tree by the numbers $1,\ldots,<deg>^{<n>}$.
##  This function returns the vertex of this level that has number <num>.
##  \beginexample
##  gap> VertexNumber(1, 3, 2);
##  [ 1, 1, 1 ]
##  gap> VertexNumber(4, 4, 3);
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
##  gap> PermActionOnLevel((1,4,2,3), 2, 1, 2);
##  (1,2)
##  gap> PermActionOnLevel((1,13,5,9,3,15,7,11)(2,14,6,10,4,16,8,12), 4, 2, 2);
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
##  AG_IsWordTransitiveOnLevel( <G>, <w>, <lev> )
##
##  Returns `true' if element <w> of <G> acts
##  transitively on level <lev> and `false' otherwise
##
DeclareGlobalFunction("AG_IsWordTransitiveOnLevel");


################################################################################
##
##  AG_GeneratorActionOnLevelAsMatrix( <G>, <g>, <lev> )
##
##  Computes the action of the generator on the n-th level as permutational matrix
##
DeclareGlobalFunction("AG_GeneratorActionOnLevelAsMatrix");


################################################################################
##
#F  PermOnLevelAsMatrix( <g>, <lev> )
##
##  Computes the action of the element <g> of a group on the <lev>-th level as a permutational matrix, in
##  which the i-th row contains 1 at the position i^<g>.
##  \beginexample
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> PermOnLevel(p*q,2);
##  (1,4)(2,3)
##  gap> PermOnLevelAsMatrix(p*q, 2);
##  [ [ 0, 0, 0, 1 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], [ 1, 0, 0, 0 ] ]
##  \endexample
##
DeclareGlobalFunction("PermOnLevelAsMatrix");


################################################################################
##
#F  TransformationOnLevelAsMatrix( <g>, <lev> )
##
##  Computes the action of the element <g> on the <lev>-th level as a permutational matrix, in
##  which the i-th row contains 1 at the position i^<g>.
##  \beginexample
##  gap> L := AutomatonSemigroup("p=(p,q)(1,2), q=(p,q)[1,1]");
##  < p, q >
##  gap> TransformationOnLevel(p*q,2);
##  Transformation( [ 1, 1, 2, 2 ] )
##  gap> TransformationOnLevelAsMatrix(p*q,2);
##  [ [ 1, 0, 0, 0 ], [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 1, 0, 0 ] ]
##  \endexample
##
DeclareGlobalFunction("TransformationOnLevelAsMatrix");


################################################################################
##
##  InvestigatePairs( <G> )
##
##  Finds all relations of the form $ab=c$, where $a,b,c$ are the states of automaton <G>
##
DeclareGlobalFunction("InvestigatePairs");


################################################################################
##
##  AG_MinimizationOfAutomatonList( <G> )
##
##  Returns an automaton obtained from automaton <G> by minimization.
##
DeclareGlobalFunction("AG_MinimizationOfAutomatonList");


################################################################################
##
##  AG_MinimizationOfAutomatonListTrack( <G> )
##
##  Finds an automaton `G_new' obtained from automaton <G> by minimization. Returns the list
##  `[G_new,track_s,track_l]', where
##  `track_s' is how new states are expressed in terms of the old ones, and
##  `track_l' is how old states are expressed in terms of the new ones.
##
DeclareGlobalFunction("AG_MinimizationOfAutomatonListTrack");


################################################################################
##
##  AG_AddInversesList( <G> )
##
##  Returns an automaton obtained from automaton <G> by adding inverse elements and
##  the identity element, and minimizing the result.
##
DeclareGlobalFunction("AG_AddInversesList");


################################################################################
##
##  AG_AddInversesListTrack( <G> )
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
#O  FindNucleus( <G>[, <max_nucl>, <print_info>] )
##
##  Given a self-similar group <G> it tries to find its nucleus. If <G>
##  is not contracting it will loop forever. When it finds the nucleus it returns
##  the triple [`GroupNucleus'(<G>), `GeneratingSetWithNucleus'(<G>),
##  `GeneratingSetWithNucleusAutom'(<G>)] (see "GroupNucleus", "GeneratingSetWithNucleus",
##  "GeneratingSetWithNucleusAutom").
##
##  If <max_nucl> is given it stops after finding <max_nucl> elements that need to be in
##  the nucleus and returns `fail' if the nucleus was not found.
##
##  An optional argument <print_info> is a boolean telling whether to print results of
##  intermediate computations. The default value is `true'.
##
##  Use `IsNoncontracting'~(see "IsNoncontracting") to try to show that <G> is
##  noncontracting.
##
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> FindNucleus(Basilica);
##  Trying generating set with 5 elements
##  Elements added:[ u^-1*v, v^-1*u ]
##  Trying generating set with 7 elements
##  [ [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ],
##    [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ], <automaton> ]
##  \endexample
##
DeclareOperation("FindNucleus",[IsTreeAutomorphismGroup and IsSelfSimilar]);
DeclareOperation("FindNucleus",[IsTreeAutomorphismGroup and IsSelfSimilar, IsCyclotomic]);
DeclareOperation("FindNucleus",[IsTreeAutomorphismGroup and IsSelfSimilar, IsBool]);
DeclareOperation("FindNucleus",[IsTreeAutomorphismGroup and IsSelfSimilar, IsCyclotomic, IsBool]);


################################################################################
##
##  InversePerm( <G> )
##
##  returns the permutation on the set of generators of <G>
##  which pushes each element to its inverse
##
DeclareGlobalFunction("InversePerm");


#  TODO: Portrait of certain depth


################################################################################
##
#F  AutomPortrait( <a> )
#F  AutomPortraitBoundary( <a> )
#F  AutomPortraitDepth( <a> )
##
##  Constructs the portrait of an element <a> of a
##  contracting group $G$. The portrait of <a> is defined recursively as follows.
##  For $g$ in the nucleus of $G$ the portrait is just $[g]$. For any other
##  element $g=(g_1,g_2,\ldots,g_d)\sigma$ the portrait of $g$ is
##  $[\sigma, `AutomPortrait'(g_1),\ldots, `AutomPortrait'(g_d)]$, where $d$ is
##  the degree of the tree. This structure describes a finite tree whose inner vertices
##  are labelled by permutations from $S_d$ and the leaves are labelled by
##  elements from the nucleus. The contraction in $G$ guarantees that the
##  portrait of any element is finite.
##
##  The portraits may be considered as ``normal forms''
##  of the elements of $G$, since different elements have different portraits.
##
##  One also can be interested only in the boundary of a portrait, which consists
##  of all leaves of the portrait. This boundary can be described by an ordered set of
##  pairs $[level_i, g_i]$, $i=1,\ldots,r$ representing the leaves of the tree ordered from left
##  to right (where $level_i$ and $g_i$ are the level and the label of the $i$-th leaf
##  correspondingly, $r$ is the number of leaves). The operation `AutomPortraitBoundary'(<a>)
##  computes this boundary.
##
##  `AutomPortraitDepth'( <a> ) returns the depth of the portrait, i.e. the minimal
##  level such that all sections of <a> at this level belong to the nucleus of $G$.
##
##  \beginexample
##  gap> Basilica := AutomatonGroup("u=(v,1)(1,2), v=(u,1)");
##  < u, v >
##  gap> AutomPortrait(u^3*v^-2*u);
##  [ (), [ (), [ (), [ v ], [ v ] ], [ 1 ] ],
##    [ (), [ (), [ v ], [ u^-1*v ] ], [ v^-1 ] ] ]
##  gap> AutomPortrait(u^3*v^-2*u^3);
##  [ (), [ (), [ (1,2), [ (), [ (), [ v ], [ v ] ], [ 1 ] ], [ v ] ], [ 1 ] ],
##    [ (), [ (1,2), [ (), [ (), [ v ], [ v ] ], [ 1 ] ], [ u^-1*v ] ], [ v^-1 ]
##       ] ]
##  gap> AutomPortraitBoundary(u^3*v^-2*u^3);
##  [ [ 5, v ], [ 5, v ], [ 4, 1 ], [ 3, v ], [ 2, 1 ], [ 5, v ], [ 5, v ],
##    [ 4, 1 ], [ 3, u^-1*v ], [ 2, v^-1 ] ]
##  gap> AutomPortraitDepth(u^3*v^-2*u^3);
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
#O  Growth( <G>, <max_len> )
##
##  Returns a list of the first values of the growth function of a group
##  (semigroup, monoid) <G>.
##  If <G> is a monoid it computes the growth function at $\{0,1,\ldots,<max_len>\}$,
##  and for a semigroup without identity at $\{1,\ldots,<max_len>\}$.
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> Growth(Grigorchuk_Group, 7);
##  There are 11 elements of length up to 2
##  There are 23 elements of length up to 3
##  There are 40 elements of length up to 4
##  There are 68 elements of length up to 5
##  There are 108 elements of length up to 6
##  There are 176 elements of length up to 7
##  [ 1, 5, 11, 23, 40, 68, 108, 176 ]
##  gap> H := AutomatonSemigroup("a=(a,b)[1,1], b=(b,a)(1,2)");
##  < a, b >
##  gap> Growth(H,6);
##  [ 2, 6, 14, 30, 62, 126 ]
##  \endexample
##
DeclareOperation("Growth", [IsSemigroup, IsCyclotomic]);

################################################################################
##
#O  ListOfElements( <G>, <max_len> )
##
##  Returns the list of all different elements of a group (semigroup, monoid)
##  <G> up to length <max_len>.
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> ListOfElements(Grigorchuk_Group, 3);
##  [ 1, a, b, c, d, a*b, a*c, a*d, b*a, c*a, d*a, a*b*a, a*c*a, a*d*a, b*a*b,
##    b*a*c, b*a*d, c*a*b, c*a*c, c*a*d, d*a*b, d*a*c, d*a*d ]
##  \endexample
##
DeclareOperation("ListOfElements", [IsSemigroup, IsCyclotomic]);


################################################################################
##
##  AG_FiniteGroupId( <G>, <max_size> )
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
##  AG_IsOneWordSubs( <w>, <subs>, <G> )
##
##  Determines if the word <w> given as list of given generators is trivial in <G>
##
DeclareGlobalFunction("AG_IsOneWordSubs");


################################################################################
##
#O  FindGroupRelations( <G>[, <max_len>, <max_num_rels>] )
#O  FindGroupRelations( <subs_words>[, <names>, <max_len>, <max_num_rels>] )
##
##  Finds group relations between the generators of the group <G>
##  or in the group generated by <subs_words>. Stops after investigating all words
##  of length up to <max_len> elements or when it finds <max_num_rels>
##  relations. The optional argument <names> is a list of names of generators of the same length
##  as <subs_words>. If this argument is given the relations are given in terms of these names.
##  Otherwise they are given in terms of the elements of the group generated by <subs_words>.
##  If <max_len> or <max_num_rels> are not specified, they are assumed to be `infinity'.
##  Note that if the rewring system (see "AG_UseRewritingSystem") for group <G> is used, then this operation
##  returns relations not contained in the rewriting system rules (see "AG_RewritingSystemRules").
##  This operation can be applied to any group, not only to a group generated by automata.
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> FindGroupRelations(Basilica, 6);
##  v*u*v*u^-1*v^-1*u*v^-1*u^-1
##  v*u^2*v^-1*u^2*v*u^-2*v^-1*u^-2
##  v^2*u*v^2*u^-1*v^-2*u*v^-2*u^-1
##  [ v*u*v*u^-1*v^-1*u*v^-1*u^-1, v*u^2*v^-1*u^2*v*u^-2*v^-1*u^-2,
##    v^2*u*v^2*u^-1*v^-2*u*v^-2*u^-1 ]
##  gap> FindGroupRelations([u*v^-1, v*u], ["x", "y"], 5);
##  y*x^2*y*x^-1*y^-2*x^-1
##  [ y*x^2*y*x^-1*y^-2*x^-1 ]
##  gap> FindGroupRelations([u*v^-1, v*u], 5);
##  u^-2*v*u^-2*v^-1*u^2*v*u^2*v^-1
##  [ u^-2*v*u^-2*v^-1*u^2*v*u^2*v^-1 ]
##  gap> FindGroupRelations([(1,2)(3,4), (1,2,3)], ["x", "y"]);
##  x^2
##  y^-3
##  (y^-1*x)^3
##  [ x^2, y^-3, (y^-1*x)^3 ]
##  \endexample
##
DeclareOperation("FindGroupRelations", [IsGroup]);
DeclareOperation("FindGroupRelations", [IsGroup, IsCyclotomic]);
DeclareOperation("FindGroupRelations", [IsGroup, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindGroupRelations", [IsList, IsList]);
DeclareOperation("FindGroupRelations", [IsList, IsList, IsCyclotomic]);
DeclareOperation("FindGroupRelations", [IsList, IsList, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindGroupRelations", [IsList]);
DeclareOperation("FindGroupRelations", [IsList, IsCyclotomic]);
DeclareOperation("FindGroupRelations", [IsList, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#O  FindSemigroupRelations( <G>[, <max_len>, <max_num_rels>] )
#O  FindSemigroupRelations( <subs_words>[, <names>, <max_len>, <max_num_rels>] )
##
##  Finds semigroup relations between the generators of the group or semigroup <G>,
##  or in the semigroup generated by <subs_words>. The arguments have the same meaning
##  as in `FindGroupRelations'~("FindGroupRelations"). It returns a list of pairs of equal words.
##  In order to make the list of relations shorter
##  it also tries to remove relations that can
##  be derived from the known ones. Note, that by default the trivial automorphism is
##  not included in every semigroup. So if one needs to find relations of the form
##  $w=1$ one has to define <G> as a monoid or to include the trivial automorphism
##  into <subs_words> (for instance, as `One(g)' for any element `g' acting on the same
##  tree).
##  This operation can be applied for any semigroup, not only for a semigroup generated by automata.
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> FindSemigroupRelations([u*v^-1, v*u], ["x", "y"], 6);
##  y*x^2*y=x*y^2*x
##  y*x^3*y^2=x^2*y^3*x
##  y^2*x^3*y=x*y^3*x^2
##  [ [ y*x^2*y, x*y^2*x ], [ y*x^3*y^2, x^2*y^3*x ], [ y^2*x^3*y, x*y^3*x^2 ] ]
##  gap> FindSemigroupRelations([u*v^-1, v*u],6);
##  v*u^2*v^-1*u^2 = u^2*v*u^2*v^-1
##  v*u*(u*v^-1)^2*u^2*v*u = u*v^-1*u*(u*v)^2*u^2*v^-1
##  (v*u)^2*(u*v^-1)^2*u^2 = u*(u*v)^2*u*(u*v^-1)^2
##  [ [ v*u^2*v^-1*u^2, u^2*v*u^2*v^-1 ],
##    [ v*u*(u*v^-1)^2*u^2*v*u, u*v^-1*u*(u*v)^2*u^2*v^-1 ],
##    [ (v*u)^2*(u*v^-1)^2*u^2, u*(u*v)^2*u*(u*v^-1)^2 ] ]
##  gap> x := Transformation([1,1,2]);;
##  gap> y := Transformation([2,2,3]);;
##  gap> FindSemigroupRelations([x,y],["x","y"]);
##  y*x=x
##  y^2=y
##  x^3=x^2
##  x^2*y=x*y
##  [ [ y*x, x ], [ y^2, y ], [ x^3, x^2 ], [ x^2*y, x*y ] ]
##  \endexample
##
DeclareOperation("FindSemigroupRelations", [IsSemigroup]);
DeclareOperation("FindSemigroupRelations", [IsSemigroup, IsCyclotomic]);
DeclareOperation("FindSemigroupRelations", [IsSemigroup, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindSemigroupRelations", [IsList, IsList]);
DeclareOperation("FindSemigroupRelations", [IsList, IsList, IsCyclotomic]);
DeclareOperation("FindSemigroupRelations", [IsList, IsList, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindSemigroupRelations", [IsList]);
DeclareOperation("FindSemigroupRelations", [IsList, IsCyclotomic]);
DeclareOperation("FindSemigroupRelations", [IsList, IsCyclotomic, IsCyclotomic]);




################################################################################
##
#O  OrderUsingSections( <a>[, <max_depth>] )
##
##  Tries to compute the order of the element <a> by looking at its sections
##  of depth up to <max_depth>-th level.
##  If <max_depth> is omitted it is assumed to be `infinity', but then it may not stop. Also note,
##  that if <max_depth> is not given, it searches the tree in depth first and may be trapped
##  in some infinite ray, while specifying finite <max_depth> may produce a result by looking at
##  a section not in that ray.
##  For bounded automata it will always produce a result.
##
##  If `InfoLevel' of `InfoAutomGrp' is greater than
##  or equal to 3 (one can set it by `SetInfoLevel( InfoAutomGrp, 3)')
##  and the element has infinite order, then the proof of this fact is printed.
##
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> OrderUsingSections( a*b*a*c*b );
##  16
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> SetInfoLevel( InfoAutomGrp, 3);
##  gap> OrderUsingSections( u^23*v^-2*u^3*v^15, 10 );
##  #I  v^13*u^15 acts transitively on levels and is obtained from (u^23*v^-2*u^3*v^15)^1
##      by taking sections and cyclic reductions at vertex [ 1 ]
##  infinity
##  gap> G := AutomatonGroup("a=(c,a)(1,2), b=(b,c), c=(b,a)");
##  < a, b, c >
##  gap> OrderUsingSections(b,10);
##  #I  b*c*a^2*b^2*c*a acts transitively on levels and is obtained from (b)^8
##      by taking sections and cyclic reductions at vertex
##  [ 2, 2, 1, 1, 1, 1, 2, 2, 1, 1 ]
##  infinity
##  \endexample
DeclareOperation("OrderUsingSections",[IsAutom]);
DeclareOperation("OrderUsingSections",[IsAutom,IsCyclotomic]);




################################################################################
##
#F  AG_SuspiciousForNoncontraction( <a>[, <print_info>] )
##
##  Returns `true' if there is a vertex <v>, such that $a(v) = v$, $a|_v=a$ or
##  $a|_v=a^-1$.
##
DeclareGlobalFunction("AG_SuspiciousForNoncontraction");


################################################################################
##
#O  FindElement( <G>, <func>, <val>, <max_len> )
#O  FindElements( <G>, <func>, <val>, <max_len> )
##
##  The first function enumerates elements of the group (semigroup, monoid) <G> until it finds
##  an element $g$ of length at most <max_len>, for which <func>($g$)=<val>. Returns $g$ if
##  such an element was found and `fail' otherwise.
##
##  The second function enumerates elements of the group (semigroup, monoid) of length at most <max_len>
##  and returns the list of elements $g$, for which <func>($g$)=<val>.
##
##  These functions are based on `Iterator' operation (see "Iterator"), so can be applied in
##  more general settings whenever \GAP\ knows how to solve word problem in the group.
##  The following example illustrates how to find an element of order 16 in
##  Grigorchuk group and the list of all such elements of length at most 5.
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> FindElement(Grigorchuk_Group, Order, 16, 5);
##  a*b
##  gap> FindElements(Grigorchuk_Group,Order,16,5);
##  [ a*b, b*a, c*a*d, d*a*c, a*b*a*d, a*c*a*d, a*d*a*b, a*d*a*c, b*a*d*a, c*a*d*a,
##    d*a*b*a, d*a*c*a, a*c*a*d*a, a*d*a*c*a, (b*a)^2*c, b*(a*c)^2, c*(a*b)^2,
##    (c*a)^2*b ]
##  \endexample
##
DeclareOperation("FindElement", [IsSemigroup, IsFunction, IsObject, IsCyclotomic]);
DeclareOperation("FindElements", [IsSemigroup, IsFunction, IsObject, IsCyclotomic]);




################################################################################
##
#O  FindElementOfInfiniteOrder( <G>, <max_len>, <depth> )
#O  FindElementsOfInfiniteOrder( <G>, <max_len>, <depth> )
##
##  The first function enumerates elements of the group <G> up to length <max_len>
##  until it finds an element $g$ of infinite order, such that
##  `OrderUsingSections'($g$,<depth>) (see "OrderUsingSections") is `infinity'.
##  In other words all sections of every element up to depth <depth> are
##  investigated. In case if the element belongs to the group generated by bounded
##  automaton (see "IsGeneratedByBoundedAutomaton") one can set <depth> to be `infinity'.
##
##  The second function returns the list of all such elements up to length <max_len>.
##
##  \beginexample
##  gap> G := AutomatonGroup("a=(1,1)(1,2), b=(a,c), c=(b,1)");
##  < a, b, c >
##  gap> FindElementOfInfiniteOrder(G, 5, 10);
##  a*b*c
##  \endexample
##
DeclareOperation("FindElementOfInfiniteOrder", [IsTreeHomomorphismSemigroup, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindElementsOfInfiniteOrder", [IsTreeHomomorphismSemigroup, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#F  IsNoncontracting( <G>[, <max_len>, <depth>] )
##
##  Tries to show that the group <G> is not contracting.
##  Enumerates the elements of the group <G> up to length <max_len>
##  until it finds an element which has a section <g> of infinite order, such that
##  `OrderUsingSections'(<g>, <depth>) (see "OrderUsingSections")
##  returns `infinity' and such that <g> stabilizes some vertex and has itself as a
##  section at this vertex. See also `IsContracting'~("IsContracting").
##
##  If <max_len> and <depth> are omitted they are assumed to be `infinity' and 10, respectively.
##
##  If `InfoLevel' of `InfoAutomGrp' is greater than
##  or equal to 3 (one can set it by `SetInfoLevel( InfoAutomGrp, 3)'), then the proof
##  is printed.
##
##  \beginexample
##  gap> G := AutomatonGroup("a=(b,a)(1,2), b=(c,b), c=(c,a)");
##  < a, b, c >
##  gap> IsNoncontracting(G);
##  true
##  gap> H := AutomatonGroup("a=(c,b)(1,2), b=(b,a), c=(a,a)");
##  < a, b, c >
##  gap> SetInfoLevel(InfoAutomGrp, 3);
##  gap> IsNoncontracting(H);
##  #I  There are 37 elements of length up to 2
##  #I  There are 187 elements of length up to 3
##  #I  a^2*c^-1*b^-1 is obtained from (a^2*c^-1*b^-1)^2
##      by taking sections and cyclic reductions at vertex [ 1, 1 ]
##  #I  a^2*c^-1*b^-1 has b*c*a^-2 as a section at vertex [ 2 ]
##  true
##  \endexample
##
DeclareGlobalFunction("IsNoncontracting");


###############################################################################
##
#P  IsAmenable( <G> )
##
##  In certain cases (for groups generated by bounded automata~\cite{BKNV05},
##  some virtually abelian groups or finite groups) returns `true' if <G> is
##  amenable.
##
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> IsAmenable(Grigorchuk_Group);
##  true
##  \endexample
##
DeclareProperty("IsAmenable", IsTreeAutomorphismGroup);
InstallTrueMethod(IsAmenable, IsAbelian and IsGroup);
InstallTrueMethod(IsAmenable, IsFinite and IsGroup);




################################################################################
##
#P  IsGeneratedByAutomatonOfPolynomialGrowth( <G> )
##
##  For a group <G> generated by all states of a finite automaton (see "IsAutomatonGroup")
##  determines whether this automaton has polynomial growth in terms of Sidki~\cite{Sid00}.
##
##  See also operations `IsGeneratedByBoundedAutomaton' ("IsGeneratedByBoundedAutomaton") and
##  `PolynomialDegreeOfGrowthOfUnderlyingAutomaton' ("PolynomialDegreeOfGrowthOfUnderlyingAutomaton").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> IsGeneratedByAutomatonOfPolynomialGrowth(Basilica);
##  true
##  gap> D := AutomatonGroup( "a=(a,b)(1,2), b=(b,a)" );
##  < a, b >
##  gap> IsGeneratedByAutomatonOfPolynomialGrowth(D);
##  false
##  \endexample
##
DeclareProperty("IsGeneratedByAutomatonOfPolynomialGrowth", IsAutomatonGroup);


################################################################################
##
#P  IsGeneratedByBoundedAutomaton( <G> )
##
##  For a group <G> generated by all states of a finite automaton (see "IsAutomatonGroup")
##  determines whether this automaton is bounded in terms of Sidki~\cite{Sid00}.
##
##  See also `IsGeneratedByAutomatonOfPolynomialGrowth' ("IsGeneratedByAutomatonOfPolynomialGrowth")
##  and `PolynomialDegreeOfGrowthOfUnderlyingAutomaton' ("PolynomialDegreeOfGrowthOfUnderlyingAutomaton").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> IsGeneratedByBoundedAutomaton(Basilica);
##  true
##  gap> C := AutomatonGroup("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  < a, b, c >
##  gap> IsGeneratedByBoundedAutomaton(C);
##  false
##  \endexample
##
DeclareProperty("IsGeneratedByBoundedAutomaton", IsAutomatonGroup);


################################################################################
##
#A  PolynomialDegreeOfGrowthOfUnderlyingAutomaton( <G> )
##
##  For a group <G> generated by all states of a finite automaton (see "IsAutomatonGroup")
##  of polynomial growth in terms of Sidki~\cite{Sid00} determines the degree of
##  polynomial growth of this automaton. This degree is 0 if and only if the automaton is bounded.
##  If the growth of automaton is exponential returns `fail'.
##
##  See also `IsGeneratedByAutomatonOfPolynomialGrowth' ("IsGeneratedByAutomatonOfPolynomialGrowth")
##  and `IsGeneratedByBoundedAutomaton' ("IsGeneratedByBoundedAutomaton").
##  \beginexample
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> PolynomialDegreeOfGrowthOfUnderlyingAutomaton(Basilica);
##  0
##  gap> C := AutomatonGroup("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  < a, b, c >
##  gap> PolynomialDegreeOfGrowthOfUnderlyingAutomaton(C);
##  2
##  \endexample
##
DeclareAttribute("PolynomialDegreeOfGrowthOfUnderlyingAutomaton", IsAutomatonGroup);



################################################################################
##
#O  IsOfSubexponentialGrowth( <G>[, <len>, <depth>])
##
##  Tries to check whether the growth function of a self-similar group <G> is subexponential.
##  The main part of the algorithm works as follows. It looks at all words of length up to <len>
##  and if for some length $l$ for each word of this length $l$ the sum of the lengths of
##  all its sections at level <depth> is less then $l$, returns `true'. The default values of
##  <len> and <depth> are 10 and 6 respectively. Setting `SetInfoLevel(InfoAtomGrp, 3)' will make it
##  print for each length the words that are not contracted.  It also sometimes helps to use
##  `AG_UseRewritingSystem' (see "AG_UseRewritingSystem").
##
##  \beginexample
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> AG_UseRewritingSystem(Grigorchuk_Group);
##  gap> IsOfSubexponentialGrowth(Grigorchuk_Group,10,6);
##  true
##  \endexample
##
DeclareOperation("IsOfSubexponentialGrowth", [IsTreeAutomorphismGroup]);
DeclareOperation("IsOfSubexponentialGrowth", [IsTreeAutomorphismGroup, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#F  AG_GroupHomomorphismByImagesNC( <G>, <H>, <gens_G>, <gens_H> )
##
##  Returns a group homomorphism from a self-similar group <G> to <H> sending
##  <gens_G> to <gens_H>. It's possible to find images and preimages of elements
##  under homomorphism defined using this function. Does NOT perform any checkings.
##
DeclareGlobalFunction("AG_GroupHomomorphismByImagesNC");


#E
