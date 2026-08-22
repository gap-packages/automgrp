#############################################################################
##
#W  treeautgrp.gd              automgrp package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsTreeAutomorphismGroup( <G> )
##
##  <#GAPDoc Label="IsTreeAutomorphismGroup">
##  <ManSection>
##  <Filt Name="IsTreeAutomorphismGroup" Arg="G" Type="Category"/>
##  <Description>
##  The category of groups of tree automorphisms.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareSynonym("IsTreeAutomorphismGroup", IsGroup and IsTreeAutomorphismCollection);
InstallTrueMethod(IsActingOnTree, IsTreeAutomorphismGroup);


###############################################################################
##
#O  TreeAutomorphismGroup( <G>, <S> )
##
##  <#GAPDoc Label="TreeAutomorphismGroup">
##  <ManSection>
##  <Oper Name="TreeAutomorphismGroup" Arg="G, S"/>
##  <Description>
##  Constructs wreath product of tree automorphisms group <A>G</A> and permutation
##  group <A>S</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("TreeAutomorphismGroup", [IsTreeAutomorphismGroup, IsPermGroup]);


###############################################################################
##
#P  IsFractal( <G> )
##
##  <#GAPDoc Label="IsFractal">
##  <ManSection>
##  <Prop Name="IsFractal" Arg="G"/>
##  <Description>
##  Returns whether the group <A>G</A> is fractal (also called as <A>self-replicating</A>). In other
##  words, if <A>G</A> acts transitively on the first level and for any vertex <M>v</M> of the tree
##  the projection of the stabilizer of <M>v</M> in <A>G</A>
##  on this vertex coincides with the whole group <A>G</A>.
##  <Example><![CDATA[
##  gap> Grigorchuk_Group := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
##  < a, b, c, d >
##  gap> IsFractal(Grigorchuk_Group);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsFractal", IsTreeAutomorphismGroup);


#############################################################################
##
#P  IsFractalByWords( <G> )
##
##  <#GAPDoc Label="IsFractalByWords">
##  <ManSection>
##  <Prop Name="IsFractalByWords" Arg="G"/>
##  <Description>
##  Computes the generators of stabilizers of vertices of the first level
##  and their projections on these vertices. Returns <K>true</K> if  the preimages of these
##  projections in the free group under the canonical epimorphism generate the whole free
##  group for each stabilizer, and the <A>G</A> acts transitively on the first level.
##  This is sufficient but not necessary condition for <A>G</A> to be fractal. See also
##  <Ref Func="IsFractal"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsFractalByWords", IsTreeAutomorphismGroup);
InstallTrueMethod(IsFractal, IsFractalByWords);


###############################################################################
##
#A  LevelOfFaithfulAction( <G> )
#A  LevelOfFaithfulAction( <G>, <max_lev> )
##
##  <#GAPDoc Label="LevelOfFaithfulAction">
##  <ManSection>
##  <Attr Name="LevelOfFaithfulAction" Arg="G[, max_lev]"/>
##  <Description>
##  For a given finite self-similar group <A>G</A> determines the smallest level of
##  the tree, where <A>G</A> acts faithfully, i.e. the stabilizer of this level in <A>G</A>
##  is trivial. The idea here is that for a self-similar group all nontrivial level
##  stabilizers are different. If <A>max_lev</A> is given it finds only first <A>max_lev</A>
##  quotients by stabilizers and if all of them have different size it returns <K>fail</K>.
##  If <A>G</A> is infinite and <A>max_lev</A> is not specified it will loop forever.
##  <P/>
##  See also <Ref Func="IsomorphismPermGroup"/>.
##  <Example><![CDATA[
##  gap> H := SelfSimilarGroup("a=(a,a)(1,2), b=(a,a), c=(b,a)(1,2)");
##  < a, b, c >
##  gap> LevelOfFaithfulAction(H);
##  3
##  gap> Size(H);
##  16
##  gap> Adding_Machine := AutomatonGroup("a=(1,a)(1,2)");
##  < a >
##  gap> LevelOfFaithfulAction(Adding_Machine, 10);
##  fail
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("LevelOfFaithfulAction", IsTreeAutomorphismGroup and IsSelfSimilar);


################################################################################
##
#A  IsContracting( <G> )
##
##  <#GAPDoc Label="IsContracting">
##  <ManSection>
##  <Prop Name="IsContracting" Arg="G"/>
##  <Description>
##  Given a self-similar group <A>G</A> tries to compute whether it is contracting or not.
##  Only a partial method is implemented (since there is no general algorithm so far).
##  First it tries to find the nucleus up to size 50 using <C>FindNucleus</C>(<A>G</A>,50) (see&nbsp;<Ref Func="FindNucleus"/>), then
##  it tries to find evidence that the group is noncontracting using
##  <C>IsNoncontracting</C>(<A>G</A>,10,10) (see&nbsp;<Ref Func="IsNoncontracting"/>). If the answer was not found one can try to use
##  <C>FindNucleus</C> and <C>IsNoncontracting</C> with bigger parameters.  Also one can use
##  <C>SetInfoLevel(InfoAutomGrp, 3)</C> for more information to be displayed.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> IsContracting(Basilica);
##  true
##  gap> IsContracting(AutomatonGroup("a=(c,a)(1,2), b=(c,b), c=(b,a)"));
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsContracting", IsTreeAutomorphismGroup);


###############################################################################
##
#A  StabilizerOfFirstLevel( <G> )
##
##  <#GAPDoc Label="StabilizerOfFirstLevel">
##  <ManSection>
##  <Attr Name="StabilizerOfFirstLevel" Arg="G"/>
##  <Description>
##  Returns the stabilizer of the first level, see also&nbsp;<Ref Func="StabilizerOfLevel"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> StabilizerOfFirstLevel(Basilica);
##  < v, u^2, u*v*u^-1 >
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("StabilizerOfFirstLevel", IsTreeAutomorphismGroup);

###############################################################################
##
#O  StabilizerOfLevel( <G>, <k> )
##
##  <#GAPDoc Label="StabilizerOfLevel">
##  <ManSection>
##  <Oper Name="StabilizerOfLevel" Arg="G, k"/>
##  <Description>
##  Returns the stabilizer of the <A>k</A>-th level.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> StabilizerOfLevel(Basilica, 2);
##  < u^2, v^2, u*v^2*u^-1, v*u^2*v^-1, u*v*u^2*v^-1*u^-1, (v*u)^2*(v^-1*u^-1)^2, \
##  v*u*v^2*u^-1*v^-1, (u*v)^2*u*v^-1*u^-1*v^-1, (u*v)^2*v*u^-1*v^-1*u^-1 >
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
KeyDependentOperation("StabilizerOfLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);

###############################################################################
##
#O  StabilizerOfVertex( <G>, <v> )
##
##  <#GAPDoc Label="StabilizerOfVertex">
##  <ManSection>
##  <Oper Name="StabilizerOfVertex" Arg="G, v"/>
##  <Description>
##  Returns the stabilizer of the vertex <A>v</A>. Here <A>v</A> can be a list representing a
##  vertex, or a positive integer representing a vertex at the first level.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> StabilizerOfVertex(Basilica, [1,2,1]);
##  < u^2, u*v*u^-1, v^2, v*u*v*u^-1*v^-1, v*u^-1*v*u*v^-1, v*u^4*v^-1, v*u^2*v^2*\
##  u^-2*v^-1, (v*u^2)^2*v^-1*u^-2*v^-1, v*u*(u*v)^2*u^-1*v^-1*u^-2*v^-1 >
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("StabilizerOfVertex", [IsTreeAutomorphismGroup, IsObject]);


###############################################################################
##
#O  Projection( <G>, <v> )
#O  ProjectionNC( <G>, <v> )
##
##  <#GAPDoc Label="Projection">
##  <ManSection>
##  <Oper Name="Projection" Arg="G, v"/>
##  <Oper Name="ProjectionNC" Arg="G, v"/>
##  <Description>
##  Returns the projection of the group <A>G</A> at the vertex <A>v</A>. The group <A>G</A> must fix the
##  vertex <A>v</A>, otherwise <C>Error</C>() will be called. The operation <C>ProjectionNC</C> does the
##  same thing, except it does not check whether <A>G</A> fixes the vertex <A>v</A>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> Projection(StabilizerOfVertex(Basilica, [1,2,1]), [1,2,1]);
##  < u, v >
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Projection", [IsTreeAutomorphismGroup, IsList]);
DeclareOperation("ProjectionNC", [IsTreeAutomorphismGroup, IsObject]);

###############################################################################
##
#O  ProjStab (<G>, <v>)
##
##  <#GAPDoc Label="ProjStab">
##  <ManSection>
##  <Oper Name="ProjStab" Arg="G, v"/>
##  <Description>
##  Returns the projection of the stabilizer of <A>v</A> at itself. It is a shortcut for
##  <C>Projection</C>(<C>StabilizerOfVertex</C>(G, v), v) (see <Ref Func="Projection"/>,
##  <Ref Func="StabilizerOfVertex"/>).
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> ProjStab(Basilica, [1,2,1]);
##  < u, v >
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("ProjStab", [IsTreeAutomorphismGroup, IsObject]);


DeclareOperation("__AG_SubgroupOnLevel", [IsTreeAutomorphismGroup,
                                         IsTreeHomomorphismCollection,
                                         IsPosInt]);
DeclareOperation("__AG_SimplifyGroupGenerators", [IsObject]);


###############################################################################
##
#O  PermGroupOnLevel (<G>, <k>)
##
##  <#GAPDoc Label="PermGroupOnLevel">
##  <ManSection>
##  <Oper Name="PermGroupOnLevel" Arg="G, k"/>
##  <Description>
##  Returns the group of permutations induced by the action of the group <A>G</A> at the <A>k</A>-th
##  level.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> PermGroupOnLevel(Basilica, 4);
##  Group([ (1,11,3,9)(2,12,4,10)(5,13)(6,14)(7,15)(8,16), (1,6,2,5)(3,7)(4,8) ])
##  gap> H := PermGroupOnLevel(Group([u,v^2]),4);
##  Group([ (1,11,3,9)(2,12,4,10)(5,13)(6,14)(7,15)(8,16), (1,2)(5,6) ])
##  gap> Size(H);
##  64
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
KeyDependentOperation("PermGroupOnLevel", IsTreeAutomorphismGroup, IsPosInt, ReturnTrue);


###############################################################################
##
#A  ContainsSphericallyTransitiveElement( <G> )
##
##  <#GAPDoc Label="ContainsSphericallyTransitiveElement">
##  <ManSection>
##  <Attr Name="ContainsSphericallyTransitiveElement" Arg="G"/>
##  <Description>
##  For a self-similar group <A>G</A> acting on a binary tree returns <K>true</K> if <A>G</A> contains
##  an element acting spherically transitively on the levels of the tree and <K>false</K>
##  otherwise. See also <Ref Func="SphericallyTransitiveElement"/>.
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> ContainsSphericallyTransitiveElement(Basilica);
##  true
##  gap> G := SelfSimilarGroup("a=(a^-1*b^-1,1)(1,2), b=(b^-1,a*b)");
##  < a, b >
##  gap> ContainsSphericallyTransitiveElement(G);
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("ContainsSphericallyTransitiveElement", IsTreeAutomorphismGroup);


###############################################################################
##
#A  SphericallyTransitiveElement( <G> )
##
##  <#GAPDoc Label="SphericallyTransitiveElement">
##  <ManSection>
##  <Attr Name="SphericallyTransitiveElement" Arg="G"/>
##  <Description>
##  For a self-similar group <A>G</A> acting on a binary tree returns
##  an element of <A>G</A> acting spherically transitively on the levels of the tree if
##  such an element exists and <K>fail</K>
##  otherwise. See also <C>ContainsSphericallyTransitiveElement</C>
##  (<Ref Func="ContainsSphericallyTransitiveElement"/>).
##  <Example><![CDATA[
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> SphericallyTransitiveElement(Basilica);
##  u*v
##  gap> G := SelfSimilarGroup("a=(a^-1*b^-1,1)(1,2), b=(b^-1,a*b)");
##  < a, b >
##  gap> SphericallyTransitiveElement(G);
##  fail
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("SphericallyTransitiveElement", IsTreeAutomorphismGroup);


#E
