#############################################################################
##
#W  selfsim.gd               automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsSelfSim
##
##  <#GAPDoc Label="IsSelfSim">
##  <ManSection>
##  <Filt Name="IsSelfSim" Arg="" Type="Category"/>
##  <Description>
##  A category of objects created using <Ref Func="SelfSimilarGroup"/>. These
##  objects are (possibly infinite) initial automata.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory("IsSelfSim", IsTreeHomomorphism);
DeclareCategoryCollections("IsSelfSim");
DeclareCategoryFamily("IsSelfSim");
InstallTrueMethod(IsActingOnRegularTree, IsSelfSimCollection);
InstallTrueMethod(IsActingOnRegularTree, IsSelfSim);

DeclareCategory("IsInvertibleSelfSim", IsSelfSim and IsTreeAutomorphism);
DeclareCategoryCollections("IsInvertibleSelfSim");



###############################################################################
##
#O  SelfSim( <word>, <a> )
#O  SelfSim( <word>, <fam> )
##
##  <#GAPDoc Label="SelfSim">
##  <ManSection>
##  <Oper Name="SelfSim" Arg="word, a"/>
##  <Oper Name="SelfSim" Label="for word, fam" Arg="word, fam"/>
##  <Description>
##  Given assosiative word <A>word</A> constructs a tree homomorphism from the family
##  <A>fam</A>, or to which homomorphism <A>a</A> belongs. This function is useful when
##  one needs to make some operations with associative words. See also <Ref Func="Word"/>.
##  <Example><![CDATA[
##  gap> G := SelfSimilarGroup("a=(a*b,b)(1,2), b=(a^-1,b)");
##  < a, b >
##  gap> F := UnderlyingFreeGroup(G);
##  <free group on the generators [ a, b ]>
##  gap> c := SelfSim(F.1*F.2^2,a);
##  a*b^2
##  gap> IsSelfSim(c);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("SelfSim", [IsAssocWord, IsSelfSim]);
DeclareOperation("SelfSim", [IsAssocWord, IsSelfSimFamily]);
DeclareOperation("SelfSim", [IsAssocWord, IsList]);

###############################################################################
##
#O  StatesWords( <a> )
##
##  <#GAPDoc Label="selfsim:StatesWords">
##  <ManSection>
##  <Oper Name="StatesWords" Arg="a"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("StatesWords", [IsSelfSim]);


###############################################################################
##
#P  IsFiniteState( <a> )
##
##  <#GAPDoc Label="selfsim:IsFiniteState">
##  <ManSection>
##  <Prop Name="IsFiniteState" Label="for tree homomorphism" Arg="a"/>
##  <Description>
##  Returns <K>true</K> if <A>a</A> has finitely many different sections.
##  It will never stop if the free reduction of words is not sufficient
##  to establish the finite-state property or if <A>a</A> is not finite-state (has
##  infinitely many different sections).
##  <P/>
##  See also <Ref Func="AllSections"/> for the list of all sections and
##  <Ref Func="MealyAutomaton"/>, which allows to construct
##  a Mealy automaton whose states are the sections of <A>a</A> and which
##  encodes its action on the tree.
##  <Example><![CDATA[
##  gap> D := SelfSimilarGroup("x=(1,y)(1,2), y=(z^-1,1)(1,2), z=(1,x*y)");
##  < x, y, z >
##  gap> IsFiniteState(x*y^-1);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsFiniteState", IsSelfSim);





DeclareOperation("OrderUsingSections",[IsSelfSim]);
DeclareOperation("OrderUsingSections",[IsSelfSim, IsCyclotomic]);


DeclareGlobalFunction("__AG_CreateSelfSim");


#E
