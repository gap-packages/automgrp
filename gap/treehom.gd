#############################################################################
##
#W  treehom.gd              automgrp package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#C  IsTreeHomomorphism
##
##  <#GAPDoc Label="IsTreeHomomorphism">
##  <ManSection>
##  <Filt Name="IsTreeHomomorphism" Arg="" Type="Category"/>
##  <Description>
##  Category of level-preserving rooted tree homomorphisms.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory("IsTreeHomomorphism", IsActingOnTree and
                                      IsMultiplicativeElementWithOne and
                                      IsAssociativeElement);
DeclareCategoryFamily("IsTreeHomomorphism");
DeclareCategoryCollections("IsTreeHomomorphism");
InstallTrueMethod(IsActingOnTree, IsTreeHomomorphismFamily);
InstallTrueMethod(IsActingOnTree, IsTreeHomomorphismCollection);


# XXX
DeclareAttribute("AutomatonList", IsTreeHomomorphism and IsActingOnRegularTree, "mutable");


###############################################################################
##
#O  TreeHomomorphism( <states>, <tr> )
##
##  <#GAPDoc Label="TreeHomomorphism">
##  <ManSection>
##  <Oper Name="TreeHomomorphism" Arg="states, tr"/>
##  <Description>
##  Constructs a homomorphism with states <A>states</A> and acting
##  on the first level with transformation <A>tr</A>. The <A>states</A> must
##  belong to the same family.
##  <Example><![CDATA[
##  gap> S := AutomatonSemigroup("a=(a,b)[1,1],b=(b,a)(1,2)");
##  < a, b >
##  gap> x := TreeHomomorphism([a,b^2,a,a*b],Transformation([3,1,2,2]));
##  (a, b^2, a, a*b)[3,1,2,2]
##  gap> y := TreeHomomorphism([a*b,b,b,b^2],Transformation([1,4,2,3]));
##  (a*b, b, b, b^2)[1,4,2,3]
##  gap> x*y;
##  (a*b, b^2*a*b, a*b, a*b^2)[2,1,4,4]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>


##
DeclareOperation("TreeHomomorphism", [IsList, IsObject]);

###############################################################################
##
#M  TreeHomomorphism(<state_1>, <state_2>, ..., <state_n>, <perm>)
##
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsTransformation]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsTransformation]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsObject, IsTransformation]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsPerm]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsPerm]);
DeclareOperation("TreeHomomorphism", [IsObject, IsObject, IsObject, IsObject, IsPerm]);


###############################################################################
##
#O  TreeHomomorphismFamily( <sph_ind> )
##
##  <#GAPDoc Label="TreeHomomorphismFamily">
##  <ManSection>
##  <Oper Name="TreeHomomorphismFamily" Arg="sph_ind"/>
##  <Description>
##  Constructs a family to which all homomorphisms of a tree with spherical
##  index <A>sph_ind</A> belong. It is used internally, objects created with
##  <C>TreeAutomorphism</C> belong to this family.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("TreeHomomorphismFamily", [IsObject]);


###############################################################################
##
#O  TransformationOnLevel( <a>, <lev> )
#O  TransformationOnFirstLevel( <a> )
##
##  <#GAPDoc Label="TransformationOnLevel">
##  <ManSection>
##  <Oper Name="TransformationOnLevel" Arg="a, lev"/>
##  <Attr Name="TransformationOnFirstLevel" Arg="a"/>
##  <Description>
##  The first function returns the transformation induced by the tree homomorphism
##  <A>a</A> on the level <A>lev</A>. See also <Ref Func="PermOnLevel"/>.
##  <P/>
##  If the transformation is invertible then it returns a permutation, and
##  <C>Transformation</C> otherwise.
##  <P/>
##  <C>TransformationOnFirstLevel</C>(<A>a</A>) is equivalent to
##  <C>TransformationOnLevel</C>(<A>a</A>, <C>1</C>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
KeyDependentOperation("TransformationOnLevel", IsTreeHomomorphism, IsPosInt, ReturnTrue);
DeclareAttribute("TransformationOnFirstLevel", IsTreeHomomorphism);


###############################################################################
##
#O  Perm( <a>[, <lev>] )
##
##  <#GAPDoc Label="Perm">
##  <ManSection>
##  <Oper Name="Perm" Arg="a[, lev]"/>
##  <Description>
##  Returns the permutation induced by the tree automorphism <A>a</A> on the level <A>lev</A>
##  (or first level if <A>lev</A> is not given). See also
##  <Ref Func="TransformationOnLevel"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Perm", [IsTreeHomomorphism]);
DeclareOperation("Perm", [IsTreeHomomorphism, IsPosInt]);

###############################################################################
##
#O  PermOnLevel( <a>, <k> )
##
##  <#GAPDoc Label="PermOnLevel">
##  <ManSection>
##  <Oper Name="PermOnLevel" Arg="a, k"/>
##  <Description>
##  Does the same thing as <Ref Func="Perm"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
KeyDependentOperation("PermOnLevel", IsTreeHomomorphism, IsPosInt, ReturnTrue);


###############################################################################
##
#O  Section( <a>, <v> )
##
##  <#GAPDoc Label="treehom:Section">
##  <ManSection>
##  <Oper Name="Section" Label="for tree homomorphism" Arg="a, v"/>
##  <Description>
##  Returns the section of the automorphism (homomorphism) <A>a</A> at the vertex <A>v</A>.
##  The vertex <A>v</A> can be a list representing the vertex, or a positive integer
##  representing a vertex of the first level of the tree.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> Section(p*q*p^2, [1,2,2,1,2,1]);
##  p^2*q^2
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Section", [IsTreeHomomorphism, IsList]);
DeclareOperation("Section", [IsTreeHomomorphism, IsPosInt]);

###############################################################################
##
#O  Sections( <a> [, <lev>] )
##
##  <#GAPDoc Label="Sections">
##  <ManSection>
##  <Oper Name="Sections" Arg="a [, lev]"/>
##  <Description>
##  Returns the list of sections of <A>a</A> at the <A>lev</A>-th level. If <A>lev</A> is omitted
##  it is assumed to be 1.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> Sections(p*q*p^2);
##  [ p*q^2*p, q*p^2*q ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Sections", [IsTreeHomomorphism]);
DeclareOperation("Sections", [IsTreeHomomorphism, IsCyclotomic]);

###############################################################################
##
#O  Decompose( <a>[, <k>] )
##
##  <#GAPDoc Label="Decompose">
##  <ManSection>
##  <Oper Name="Decompose" Arg="a[, k]"/>
##  <Description>
##  Returns the decomposition of the tree homomorphism <A>a</A> on the <A>k</A>-th level of the tree, i.e. the
##  representation of the form <Display>a = (a_1, a_2, \ldots, a_{d_1\times...\times d_k})\sigma</Display>
##  where <M>a_i</M> are the sections of <A>a</A> at the <A>k</A>-th level, and <M>\sigma</M> is the
##  transformation of the <A>k</A>-th level. If <A>k</A> is omitted it is assumed to be 1.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> Decompose(p*q^2);
##  (p*q^2, q*p^2)(1,2)
##  gap> Decompose(p*q^2,3);
##  (p*q^2, q*p^2, p^2*q, q^2*p, p*q*p, q*p*q, p^3, q^3)(1,8,3,5)(2,7,4,6)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Decompose", [IsTreeHomomorphism]);
DeclareOperation("Decompose", [IsTreeHomomorphism, IsPosInt]);
DeclareOperation("Decompose", [IsTreeHomomorphism, IsInt and IsZero]);



###############################################################################
##
#O  Representative( <word>, <fam> )
#O  Representative( <word>, <a> )
##
##  <#GAPDoc Label="Representative">
##  <ManSection>
##  <Oper Name="Representative" Arg="word, fam"/>
##  <Oper Name="Representative" Label="for word, a" Arg="word, a"/>
##  <Description>
##  Given an associative word <A>word</A> constructs the tree homomorphism from the family
##  <A>fam</A>, or to which homomorphism <A>a</A> belongs. This function is useful when
##  one needs to make some operations with associative words. See also <Ref Func="Word"/>.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> F := UnderlyingFreeGroup(L);
##  <free group on the generators [ p, q ]>
##  gap> r := Representative(F.1*F.2^2, p);
##  p*q^2
##  gap> Decompose(r);
##  (p*q^2, q*p^2)(1,2)
##  gap> H := SelfSimilarGroup("x=(x*y,x)(1,2), y=(x^-1,y)");
##  < x, y >
##  gap> F := UnderlyingFreeGroup(H);
##  <free group on the generators [ x, y ]>
##  gap> r := Representative(F.1^-1*F.2, x);
##  x^-1*y
##  gap> Decompose(r);
##  (x^-1*y, y^-1*x^-2)(1,2)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Representative", [IsAssocWord, IsTreeHomomorphism]);
DeclareOperation("Representative", [IsAssocWord, IsTreeHomomorphismFamily]);


###############################################################################
##
#O  Word( <a> )
##
##  <#GAPDoc Label="Word">
##  <ManSection>
##  <Oper Name="Word" Arg="a"/>
##  <Description>
##  Returns <A>a</A> as an associative word (an element of the underlying free group) in
##  the generators of the self-similar group (semigroup) to which <A>a</A> belongs.
##  <Example><![CDATA[
##  gap> L := AutomatonGroup("p=(p,q)(1,2), q=(p,q)");
##  < p, q >
##  gap> w := Word(p*q^2*p^-1);
##  p*q^2*p^-1
##  gap> Length(w);
##  4
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("Word", [IsTreeHomomorphism]);


DeclareGlobalFunction("AG_TreeHomomorphismCmp");


#############################################################################
##
#P  IsSphericallyTransitive ( <a> )
##
##  <#GAPDoc Label="treehom:IsSphericallyTransitive">
##  <ManSection>
##  <Prop Name="IsSphericallyTransitive" Label="for tree homomorphism" Arg="a"/>
##  <Description>
##  Returns whether the action of <A>a</A> is spherically transitive (see <Ref Sect="Short math background"/>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsSphericallyTransitive", IsTreeHomomorphism);
# XXX CanEasilyTestSphericalTransitivity isn't really used except for
# automorphisms of binary tree
DeclareFilter("CanEasilyTestSphericalTransitivity");
InstallTrueMethod(CanEasilyTestSphericalTransitivity, IsSphericallyTransitive);

#############################################################################
##
#O  IsTransitiveOnLevel ( <a>, <lev> )
##
##  <#GAPDoc Label="treehom:IsTransitiveOnLevel">
##  <ManSection>
##  <Oper Name="IsTransitiveOnLevel" Label="for tree homomorphism" Arg="a, lev"/>
##  <Description>
##  Returns whether <A>a</A> acts transitively on level <A>lev</A> of the tree.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("IsTransitiveOnLevel", [IsTreeHomomorphism, IsPosInt]);


#############################################################################
###
##O  \^ ( <ver>, <a> )
###
###  Returns the image of a vertex <ver> under the action of a homomorphism <a>.
###
DeclareOperation("\^", [IsList, IsTreeHomomorphism]);

###DeclareOperation("\^", [IsPosInt, IsTreeHomomorphism]);


###############################################################################
##
#A  AllSections( <a> )
##
##  <#GAPDoc Label="AllSections">
##  <ManSection>
##  <Attr Name="AllSections" Arg="a"/>
##  <Description>
##  Returns the list of all sections of <A>a</A> if there are finitely many of them and
##  this fact can be established using free reduction of words in sections. Otherwise
##  will never stop. Note, that in the case when <A>a</A> is an element of a self-similar
##  (semi)group defined by wreath recursion it does not check whether all elements of the list
##  are actually different automorphisms (homomorphisms) of the tree. If <A>a</A> is a element of
##  of a (semi)group generated by finite automaton, it will always return the list of
##  all distinct sections of <A>a</A>.
##  <Example><![CDATA[
##  gap> D := SelfSimilarGroup("x=(1,y)(1,2), y=(z^-1,1)(1,2), z=(1,x*y)");
##  < x, y, z >
##  gap> AllSections(x*y^-1);
##  [ x*y^-1, z, 1, x*y, y*z^-1, z^-1*y^-1*x^-1, y^-1*x^-1*z*y^-1, z*y^-1*x*y*z, 
##    y*z^-1*x*y, z^-1*y^-1*x^-1*y*z^-1, x*y*z, y, z^-1, y^-1*x^-1, z*y^-1 ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("AllSections", IsTreeHomomorphism);


#E
