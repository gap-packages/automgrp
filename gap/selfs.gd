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
##  <#GAPDoc Label="GroupNucleus">
##  <ManSection>
##  <Attr Name="GroupNucleus" Arg="G"/>
##  <Description>
##  Tries to compute the <A>nucleus</A> (see the definition in <Ref Sect="Short math background"/>) of
##  a self-similar group <A>G</A>. Note that this set need not contain the original
##  generators of <A>G</A>. It uses <Ref Func="FindNucleus"/>
##  operation and behaves accordingly: if the group is not contracting it will loop
##  forever. See also <Ref Func="GeneratingSetWithNucleus"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> GroupNucleus(Basilica);
##  [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "GroupNucleus", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#A  GeneratingSetWithNucleus( <G> )
##
##  <#GAPDoc Label="GeneratingSetWithNucleus">
##  <ManSection>
##  <Attr Name="GeneratingSetWithNucleus" Arg="G"/>
##  <Description>
##  Tries to compute the generating set of a self-similar group <A>G</A> that includes
##  the original generators and the <A>nucleus</A> (see <Ref Sect="Short math background"/>) of <A>G</A>.
##  It uses <C>FindNucleus</C> operation
##  and behaves accordingly: if the group is not contracting
##  it will loop forever (modulo memory constraints, of course).
##  See also <Ref Func="GroupNucleus"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> GeneratingSetWithNucleus(Basilica);
##  [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "GeneratingSetWithNucleus", IsTreeAutomorphismGroup, "mutable" );


###############################################################################
##
#A  GeneratingSetWithNucleusAutom( <G> )
##
##  <#GAPDoc Label="GeneratingSetWithNucleusAutom">
##  <ManSection>
##  <Attr Name="GeneratingSetWithNucleusAutom" Arg="G"/>
##  <Description>
##  Computes the automaton of the generating set that includes the nucleus of a contracting group <A>G</A>.
##  See also <Ref Func="GeneratingSetWithNucleus"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> B_autom := GeneratingSetWithNucleusAutom(Basilica);
##  <automaton>
##  gap> Display(B_autom);
##  a1 = (a1, a1), a2 = (a3, a1)(1,2), a3 = (a2, a1), a4 = (a1, a5)
##  (1,2), a5 = (a4, a1), a6 = (a1, a7)(1,2), a7 = (a6, a1)(1,2)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "GeneratingSetWithNucleusAutom", IsTreeAutomorphismGroup, "mutable" );
DeclareAttribute( "AG_GeneratingSetWithNucleusAutom", IsTreeAutomorphismGroup, "mutable" );
# the second attribute stores the list of automaton


######################################################################################
##
#A  ContractingLevel( <G> )
##
##  <#GAPDoc Label="ContractingLevel">
##  <ManSection>
##  <Attr Name="ContractingLevel" Arg="G"/>
##  <Description>
##  Given a contracting group <A>G</A> with generating set <M>N</M> that includes the nucleus, stored in
##  <C>GeneratingSetWithNucleus</C>(<A>G</A>) (see <Ref Func="GeneratingSetWithNucleus"/>) computes the
##  minimal level <M>n</M>, such that for every vertex <M>v</M> of the <M>n</M>-th
##  level and all <M>g, h \in N</M> the section <M>gh|_v \in N</M>.
##  <P/>
##  In the case if it is not known whether <A>G</A> is contracting, it first tries to compute
##  the nucleus. If <A>G</A> happens to be noncontracting, it will loop forever. One can
##  also use <Ref Func="IsNoncontracting"/> or <C>FindNucleus</C> (see
##  <Ref Func="FindNucleus"/>) directly.
##  <Example><![CDATA[
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> ContractingLevel(Grigorchuk_Group);
##  1
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> ContractingLevel(Basilica);
##  2
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "ContractingLevel", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#A  ContractingTable( <G> )
##
##  <#GAPDoc Label="ContractingTable">
##  <ManSection>
##  <Attr Name="ContractingTable" Arg="G"/>
##  <Description>
##  Given a contracting group <A>G</A> with a generating set <M>N</M>  of size <M>k</M> that includes the nucleus, stored in
##  <C>GeneratingSetWithNucleus</C>(<A>G</A>)&nbsp;(see <Ref Func="GeneratingSetWithNucleus"/>)
##  computes the <M>k\times k</M> table, whose
##  [i][j]-th entry contains decomposition of <M>N</M>[i]<M>N</M>[j] on
##  the <C>ContractingLevel</C>(<A>G</A>) level&nbsp;(see <Ref Func="ContractingLevel"/>). By construction the sections of
##  <M>N</M>[i]<M>N</M>[j] on this level belong to <M>N</M>. This table is used in the
##  algorithm solving the word problem in polynomial time.
##  <P/>
##  In the case if it is not known whether <A>G</A> is contracting it first tries to compute
##  the nucleus. If <A>G</A> happens to be noncontracting, it will loop forever. One can
##  also use <Ref Func="IsNoncontracting"/> or <C>FindNucleus</C> (see
##  <Ref Func="FindNucleus"/>) directly.
##  <Example><![CDATA[
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> ContractingTable(Grigorchuk_Group);
##  [ [ (1, 1), (1, 1)(1,2), (a, c), (a, d), (1, b) ], 
##    [ (1, 1)(1,2), (1, 1), (c, a)(1,2), (d, a)(1,2), (b, 1)(1,2) ], 
##    [ (a, c), (a, c)(1,2), (1, 1), (1, b), (a, d) ], 
##    [ (a, d), (a, d)(1,2), (1, b), (1, 1), (a, c) ], 
##    [ (1, b), (1, b)(1,2), (a, d), (a, c), (1, 1) ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "ContractingTable", IsTreeAutomorphismGroup, "mutable" );
DeclareAttribute( "AG_ContractingTable", IsTreeAutomorphismGroup, "mutable" );

################################################################################
##
#O  UseContraction( <G> )
#O  DoNotUseContraction( <G> )
##
##  <#GAPDoc Label="UseContraction">
##  <ManSection>
##  <Oper Name="UseContraction" Arg="G"/>
##  <Oper Name="DoNotUseContraction" Arg="G"/>
##  <Description>
##  For a contracting automaton group <A>G</A> these two operations determine whether to
##  use the algorithm
##  of polynomial complexity solving the word problem in the group. By default
##  it is set to <A>true</A> as soon as the nucleus of the group was computed. Sometimes
##  when the nucleus is very big, the standard algorithm of exponential complexity
##  is faster for short words, but this heavily depends on the group. Therefore
##  the decision on which algorithm to use is left to the user. To use the
##  exponential algorithm one can use the second operation <C>DoNotUseContraction</C>(<A>G</A>).
##  <P/>
##  Note also then in order to use the polynomial time algorithm the <C>ContractingTable(G)</C>
##  (see <Ref Func="ContractingTable"/>) has to be computed first, which takes some time when the
##  nucleus is big. This attribute is computed automatically when the word problem is solved
##  for the first time. This sometimes causes some delay.
##  <P/>
##  Below we provide an example which shows that both methods can be of use.
##  <Log><![CDATA[
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
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation( "UseContraction", [IsTreeAutomorphismGroup]);
DeclareOperation( "DoNotUseContraction", [IsTreeAutomorphismGroup]);


################################################################################
##
#A  AG_MinimizedAutomatonList( <G> )
##
##  <#GAPDoc Label="selfs:AG_MinimizedAutomatonList">
##  <ManSection>
##  <Attr Name="AG_MinimizedAutomatonList" Arg="G"/>
##  <Description>
##  Returns a minimized automaton, which contains generators of group <A>G</A> and their inverses
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "AG_MinimizedAutomatonList", IsTreeAutomorphismGroup, "mutable" );


################################################################################
##
#F  CONVERT_ASSOCW_TO_LIST( <w> )
##
##  <#GAPDoc Label="CONVERT_ASSOCW_TO_LIST">
##  <ManSection>
##  <Func Name="CONVERT_ASSOCW_TO_LIST" Arg="w"/>
##  <Description>
##  Converts elements of AutomGroup into lists.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("CONVERT_ASSOCW_TO_LIST");


################################################################################
##
#F  ReduceWord( <v> )
##
##  <#GAPDoc Label="ReduceWord">
##  <ManSection>
##  <Func Name="ReduceWord" Arg="v"/>
##  <Description>
##  Cuts 1s from the word.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("ReduceWord");


################################################################################
##
#F  ProjectWord( <w>, <s>, <G> )
##
##  <#GAPDoc Label="ProjectWord">
##  <ManSection>
##  <Func Name="ProjectWord" Arg="w, s, G"/>
##  <Description>
##  Computes the projection of the word <A>w</A> onto a subtree #<A>s</A> in a self-similar
##  group <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("ProjectWord");


################################################################################
##
#F  WordActionOnFirstLevel( <w>, <G> )
##
##  <#GAPDoc Label="WordActionOnFirstLevel">
##  <ManSection>
##  <Func Name="WordActionOnFirstLevel" Arg="w, G"/>
##  <Description>
##  Computes the permutation of the first level vertices generated by an element <A>w</A>
##  of a self-similar group <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("WordActionOnFirstLevel");


################################################################################
##
#F  WordActionOnVertex( <w>, <ver>, <G> )
##
##  <#GAPDoc Label="WordActionOnVertex">
##  <ManSection>
##  <Func Name="WordActionOnVertex" Arg="w, ver, G"/>
##  <Description>
##  Computes the image of the vertex <A>ver</A> under the action of an element <A>w</A> of a
##  self-similar group <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("WordActionOnVertex");


######################################################################################
##
#O  OrbitOfVertex( <ver>, <g>[, <n>] )
##
##  <#GAPDoc Label="OrbitOfVertex">
##  <ManSection>
##  <Oper Name="OrbitOfVertex" Arg="ver, g[, n]"/>
##  <Description>
##  Returns the list of vertices in the orbit of the vertex <A>ver</A> under the
##  action of the semigroup generated by the automorphism <A>g</A>.
##  If <A>n</A> is specified, it returns only the first <A>n</A> elements of the orbit.
##  Vertices are defined either as lists with entries from <M>\{1,\ldots,d\}</M>, or as
##  strings containing characters <M>1,\ldots,d</M>, where <M>d</M>
##  is the degree of the tree.
##  <Example><![CDATA[
##  gap> T := AutomatonGroup("t=(1,t)(1,2)");
##  < t >
##  gap> OrbitOfVertex([1,1,1], t);
##  [ [ 1, 1, 1 ], [ 2, 1, 1 ], [ 1, 2, 1 ], [ 2, 2, 1 ], [ 1, 1, 2 ], 
##    [ 2, 1, 2 ], [ 1, 2, 2 ], [ 2, 2, 2 ] ]
##  gap> OrbitOfVertex("11111111111", t, 6);
##  [ [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], 
##    [ 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], 
##    [ 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1 ], [ 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("OrbitOfVertex",[IsList, IsTreeHomomorphism]);
DeclareOperation("OrbitOfVertex",[IsList, IsTreeHomomorphism, IsCyclotomic]);


######################################################################################
##
#O  PrintOrbitOfVertex( <ver>, <g>[, <n>] )
##
##  <#GAPDoc Label="PrintOrbitOfVertex">
##  <ManSection>
##  <Oper Name="PrintOrbitOfVertex" Arg="ver, g[, n]"/>
##  <Description>
##  Prints the orbit of the vertex <A>ver</A> under the action of the semigroup generated by
##  <A>g</A>. Each vertex is printed as a string containing characters <M>1,\ldots,d</M>, where <M>d</M>
##  is the degree of the tree. In case of binary tree the symbols <Q> </Q> and <Q>&#x2018;x</Q>'
##  are used to represent <C>1</C> and <C>2</C>.
##  If <A>n</A> is specified only the first <A>n</A> elements of the orbit are printed.
##  Vertices are defined either as lists with entries from <M>\{1,\ldots,d\}</M>, or as
##  strings. See also <Ref Func="OrbitOfVertex"/>.
##  <Example><![CDATA[
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
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("PrintOrbitOfVertex", [IsList, IsTreeHomomorphism]);
DeclareOperation("PrintOrbitOfVertex", [IsList, IsTreeHomomorphism, IsCyclotomic]);


################################################################################
##
#F  IsOneWordSelfSim ( <word>, <G> )
##
##  <#GAPDoc Label="IsOneWordSelfSim">
##  <ManSection>
##  <Func Name="IsOneWordSelfSim" Arg="word, G"/>
##  <Description>
##  Checks if the word <A>word</A> is trivial in a self-similar group <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("IsOneWordSelfSim");


################################################################################
##
#F  IsOneWordContr ( <word>, <G> )
##
##  <#GAPDoc Label="IsOneWordContr">
##  <ManSection>
##  <Func Name="IsOneWordContr" Arg="word, G"/>
##  <Description>
##  Checks if the word <A>word</A> is trivial in a contracting group <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("IsOneWordContr");


################################################################################
##
#F  AG_IsOneList ( <w>, <G> )
##
##  <#GAPDoc Label="AG_IsOneList">
##  <ManSection>
##  <Func Name="AG_IsOneList" Arg="w, G"/>
##  <Description>
##  Checks if the word <A>w</A> is trivial in a self-similar group <A>G</A> (chooses appropriate
##  algorithm).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("AG_IsOneList");


###############################################################################
##
#F  IsOneContr ( <a> )
##
##  <#GAPDoc Label="IsOneContr">
##  <ManSection>
##  <Func Name="IsOneContr" Arg="a"/>
##  <Description>
##  Returns <K>true</K> if <A>a</A> is trivial automorphism and <K>false</K> otherwise. Works for
##  contracting groups only. Uses polynomial time algorithm.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("IsOneContr");


###############################################################################
##
#F  AG_ChooseAutomatonList( <G> )
##
##  <#GAPDoc Label="AG_ChooseAutomatonList">
##  <ManSection>
##  <Func Name="AG_ChooseAutomatonList" Arg="G"/>
##  <Description>
##  Chooses appropriate representation for <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>

DeclareGlobalFunction("AG_ChooseAutomatonList");


################################################################################
##
#O  AG_OrderOfElement( <a>, <G>, <max_order> )
##
##  <#GAPDoc Label="AG_OrderOfElement">
##  <ManSection>
##  <Oper Name="AG_OrderOfElement" Arg="a, G, max_order"/>
##  <Description>
##  Tries to find the order of an element <A>a</A>. Checks up to order size <A>max_order</A>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AG_OrderOfElement",[IsList,IsList]);
DeclareOperation("AG_OrderOfElement",[IsList,IsList,IsCyclotomic]);



################################################################################
##
#F  GeneratorActionOnVertex( <G>, <g>, <w> )
##
##  <#GAPDoc Label="GeneratorActionOnVertex">
##  <ManSection>
##  <Func Name="GeneratorActionOnVertex" Arg="G, g, w"/>
##  <Description>
##  Computes the action of the generator <A>g</A> of group <A>G</A> on the vertex <A>w</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("GeneratorActionOnVertex");


######################################################################################
##
#F  NumberOfVertex( <ver>, <deg> )
##
##  <#GAPDoc Label="NumberOfVertex">
##  <ManSection>
##  <Func Name="NumberOfVertex" Arg="ver, deg"/>
##  <Description>
##  One can naturally enumerate all the vertices of the <M>n</M>-th level of the tree
##  by the numbers <M>1,\ldots,&lt;\deg&gt;^{&lt;n&gt;}</M>.
##  This function returns the number that corresponds to the vertex <A>ver</A>
##  of the <A>deg</A>-ary tree. The vertex can be defined either as a list or as a string.
##  <Example><![CDATA[
##  gap> NumberOfVertex([1,2,1,2], 2);
##  6
##  gap> NumberOfVertex("333", 3);
##  27
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("AG_NumberOfVertex");  # over alphabet [0,...,d-1]
DeclareGlobalFunction("NumberOfVertex");     # over alphabet [1,...,d]


######################################################################################
##
#F  VertexNumber( <num>, <lev>, <deg> )
##
##  <#GAPDoc Label="VertexNumber">
##  <ManSection>
##  <Func Name="VertexNumber" Arg="num, lev, deg"/>
##  <Description>
##  One can naturally enumerate all the vertices of the <A>lev</A>-th level of
##  the <A>deg</A>-ary tree by the numbers <M>1,\ldots,&lt;\deg&gt;^{&lt;n&gt;}</M>.
##  This function returns the vertex of this level that has number <A>num</A>.
##  <Example><![CDATA[
##  gap> VertexNumber(1, 3, 2);
##  [ 1, 1, 1 ]
##  gap> VertexNumber(4, 4, 3);
##  [ 1, 1, 2, 1 ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("AG_VertexNumber"); # over alphabet [0,...,d-1]
DeclareGlobalFunction("VertexNumber");    # over alphabet [1,...,d]


################################################################################
##
#F  GeneratorActionOnLevel( <G>, <g>, <n> )
##
##  <#GAPDoc Label="GeneratorActionOnLevel">
##  <ManSection>
##  <Func Name="GeneratorActionOnLevel" Arg="G, g, n"/>
##  <Description>
##  Computes the action of the element <A>g</A> of group <A>G</A> at the <A>n</A>-th level.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("GeneratorActionOnLevel");


######################################################################################
##
#F  PermActionOnLevel( <perm>, <big_lev>, <sm_lev>, <deg> )
##
##  <#GAPDoc Label="PermActionOnLevel">
##  <ManSection>
##  <Func Name="PermActionOnLevel" Arg="perm, big_lev, sm_lev, deg"/>
##  <Description>
##  Given a permutation <A>perm</A> on the <A>big_lev</A>-th level of the tree of degree
##  <A>deg</A> returns the permutation induced by <A>perm</A> on a smaller level
##  <A>sm_lev</A>.
##  <Example><![CDATA[
##  gap> PermActionOnLevel((1,4,2,3), 2, 1, 2);
##  (1,2)
##  gap> PermActionOnLevel((1,13,5,9,3,15,7,11)(2,14,6,10,4,16,8,12), 4, 2, 2);
##  (1,4,2,3)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("PermActionOnLevel");


################################################################################
##
#F  WordActionOnLevel( <G>, <w>, <lev> )
##
##  <#GAPDoc Label="WordActionOnLevel">
##  <ManSection>
##  <Func Name="WordActionOnLevel" Arg="G, w, lev"/>
##  <Description>
##  Computes the action of word <A>w</A> in group <A>G</A> on the <A>lev</A>-th level.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="PermOnLevelAsMatrix">
##  <ManSection>
##  <Func Name="PermOnLevelAsMatrix" Arg="g, lev"/>
##  <Description>
##  Computes the action of the element <A>g</A> of a group on the <A>lev</A>-th level as a permutational matrix, in
##  which the i-th row contains 1 at the position i^<A>g</A>.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> PermOnLevel(p*q,2);
##  (1,4)(2,3)
##  gap> PermOnLevelAsMatrix(p*q, 2);
##  [ [ 0, 0, 0, 1 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], [ 1, 0, 0, 0 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("PermOnLevelAsMatrix");


################################################################################
##
#F  TransformationOnLevelAsMatrix( <g>, <lev> )
##
##  <#GAPDoc Label="TransformationOnLevelAsMatrix">
##  <ManSection>
##  <Func Name="TransformationOnLevelAsMatrix" Arg="g, lev"/>
##  <Description>
##  Computes the action of the element <A>g</A> on the <A>lev</A>-th level as a permutational matrix, in
##  which the i-th row contains 1 at the position i^<A>g</A>.
##  <Example><![CDATA[
##  gap> L := AutomatonSemigroup("p=(p,q)(1,2), q=(p,q)[1,1]");
##  < p, q >
##  gap> TransformationOnLevel(p*q,2);
##  Transformation( [ 1, 1, 2, 2 ] )
##  gap> TransformationOnLevelAsMatrix(p*q,2);
##  [ [ 1, 0, 0, 0 ], [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 1, 0, 0 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="FindNucleus">
##  <ManSection>
##  <Oper Name="FindNucleus" Arg="G[, max_nucl, print_info]"/>
##  <Description>
##  Given a self-similar group <A>G</A> it tries to find its nucleus. If <A>G</A>
##  is not contracting it will loop forever. When it finds the nucleus it returns
##  the triple [<C>GroupNucleus</C>(<A>G</A>), <C>GeneratingSetWithNucleus</C>(<A>G</A>),
##  <C>GeneratingSetWithNucleusAutom</C>(<A>G</A>)] (see <Ref Func="GroupNucleus"/>, <Ref Func="GeneratingSetWithNucleus"/>,
##  <Ref Func="GeneratingSetWithNucleusAutom"/>).
##  <P/>
##  If <A>max_nucl</A> is given it stops after finding <A>max_nucl</A> elements that need to be in
##  the nucleus and returns <K>fail</K> if the nucleus was not found.
##  <P/>
##  An optional argument <A>print_info</A> is a boolean telling whether to print results of
##  intermediate computations. The default value is <K>true</K>.
##  <P/>
##  Use <Ref Func="IsNoncontracting"/> to try to show that <A>G</A> is
##  noncontracting.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> FindNucleus(Basilica);
##  Trying generating set with 5 elements
##  Elements added:[ u^-1*v, v^-1*u ]
##  Trying generating set with 7 elements
##  [ [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ], 
##    [ 1, u, v, u^-1, v^-1, u^-1*v, v^-1*u ], <automaton> ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="AutomPortrait">
##  <ManSection>
##  <Func Name="AutomPortrait" Arg="a"/>
##  <Func Name="AutomPortraitBoundary" Arg="a"/>
##  <Func Name="AutomPortraitDepth" Arg="a"/>
##  <Description>
##  Constructs the portrait of an element <A>a</A> of a
##  contracting group <M>G</M>. The portrait of <A>a</A> is defined recursively as follows.
##  For <M>g</M> in the nucleus of <M>G</M> the portrait is just <M>[g]</M>. For any other
##  element <M>g=(g_1,g_2,\ldots,g_d)\sigma</M> the portrait of <M>g</M> is
##  <M>[\sigma, `AutomPortrait'(g_1),\ldots, `AutomPortrait'(g_d)]</M>, where <M>d</M> is
##  the degree of the tree. This structure describes a finite tree whose inner vertices
##  are labelled by permutations from <M>S_d</M> and the leaves are labelled by
##  elements from the nucleus. The contraction in <M>G</M> guarantees that the
##  portrait of any element is finite.
##  <P/>
##  The portraits may be considered as <Q>normal forms</Q>
##  of the elements of <M>G</M>, since different elements have different portraits.
##  <P/>
##  One also can be interested only in the boundary of a portrait, which consists
##  of all leaves of the portrait. This boundary can be described by an ordered set of
##  pairs <M>[level_i, g_i]</M>, <M>i=1,\ldots,r</M> representing the leaves of the tree ordered from left
##  to right (where <M>level_i</M> and <M>g_i</M> are the level and the label of the <M>i</M>-th leaf
##  correspondingly, <M>r</M> is the number of leaves). The operation <C>AutomPortraitBoundary</C>(<A>a</A>)
##  computes this boundary.
##  <P/>
##  <C>AutomPortraitDepth</C>( <A>a</A> ) returns the depth of the portrait, i.e. the minimal
##  level such that all sections of <A>a</A> at this level belong to the nucleus of <M>G</M>.
##  <Example><![CDATA[
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
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="Growth">
##  <ManSection>
##  <Oper Name="Growth" Arg="G, max_len"/>
##  <Description>
##  Returns a list of the first values of the growth function of a group
##  (semigroup, monoid) <A>G</A>.
##  If <A>G</A> is a monoid it computes the growth function at <M>\{0,1,\ldots,&lt;\max_len&gt;\}</M>,
##  and for a semigroup without identity at <M>\{1,\ldots,&lt;\max_len&gt;\}</M>.
##  <Example><![CDATA[
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
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Growth", [IsSemigroup, IsCyclotomic]);

################################################################################
##
#O  ListOfElements( <G>, <max_len> )
##
##  <#GAPDoc Label="ListOfElements">
##  <ManSection>
##  <Oper Name="ListOfElements" Arg="G, max_len"/>
##  <Description>
##  Returns the list of all different elements of a group (semigroup, monoid)
##  <A>G</A> up to length <A>max_len</A>.
##  <Example><![CDATA[
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> ListOfElements(Grigorchuk_Group, 3);
##  [ 1, a, b, c, d, a*b, a*c, a*d, b*a, c*a, d*a, a*b*a, a*c*a, a*d*a, b*a*b, 
##    b*a*c, b*a*d, c*a*b, c*a*c, c*a*d, d*a*b, d*a*c, d*a*d ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="FindGroupRelations">
##  <ManSection>
##  <Oper Name="FindGroupRelations" Arg="G[, max_len, max_num_rels]"/>
##  <Oper Name="FindGroupRelations" Label="for a list of words" Arg="subs_words[, names, max_len, max_num_rels]"/>
##  <Description>
##  Finds group relations between the generators of the group <A>G</A>
##  or in the group generated by <A>subs_words</A>. Stops after investigating all words
##  of length up to <A>max_len</A> elements or when it finds <A>max_num_rels</A>
##  relations. The optional argument <A>names</A> is a list of names of generators of the same length
##  as <A>subs_words</A>. If this argument is given the relations are given in terms of these names.
##  Otherwise they are given in terms of the elements of the group generated by <A>subs_words</A>.
##  If <A>max_len</A> or <A>max_num_rels</A> are not specified, they are assumed to be <C>infinity</C>.
##  Note that if the rewring system (see <Ref Func="AG_UseRewritingSystem"/>) for group <A>G</A> is used, then this operation
##  returns relations not contained in the rewriting system rules (see <Ref Func="AG_RewritingSystemRules"/>).
##  This operation can be applied to any group, not only to a group generated by automata.
##  <Example><![CDATA[
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
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="FindSemigroupRelations">
##  <ManSection>
##  <Oper Name="FindSemigroupRelations" Arg="G[, max_len, max_num_rels]"/>
##  <Oper Name="FindSemigroupRelations" Label="for a list of words" Arg="subs_words[, names, max_len, max_num_rels]"/>
##  <Description>
##  Finds semigroup relations between the generators of the group or semigroup <A>G</A>,
##  or in the semigroup generated by <A>subs_words</A>. The arguments have the same meaning
##  as in <Ref Func="FindGroupRelations"/>. It returns a list of pairs of equal words.
##  In order to make the list of relations shorter
##  it also tries to remove relations that can
##  be derived from the known ones. Note, that by default the trivial automorphism is
##  not included in every semigroup. So if one needs to find relations of the form
##  <M>w=1</M> one has to define <A>G</A> as a monoid or to include the trivial automorphism
##  into <A>subs_words</A> (for instance, as <C>One(g)</C> for any element <C>g</C> acting on the same
##  tree).
##  This operation can be applied for any semigroup, not only for a semigroup generated by automata.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> FindSemigroupRelations([u*v^-1, v*u], ["x", "y"], 6);
##  y*x^2*y = x*y^2*x
##  y*x^3*y^2 = x^2*y^3*x
##  y^2*x^3*y = x*y^3*x^2
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
##  y*x = x
##  y^2 = y
##  x^3 = x^2
##  x^2*y = x*y
##  [ [ y*x, x ], [ y^2, y ], [ x^3, x^2 ], [ x^2*y, x*y ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="OrderUsingSections">
##  <ManSection>
##  <Oper Name="OrderUsingSections" Arg="a[, max_depth]"/>
##  <Description>
##  Tries to compute the order of the element <A>a</A> by looking at its sections
##  of depth up to <A>max_depth</A>-th level.
##  If <A>max_depth</A> is omitted it is assumed to be <C>infinity</C>, but then it may not stop. Also note,
##  that if <A>max_depth</A> is not given, it searches the tree in depth first and may be trapped
##  in some infinite ray, while specifying finite <A>max_depth</A> may produce a result by looking at
##  a section not in that ray.
##  For bounded automata it will always produce a result.
##  <P/>
##  If <C>InfoLevel</C> of <C>InfoAutomGrp</C> is greater than
##  or equal to 3 (one can set it by <C>SetInfoLevel( InfoAutomGrp, 3)</C>)
##  and the element has infinite order, then the proof of this fact is printed.
##  <Example><![CDATA[
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
##      by taking sections and cyclic reductions at vertex [ 2, 2, 1, 1, 1, 1, 2, 2, 1, 1 ]
##  infinity
##  gap> SetInfoLevel( InfoAutomGrp, 0);
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("OrderUsingSections",[IsAutom]);
DeclareOperation("OrderUsingSections",[IsAutom,IsCyclotomic]);




################################################################################
##
#F  AG_SuspiciousForNoncontraction( <a>[, <print_info>] )
##
##  <#GAPDoc Label="AG_SuspiciousForNoncontraction">
##  <ManSection>
##  <Func Name="AG_SuspiciousForNoncontraction" Arg="a[, print_info]"/>
##  <Description>
##  Returns <K>true</K> if there is a vertex <A>v</A>, such that <M>a(v) = v</M>, <M>a|_v=a</M> or
##  <M>a|_v=a^-1</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("AG_SuspiciousForNoncontraction");


################################################################################
##
#O  FindElement( <G>, <func>, <val>, <max_len> )
#O  FindElements( <G>, <func>, <val>, <max_len> )
##
##  <#GAPDoc Label="FindElement">
##  <ManSection>
##  <Oper Name="FindElement" Arg="G, func, val, max_len"/>
##  <Oper Name="FindElements" Arg="G, func, val, max_len"/>
##  <Description>
##  The first function enumerates elements of the group (semigroup, monoid) <A>G</A> until it finds
##  an element <M>g</M> of length at most <A>max_len</A>, for which <A>func</A>(<M>g</M>)=<A>val</A>. Returns <M>g</M> if
##  such an element was found and <K>fail</K> otherwise.
##  <P/>
##  The second function enumerates elements of the group (semigroup, monoid) of length at most <A>max_len</A>
##  and returns the list of elements <M>g</M>, for which <A>func</A>(<M>g</M>)=<A>val</A>.
##  <P/>
##  These functions are based on <C>Iterator</C> operation (see <Ref Func="Iterator"/>), so can be applied in
##  more general settings whenever &GAP; knows how to solve word problem in the group.
##  The following example illustrates how to find an element of order 16 in
##  Grigorchuk group and the list of all such elements of length at most 5.
##  <Example><![CDATA[
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> FindElement(Grigorchuk_Group, Order, 16, 5);
##  a*b
##  gap> FindElements(Grigorchuk_Group,Order,16,5);
##  [ a*b, b*a, c*a*d, d*a*c, a*b*a*d, a*c*a*d, a*d*a*b, a*d*a*c, b*a*d*a, 
##    c*a*d*a, d*a*b*a, d*a*c*a, a*c*a*d*a, a*d*a*c*a, (b*a)^2*c, b*(a*c)^2, 
##    c*(a*b)^2, (c*a)^2*b ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("FindElement", [IsSemigroup, IsFunction, IsObject, IsCyclotomic]);
DeclareOperation("FindElements", [IsSemigroup, IsFunction, IsObject, IsCyclotomic]);




################################################################################
##
#O  FindElementOfInfiniteOrder( <G>, <max_len>, <depth> )
#O  FindElementsOfInfiniteOrder( <G>, <max_len>, <depth> )
##
##  <#GAPDoc Label="FindElementOfInfiniteOrder">
##  <ManSection>
##  <Oper Name="FindElementOfInfiniteOrder" Arg="G, max_len, depth"/>
##  <Oper Name="FindElementsOfInfiniteOrder" Arg="G, max_len, depth"/>
##  <Description>
##  The first function enumerates elements of the group <A>G</A> up to length <A>max_len</A>
##  until it finds an element <M>g</M> of infinite order, such that
##  <C>OrderUsingSections</C>(<M>g</M>,<A>depth</A>) (see <Ref Func="OrderUsingSections"/>) is <C>infinity</C>.
##  In other words all sections of every element up to depth <A>depth</A> are
##  investigated. In case if the element belongs to the group generated by bounded
##  automaton (see <Ref Func="IsGeneratedByBoundedAutomaton"/>) one can set <A>depth</A> to be <C>infinity</C>.
##  <P/>
##  The second function returns the list of all such elements up to length <A>max_len</A>.
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(1,1)(1,2), b=(a,c), c=(b,1)");
##  < a, b, c >
##  gap> FindElementOfInfiniteOrder(G, 5, 10);
##  a*b*c
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("FindElementOfInfiniteOrder", [IsTreeHomomorphismSemigroup, IsCyclotomic, IsCyclotomic]);
DeclareOperation("FindElementsOfInfiniteOrder", [IsTreeHomomorphismSemigroup, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#F  IsNoncontracting( <G>[, <max_len>, <depth>] )
##
##  <#GAPDoc Label="IsNoncontracting">
##  <ManSection>
##  <Func Name="IsNoncontracting" Arg="G[, max_len, depth]"/>
##  <Description>
##  Tries to show that the group <A>G</A> is not contracting.
##  Enumerates the elements of the group <A>G</A> up to length <A>max_len</A>
##  until it finds an element which has a section <A>g</A> of infinite order, such that
##  <C>OrderUsingSections</C>(<A>g</A>, <A>depth</A>) (see <Ref Func="OrderUsingSections"/>)
##  returns <C>infinity</C> and such that <A>g</A> stabilizes some vertex and has itself as a
##  section at this vertex. See also <Ref Func="IsContracting"/>.
##  <P/>
##  If <A>max_len</A> and <A>depth</A> are omitted they are assumed to be <C>infinity</C> and 10, respectively.
##  <P/>
##  If <C>InfoLevel</C> of <C>InfoAutomGrp</C> is greater than
##  or equal to 3 (one can set it by <C>SetInfoLevel( InfoAutomGrp, 3)</C>), then the proof
##  is printed.
##  <Example><![CDATA[
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
##  gap> SetInfoLevel(InfoAutomGrp, 0);
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("IsNoncontracting");


###############################################################################
##
#P  IsAmenable( <G> )
##
##  <#GAPDoc Label="IsAmenable">
##  <ManSection>
##  <Prop Name="IsAmenable" Arg="G"/>
##  <Description>
##  In certain cases (for groups generated by bounded automata&nbsp;<Cite Key="BKNV05"/>,
##  some virtually abelian groups or finite groups) returns <K>true</K> if <A>G</A> is
##  amenable.
##  <Example><![CDATA[
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> IsAmenable(Grigorchuk_Group);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsAmenable", IsTreeAutomorphismGroup);
InstallTrueMethod(IsAmenable, IsAbelian and IsGroup);
InstallTrueMethod(IsAmenable, IsFinite and IsGroup);




################################################################################
##
#P  IsGeneratedByAutomatonOfPolynomialGrowth( <G> )
##
##  <#GAPDoc Label="IsGeneratedByAutomatonOfPolynomialGrowth">
##  <ManSection>
##  <Prop Name="IsGeneratedByAutomatonOfPolynomialGrowth" Arg="G"/>
##  <Description>
##  For a group <A>G</A> generated by all states of a finite automaton (see <Ref Func="IsAutomatonGroup"/>)
##  determines whether this automaton has polynomial growth in terms of Sidki&nbsp;<Cite Key="Sid00"/>.
##  <P/>
##  See also operations <Ref Func="IsGeneratedByBoundedAutomaton"/> and
##  <Ref Func="PolynomialDegreeOfGrowthOfUnderlyingAutomaton"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> IsGeneratedByAutomatonOfPolynomialGrowth(Basilica);
##  true
##  gap> D := AutomatonGroup( "a=(a,b)(1,2), b=(b,a)" );
##  < a, b >
##  gap> IsGeneratedByAutomatonOfPolynomialGrowth(D);
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsGeneratedByAutomatonOfPolynomialGrowth", IsAutomatonGroup);


################################################################################
##
#P  IsGeneratedByBoundedAutomaton( <G> )
##
##  <#GAPDoc Label="IsGeneratedByBoundedAutomaton">
##  <ManSection>
##  <Prop Name="IsGeneratedByBoundedAutomaton" Arg="G"/>
##  <Description>
##  For a group <A>G</A> generated by all states of a finite automaton (see <Ref Func="IsAutomatonGroup"/>)
##  determines whether this automaton is bounded in terms of Sidki&nbsp;<Cite Key="Sid00"/>.
##  <P/>
##  See also <Ref Func="IsGeneratedByAutomatonOfPolynomialGrowth"/>
##  and <Ref Func="PolynomialDegreeOfGrowthOfUnderlyingAutomaton"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> IsGeneratedByBoundedAutomaton(Basilica);
##  true
##  gap> C := AutomatonGroup("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  < a, b, c >
##  gap> IsGeneratedByBoundedAutomaton(C);
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsGeneratedByBoundedAutomaton", IsAutomatonGroup);


################################################################################
##
#A  PolynomialDegreeOfGrowthOfUnderlyingAutomaton( <G> )
##
##  <#GAPDoc Label="PolynomialDegreeOfGrowthOfUnderlyingAutomaton">
##  <ManSection>
##  <Attr Name="PolynomialDegreeOfGrowthOfUnderlyingAutomaton" Arg="G"/>
##  <Description>
##  For a group <A>G</A> generated by all states of a finite automaton (see <Ref Func="IsAutomatonGroup"/>)
##  of polynomial growth in terms of Sidki&nbsp;<Cite Key="Sid00"/> determines the degree of
##  polynomial growth of this automaton. This degree is 0 if and only if the automaton is bounded.
##  If the growth of automaton is exponential returns <K>fail</K>.
##  <P/>
##  See also <Ref Func="IsGeneratedByAutomatonOfPolynomialGrowth"/>
##  and <Ref Func="IsGeneratedByBoundedAutomaton"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> PolynomialDegreeOfGrowthOfUnderlyingAutomaton(Basilica);
##  0
##  gap> C := AutomatonGroup("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  < a, b, c >
##  gap> PolynomialDegreeOfGrowthOfUnderlyingAutomaton(C);
##  2
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("PolynomialDegreeOfGrowthOfUnderlyingAutomaton", IsAutomatonGroup);



################################################################################
##
#O  IsOfSubexponentialGrowth( <G>[, <len>, <depth>])
##
##  <#GAPDoc Label="IsOfSubexponentialGrowth">
##  <ManSection>
##  <Oper Name="IsOfSubexponentialGrowth" Arg="G[, len, depth]"/>
##  <Description>
##  Tries to check whether the growth function of a self-similar group <A>G</A> is subexponential.
##  The main part of the algorithm works as follows. It looks at all words of length up to <A>len</A>
##  and if for some length <M>l</M> for each word of this length <M>l</M> the sum of the lengths of
##  all its sections at level <A>depth</A> is less then <M>l</M>, returns <K>true</K>. The default values of
##  <A>len</A> and <A>depth</A> are 10 and 6 respectively. Setting <C>SetInfoLevel(InfoAtomGrp, 3)</C> will make it
##  print for each length the words that are not contracted.  It also sometimes helps to use
##  <Ref Func="AG_UseRewritingSystem"/>.
##  <Example><![CDATA[
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> AG_UseRewritingSystem(Grigorchuk_Group);
##  gap> IsOfSubexponentialGrowth(Grigorchuk_Group,10,6);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("IsOfSubexponentialGrowth", [IsTreeAutomorphismGroup]);
DeclareOperation("IsOfSubexponentialGrowth", [IsTreeAutomorphismGroup, IsCyclotomic, IsCyclotomic]);


################################################################################
##
#F  AG_GroupHomomorphismByImagesNC( <G>, <H>, <gens_G>, <gens_H> )
##
##  <#GAPDoc Label="AG_GroupHomomorphismByImagesNC">
##  <ManSection>
##  <Func Name="AG_GroupHomomorphismByImagesNC" Arg="G, H, gens_G, gens_H"/>
##  <Description>
##  Returns a group homomorphism from a self-similar group <A>G</A> to <A>H</A> sending
##  <A>gens_G</A> to <A>gens_H</A>. It's possible to find images and preimages of elements
##  under homomorphism defined using this function. Does NOT perform any checkings.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("AG_GroupHomomorphismByImagesNC");


#E
