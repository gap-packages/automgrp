#############################################################################
##
#W  automaton.gd              automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
#Y  Copyright (C) 2003 - 2018 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsMealyAutomaton ( <A> )
##
##  <#GAPDoc Label="IsMealyAutomaton">
##  <ManSection>
##  <Filt Name="IsMealyAutomaton" Arg="A" Type="Category"/>
##  <Description>
##  A category of non-initial finite Mealy automata with the same input and
##  output alphabet.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareCategory("IsMealyAutomaton", IsMultiplicativeElement and
                               IsAssociativeElement);
DeclareCategoryFamily("IsMealyAutomaton");
DeclareCategoryCollections("IsMealyAutomaton");




###############################################################################
##
#O  MealyAutomaton( <table>[, <names>[, <alphabet>]] )
#O  MealyAutomaton( <string> )
#O  MealyAutomaton( <autom> )
#O  MealyAutomaton( <tree_hom_list> )
#O  MealyAutomaton( <list>, <name_func> )
#O  MealyAutomaton( <list>, <true> )
##
##  <#GAPDoc Label="MealyAutomaton">
##  <ManSection>
##  <Oper Name="MealyAutomaton" Arg="table[, names[, alphabet]]"/>
##  <Oper Name="MealyAutomaton" Label="for string" Arg="string"/>
##  <Oper Name="MealyAutomaton" Label="for autom" Arg="autom"/>
##  <Oper Name="MealyAutomaton" Label="for a list of tree homomorphisms" Arg="tree_hom_list"/>
##  <Oper Name="MealyAutomaton" Label="for a list and a naming function" Arg="list, name_func"/>
##  <Oper Name="MealyAutomaton" Label="for list, true" Arg="list, true"/>
##  <Description>
##  Creates the Mealy automaton (see <Ref Sect="Short math background"/>) defined by the argument <A>table</A>, <A>string</A>
##  or <A>autom</A>. Format of the argument <A>table</A> is
##  the following: it is a list of states, where each state is a list of
##  positive integers which represent transition function at the given state and a
##  permutation or transformation which represent the output function at this
##  state.  Format of the string <A>string</A> is the same as in <C>AutomatonGroup</C> (see&nbsp;<Ref Func="AutomatonGroup"/>).
##  The third form of this operation takes a tree homomorphism <A>autom</A> as its argument.
##  It returns noninitial automaton constructed from the sections of <A>autom</A>, whose first state
##  corresponds to <A>autom</A> itself. The fourth form creates a noninitial automaton constructed
##  of the states of all tree homomorphisms from the <A>tree_hom_list</A>.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton([[1,2,(1,2)],[3,1,()],[3,3,(1,2)]], ["a","b","c"]);
##  <automaton>
##  gap> Display(A);
##  a = (a, b)(1,2), b = (c, a), c = (c, c)(1,2)
##  gap> B:=MealyAutomaton([[1,2,Transformation([1,1])],[3,1,()],[3,3,(1,2)]],["a","b","c"]);
##  <automaton>
##  gap> Display(B);
##  a = (a, b)[ 1, 1 ], b = (c, a), c = (c, c)[ 2, 1 ]
##  gap> D := MealyAutomaton("a=(a,b)(1,2), b=(b,a)");
##  <automaton>
##  gap> Display(D);
##  a = (a, b)(1,2), b = (b, a)
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> M := MealyAutomaton(u*v*u^-3);
##  <automaton>
##  gap> Display(M);
##  a1 = (a2, a5), a2 = (a3, a4), a3 = (a4, a2)(1,2), a4 = (a4, a4), a5 = (a6, a3)
##  (1,2), a6 = (a7, a4), a7 = (a6, a4)(1,2)
##  ]]></Example>
##  If <A>list</A> consists of tree homomorphisms, it creates a noninitial automaton
##  constructed of their states. If <A>name_func</A> is a function then it is used
##  to name the states of the newly constructed automaton. If it is <A>true</A>
##  then states of automata from the <A>list</A> are used. If it <A>false</A> then new
##  states are named a_1, a_2, etc.
##  <Example><![CDATA[
##  gap> G := AutomatonGroup("a=(b,a),b=(b,a)(1,2)");
##  < a, b >
##  gap> MealyAutomaton([a*b]);; Display(last);
##  a1 = (a2, a4)(1,2), a2 = (a3, a1), a3 = (a3, a1)(1,2), a4 = (a2, a4)
##  gap> MealyAutomaton([a*b], true);; Display(last);
##  <a*b> = (<b^2>, <a^2>)(1,2), <b^2> = (<b*a>, <a*b>), <b*a> = (<b*a>, <a*b>)
##  (1,2), <a^2> = (<b^2>, <a^2>)
##  gap> MealyAutomaton([a*b], String);; Display(last);
##  a*b = (b^2, a^2)(1,2), b^2 = (b*a, a*b), b*a = (b*a, a*b)
##  (1,2), a^2 = (b^2, a^2)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>

DeclareOperation("MealyAutomaton", [IsList]);
DeclareOperation("MealyAutomaton", [IsList, IsObject]);
DeclareOperation("MealyAutomaton", [IsList, IsList, IsList]);
DeclareOperation("MealyAutomaton", [IsTreeHomomorphism]);


DeclareOperation("SetStateName", [IsMealyAutomaton, IsInt, IsString]);
DeclareOperation("SetStateNames", [IsMealyAutomaton, IsList]);


# ###############################################################################
# ##
# #A  TransitionFunction( <A> )
# ##
# ##  Returns transition function of <A> as a {\GAP} function of two
# ##  variables.
# ##
# DeclareAttribute("TransitionFunction", IsMealyAutomaton);
#
# ###############################################################################
# ##
# #A  OutputFunction( <A>[, <state>] )
# ##
# ##  Returns output function of <A> as a {\GAP} function of two
# ##  variables.
# ##
# DeclareAttribute("OutputFunction", IsMealyAutomaton);


###############################################################################
##
#A  AutomatonList( <A> )
##
##  <#GAPDoc Label="automaton:AutomatonList">
##  <ManSection>
##  <Attr Name="AutomatonList" Label="for automaton" Arg="A"/>
##  <Description>
##  Returns the list of <A>A</A> acceptable by <Ref Func="MealyAutomaton"/>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("AutomatonList", IsMealyAutomaton);


###############################################################################
##
#A  NumberOfStates( <A> )
##
##  <#GAPDoc Label="NumberOfStates">
##  <ManSection>
##  <Attr Name="NumberOfStates" Arg="A"/>
##  <Description>
##  Returns the number of states of the automaton <A>A</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("NumberOfStates", IsMealyAutomaton);


###############################################################################
##
#A  SizeOfAlphabet( <A> )
##
##  <#GAPDoc Label="SizeOfAlphabet">
##  <ManSection>
##  <Attr Name="SizeOfAlphabet" Arg="A"/>
##  <Description>
##  Returns the number of letters in the alphabet the automaton <A>A</A> acts on.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("SizeOfAlphabet", IsMealyAutomaton);



################################################################################
##
#A  AG_MinimizedAutomatonList ( <A> )
##
##  <#GAPDoc Label="automaton:AG_MinimizedAutomatonList">
##  <ManSection>
##  <Attr Name="AG_MinimizedAutomatonList" Arg="A"/>
##  <Description>
##  Returns a minimized automaton, which contains the states of <A>A</A>, their inverses
##  and the trivial state
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "AG_MinimizedAutomatonList", IsMealyAutomaton, "mutable" );


################################################################################
##
#F  MinimizationOfAutomaton ( <A> )
##
##  <#GAPDoc Label="MinimizationOfAutomaton">
##  <ManSection>
##  <Func Name="MinimizationOfAutomaton" Arg="A"/>
##  <Description>
##  Returns the automaton obtained from automaton <A>A</A> by minimization. The
##  implementation of this function was significantly optimized by Andrey Russev
##  starting from Version 1.3.
##  <Example><![CDATA[
##  gap> B := MealyAutomaton("a=(1,a)(1,2), b=(1,a)(1,2), c=(a,b), d=(a,b)");
##  <automaton>
##  gap> C := MinimizationOfAutomaton(B);
##  <automaton>
##  gap> Display(C);
##  a = (1, a)(1,2), c = (a, a), 1 = (1, 1)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("MinimizationOfAutomaton");


################################################################################
##
#F  MinimizationOfAutomatonTrack ( <A> )
##
##  <#GAPDoc Label="MinimizationOfAutomatonTrack">
##  <ManSection>
##  <Func Name="MinimizationOfAutomatonTrack" Arg="A"/>
##  <Description>
##  Returns the list <C>[A_new, new_via_old, old_via_new]</C>, where <C>A_new</C> is an
##  automaton obtained from automaton <A>A</A> by minimization,
##  <C>new_via_old</C> describes how new states are expressed in terms of the old ones, and
##  <C>old_via_new</C> describes how old states are expressed in terms of the new ones.
##  The implementation of this function was significantly optimized by Andrey Russev
##  starting from Version 1.3.
##  <Example><![CDATA[
##  gap> B := MealyAutomaton("a=(1,a)(1,2), b=(1,a)(1,2), c=(a,b), d=(a,b)");
##  <automaton>
##  gap> B_min := MinimizationOfAutomatonTrack(B);
##  [ <automaton>, [ 1, 3, 5 ], [ 1, 1, 2, 2, 3 ] ]
##  gap> Display(B_min[1]);
##  a = (1, a)(1,2), c = (a, a), 1 = (1, 1)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("MinimizationOfAutomatonTrack");


#############################################################################
##
#P  IsInvertible ( <A> )
##
##  <#GAPDoc Label="IsInvertible">
##  <ManSection>
##  <Prop Name="IsInvertible" Arg="A"/>
##  <Description>
##  Is <K>true</K> if <A>A</A> is invertible and <K>false</K> otherwise.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsInvertible", IsMealyAutomaton);


################################################################################
##
#P  IsOfPolynomialGrowth ( <A> )
##
##  <#GAPDoc Label="IsOfPolynomialGrowth">
##  <ManSection>
##  <Prop Name="IsOfPolynomialGrowth" Arg="A"/>
##  <Description>
##  Determines whether the automaton <A>A</A> has polynomial growth in terms of Sidki&nbsp;<Cite Key="Sid00"/>.
##  <P/>
##  See also <Ref Func="IsBounded"/> and
##  <Ref Func="PolynomialDegreeOfGrowth"/>.
##  <Example><![CDATA[
##  gap> B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
##  <automaton>
##  gap> IsOfPolynomialGrowth(B);
##  true
##  gap> D := MealyAutomaton("a=(a,b)(1,2), b=(b,a)");
##  <automaton>
##  gap> IsOfPolynomialGrowth(D);
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsOfPolynomialGrowth", IsMealyAutomaton);


################################################################################
##
#P  IsBounded ( <A> )
##
##  <#GAPDoc Label="IsBounded">
##  <ManSection>
##  <Prop Name="IsBounded" Arg="A"/>
##  <Description>
##  Determines whether the automaton <A>A</A> is bounded in terms of Sidki&nbsp;<Cite Key="Sid00"/>.
##  <P/>
##  See also <Ref Func="IsOfPolynomialGrowth"/>
##  and <Ref Func="PolynomialDegreeOfGrowth"/>.
##  <Example><![CDATA[
##  gap> B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
##  <automaton>
##  gap> IsBounded(B);
##  true
##  gap> C := MealyAutomaton("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  <automaton>
##  gap> IsBounded(C);
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsBounded", IsMealyAutomaton);


################################################################################
##
#A  PolynomialDegreeOfGrowth ( <A> )
##
##  <#GAPDoc Label="PolynomialDegreeOfGrowth">
##  <ManSection>
##  <Attr Name="PolynomialDegreeOfGrowth" Arg="A"/>
##  <Description>
##  For an automaton <A>A</A> of polynomial growth in terms of Sidki&nbsp;<Cite Key="Sid00"/>
##  determines its degree of
##  polynomial growth. This degree is 0 if and only if automaton is bounded.
##  If the growth of automaton is exponential returns <K>fail</K>.
##  <P/>
##  See also <Ref Func="IsOfPolynomialGrowth"/>
##  and <Ref Func="IsBounded"/>.
##  <Example><![CDATA[
##  gap> B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
##  <automaton>
##  gap> PolynomialDegreeOfGrowth(B);
##  0
##  gap> C := MealyAutomaton("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  <automaton>
##  gap> PolynomialDegreeOfGrowth(C);
##  2
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("PolynomialDegreeOfGrowth", IsMealyAutomaton);


################################################################################
##
#O  DualAutomaton ( <A> )
##
##  <#GAPDoc Label="DualAutomaton">
##  <ManSection>
##  <Oper Name="DualAutomaton" Arg="A"/>
##  <Description>
##  Returns the automaton dual of <A>A</A>.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(b,a)(1,2), b=(b,a)");
##  <automaton>
##  gap> D := DualAutomaton(A);
##  <automaton>
##  gap> Display(D);
##  d1 = (d2, d1)[ 2, 2 ], d2 = (d1, d2)[ 1, 1 ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("DualAutomaton", [IsMealyAutomaton]);


################################################################################
##
#O  InverseAutomaton ( <A> )
##
##  <#GAPDoc Label="InverseAutomaton">
##  <ManSection>
##  <Oper Name="InverseAutomaton" Arg="A"/>
##  <Description>
##  Returns the automaton inverse to <A>A</A> if <A>A</A> is invertible.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(b,a)(1,2), b=(b,a)");
##  <automaton>
##  gap> B := InverseAutomaton(A);
##  <automaton>
##  gap> Display(B);
##  a1 = (a1, a2)(1,2), a2 = (a2, a1)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("InverseAutomaton", [IsMealyAutomaton]);


################################################################################
##
#P  IsBireversible ( <A> )
##
##  <#GAPDoc Label="IsBireversible">
##  <ManSection>
##  <Prop Name="IsBireversible" Arg="A"/>
##  <Description>
##  Computes whether or not the automaton <A>A</A> is bireversible, i.e. <A>A</A>, the dual of <A>A</A> and
##  the dual of the inverse of <A>A</A> are invertible. The example below shows that the
##  Bellaterra automaton is bireversible.
##  <Example><![CDATA[
##  gap> Bellaterra := MealyAutomaton("a=(c,c)(1,2), b=(a,b), c=(b,a)");
##  <automaton>
##  gap> IsBireversible(Bellaterra);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsBireversible", IsMealyAutomaton);


################################################################################
##
#P  IsReversible ( <A> )
##
##  <#GAPDoc Label="IsReversible">
##  <ManSection>
##  <Prop Name="IsReversible" Arg="A"/>
##  <Description>
##  Computes whether or not the automaton <A>A</A> is reversible, i.e. the dual of <A>A</A>
##  is invertible.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsReversible", IsMealyAutomaton);


################################################################################
##
#P  IsIRAutomaton ( <A> )
##
##  <#GAPDoc Label="IsIRAutomaton">
##  <ManSection>
##  <Prop Name="IsIRAutomaton" Arg="A"/>
##  <Description>
##  Computes whether or not the automaton <A>A</A> is an IR-automaton, i.e. <A>A</A> and its dual are invertible.
##  The example below shows that the automaton generating lamplighter group is an IR-automaton.
##  <Example><![CDATA[
##  gap> L := MealyAutomaton("a=(b,a)(1,2), b=(a,b)");
##  <automaton>
##  gap> IsIRAutomaton(L);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>

DeclareProperty("IsIRAutomaton", IsMealyAutomaton);



################################################################################
##
#P  IsTrivial ( <A> )
##
##  <#GAPDoc Label="IsTrivial">
##  <ManSection>
##  <Prop Name="IsTrivial" Arg="A"/>
##  <Description>
##  Computes whether the automaton <A>A</A> is equivalent to the trivial automaton.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(c,c), b=(a,b), c=(b,a)");
##  <automaton>
##  gap> IsTrivial(A);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsTrivial", IsMealyAutomaton);


################################################################################
##
#O  MDReduction ( <A> )
##
##  <#GAPDoc Label="MDReduction">
##  <ManSection>
##  <Oper Name="MDReduction" Arg="A"/>
##  <Description>
##  Performs the process of MD-reduction of automaton <A>A</A> (alternating
##  applications of minimization and dualization procedures) until a pair of
##  minimal automata dual to each other is reached. Returns this pair. The main
##  point of this procedure is in the fact that the (semi)group generated by the
##  original automaton is finite if and only each of the (semi)groups generated
##  by the output automata is finite.
##  <Example><![CDATA[
##  gap> A:=MealyAutomaton("a=(d,d,d,d)(1,2)(3,4),b=(b,b,b,b)(1,4)(2,3),\\
##  >                       c=(a,c,a,c),          d=(c,a,c,a)");
##  <automaton>
##  gap> NumberOfStates(MinimizationOfAutomaton(A));
##  4
##  gap> MDR:=MDReduction(A);
##  [ <automaton>, <automaton> ]
##  gap> Display(MDR[1]);
##  d1 = (d2, d2, d1, d1)(1,4,3), d2 = (d1, d1, d2, d2)(1,4)
##  gap> Display(MDR[2]);
##  d1 = (d4, d4)(1,2), d2 = (d2, d2)(1,2), d3 = (d1, d3), d4 = (d3, d1)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("MDReduction", [IsMealyAutomaton]);


################################################################################
##
#P  IsMDTrivial ( <A> )
##
##  <#GAPDoc Label="IsMDTrivial">
##  <ManSection>
##  <Prop Name="IsMDTrivial" Arg="A"/>
##  <Description>
##  Returns <K>true</K> if <A>A</A> is MD-trivial (i.e. if MD-reduction proedure returns the
##  trivial automaton) and <K>false</K> otherwise.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsMDTrivial", IsMealyAutomaton);


################################################################################
##
#P  IsMDReduced ( <A> )
##
##  <#GAPDoc Label="IsMDReduced">
##  <ManSection>
##  <Prop Name="IsMDReduced" Arg="A"/>
##  <Description>
##  Returns <K>true</K> if <A>A</A> is MD-reduced and <K>false</K> otherwise.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsMDReduced", IsMealyAutomaton);


################################################################################
##
#O  DisjointUnion ( <A>, <B> )
##
##  <#GAPDoc Label="DisjointUnion">
##  <ManSection>
##  <Oper Name="DisjointUnion" Arg="A, B"/>
##  <Description>
##  Constructs the disjoint union of automata <A>A</A> and <A>B</A>
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(a,b)(1,2), b=(a,b)");
##  <automaton>
##  gap> B := MealyAutomaton("c=(d,c), d=(c,e)(1,2), e=(e,d)");
##  <automaton>
##  gap> Display(DisjointUnion(A, B));
##  a1 = (a1, a2)(1,2), a2 = (a1, a2), a3 = (a4, a3), a4 = (a3, a5)
##  (1,2), a5 = (a5, a4)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("DisjointUnion", [IsMealyAutomaton, IsMealyAutomaton]);



################################################################################
##
#O  AreEquivalentAutomata( <A>, <B> )
##
##  <#GAPDoc Label="AreEquivalentAutomata">
##  <ManSection>
##  <Oper Name="AreEquivalentAutomata" Arg="A, B"/>
##  <Description>
##  Returns <K>true</K> if for every state <C>s</C> of the automaton <A>A</A> there is a state of the automaton <A>B</A>
##  equivalent to <C>s</C> and vice versa.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(b,a)(1,2), b=(a,c), c=(b,c)(1,2)");
##  <automaton>
##  gap> B := MealyAutomaton("b=(a,c), c=(b,c)(1,2), a=(b,a)(1,2), d=(b,c)(1,2)");
##  <automaton>
##  gap> AreEquivalentAutomata(A, B);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AreEquivalentAutomata", [IsMealyAutomaton, IsMealyAutomaton]);



################################################################################
##
#O  SubautomatonWithStates( <A>, <states> )
##
##  <#GAPDoc Label="SubautomatonWithStates">
##  <ManSection>
##  <Oper Name="SubautomatonWithStates" Arg="A, states"/>
##  <Description>
##  Returns the minimal subautomaton of the automaton <A>A</A> containing states <A>states</A>.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(e,d)(1,2),b=(c,c),c=(b,c)(1,2),d=(a,e)(1,2),e=(e,d)");
##  <automaton>
##  gap> Display(SubautomatonWithStates(A, [1, 4]));
##  a = (e, d)(1,2), d = (a, e)(1,2), e = (e, d)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("SubautomatonWithStates", [IsMealyAutomaton, IsList]);




################################################################################
##
#O  AutomatonNucleus( <A> )
##
##  <#GAPDoc Label="AutomatonNucleus">
##  <ManSection>
##  <Oper Name="AutomatonNucleus" Arg="A"/>
##  <Description>
##  Returns the nucleus of the automaton <A>A</A>, i.e. the minimal subautomaton
##  containing all cycles in <A>A</A>.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(b,c)(1,2),b=(d,d),c=(d,b)(1,2),d=(d,b)(1,2),e=(a,d)");
##  <automaton>
##  gap> Display(AutomatonNucleus(A));
##  b = (d, d), d = (d, b)(1,2)
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AutomatonNucleus", [IsMealyAutomaton]);


###############################################################################
##
#A  AdjacencyMatrix( <A> )
##
##  <#GAPDoc Label="AdjacencyMatrix">
##  <ManSection>
##  <Attr Name="AdjacencyMatrix" Arg="A"/>
##  <Description>
##  Returns the adjacency matrix of a Mealy automaton <A>A</A>, in which the <M>ij</M>-th entry
##  contains the number of arrows in the Moore diagram of <A>A</A> from state <M>i</M> to state <M>j</M>.
##  <Example><![CDATA[
##  gap> A:=MealyAutomaton("a=(a,a,b)(1,2,3),b=(a,c,b)(1,2),c=(a,a,a)");
##  <automaton>
##  gap> AdjacencyMatrix(A);
##  [ [ 2, 1, 0 ], [ 1, 1, 1 ], [ 3, 0, 0 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute("AdjacencyMatrix", IsMealyAutomaton);


################################################################################
##
#P  IsAcyclic ( <A> )
##
##  <#GAPDoc Label="IsAcyclic">
##  <ManSection>
##  <Prop Name="IsAcyclic" Arg="A"/>
##  <Description>
##  Computes whether or not an automaton <A>A</A> is acyclic in the sense of Sidki&nbsp;<Cite Key="Sid00"/>.
##  I.e. returns <K>true</K> if the Moore diagram of <A>A</A> does not contain cycles with two or more
##  states and <K>false</K> otherwise.
##  <Example><![CDATA[
##  gap> A := MealyAutomaton("a=(a,a,b)(1,2,3),b=(c,c,b)(1,2),c=(d,c,1),d=(d,1,d)");
##  <automaton>
##  gap> IsAcyclic(A);
##  true
##  gap> A := MealyAutomaton("a=(a,a,b)(1,2,3),b=(c,c,d)(1,2),c=(d,c,1),d=(b,1,d)");
##  <automaton>
##  gap> IsAcyclic(A);
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsAcyclic", IsMealyAutomaton);


DeclareOperation("\/", [IsMealyAutomaton, IsMealyAutomaton]);
DeclareAttribute("Inverse", IsMealyAutomaton);



##  PassToPowerOfAlphabet ( <A>, <power> )


#E
