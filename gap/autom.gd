#############################################################################
##
#W  autom.gd                 automgrp package                  Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsAutom
##
##  <#GAPDoc Label="IsAutom">
##  <ManSection>
##  <Filt Name="IsAutom" Arg="" Type="Category"/>
##  <Description>
##  A category of objects created using <Ref Func="AutomatonGroup"/>. These
##  objects are finite initial automata.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory("IsAutom", IsTreeHomomorphism);
DeclareCategoryCollections("IsAutom");
DeclareCategoryFamily("IsAutom");
InstallTrueMethod(IsActingOnRegularTree, IsAutomCollection);
InstallTrueMethod(IsActingOnRegularTree, IsAutom);

DeclareCategory("IsInvertibleAutom", IsAutom and IsTreeAutomorphism);
DeclareCategoryCollections("IsInvertibleAutom");



###############################################################################
##
#O  Autom(<word>, <a>)
#O  Autom(<word>, <fam>)
##
##  <#GAPDoc Label="Autom">
##  <ManSection>
##  <Oper Name="Autom" Arg="word, a"/>
##  <Oper Name="Autom" Label="for word, fam" Arg="word, fam"/>
##  <Description>
##  Given assosiative word <A>word</A> constructs a tree homomorphism from the family
##  <A>fam</A>, or to which homomorphism <A>a</A> belongs. This function is useful when
##  one needs to make some operations with associative words. See also <Ref Func="Word"/>.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> F := UnderlyingFreeGroup(L);
##  <free group on the generators [ p, q ]>
##  gap> r := Autom(F.1*F.2^2, p);
##  p*q^2
##  gap> Decompose(r);
##  (p*q^2, q*p^2)(1,2)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Autom", [IsAssocWord, IsAutom]);
DeclareOperation("Autom", [IsAssocWord, IsAutomFamily]);
DeclareOperation("Autom", [IsAssocWord, IsList]);


###############################################################################
##
#O  StatesWords(<a>)
##
##  <#GAPDoc Label="autom:StatesWords">
##  <ManSection>
##  <Oper Name="StatesWords" Arg="a"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("StatesWords", [IsAutom]);

#DeclareOperation("Perm", [IsAutom]);

DeclareGlobalFunction("__AG_CreateAutom");


#E
