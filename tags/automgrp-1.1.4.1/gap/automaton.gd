#############################################################################
##
#W  automaton.gd              automgrp package                 Yevgen Muntyan
#W                                                             Dmytro Savchuk
##  automgrp v 1.1.4.1
##
#Y  Copyright (C) 2003 - 2008 Yevgen Muntyan, Dmytro Savchuk
##


###############################################################################
##
#C  IsMealyAutomaton ( <A> )
##
##  A category of non-initial finite Mealy automata with the same input and
##  output alphabet.
##
DeclareCategory("IsMealyAutomaton", IsMultiplicativeElement and
                               IsAssociativeElement);
DeclareCategoryFamily("IsMealyAutomaton");
DeclareCategoryCollections("IsMealyAutomaton");


###############################################################################
##
#O  MealyAutomaton( <table>[, <names>[, <alphabet>]] )
#O  MealyAutomaton( <string> )
#O  MealyAutomaton( <autom> )
##
##  Creates the Mealy automaton (see "Short math background") defined by the argument <table>, <string>
##  or <autom>. Format of the argument <table> is
##  the following: it is a list of states, where each state is a list of
##  positive integers which represent transition function at the given state and a
##  permutation or transformation which represent the output function at this
##  state.  Format of the string <string> is the same as in `AutomatonGroup' (see~"AutomatonGroup").
##  The third form of this operation takes a tree homomorphism <autom> as its argument.
##  It returns noninitial automaton constructed from the sections of <autom>, whose first state
##  corresponds to <autom> itself.
##
##  \beginexample
##  gap> A := MealyAutomaton([[1,2,(1,2)],[3,1,()],[3,3,(1,2)]], ["a","b","c"]);
##  <automaton>
##  gap> Print(A, "\n");
##  a = (a, b)(1,2), b = (c, a), c = (c, c)(1,2)
##  gap> B:=MealyAutomaton([[1,2,Transformation([1,1])],[3,1,()],[3,3,(1,2)]],["a","b","c"]);
##  <automaton>
##  gap> Print(B, "\n");
##  a = (a, b)[ 1, 1 ], b = (c, a), c = (c, c)[ 2, 1 ]
##  gap> D := MealyAutomaton("a=(a,b)(1,2), b=(b,a)");
##  <automaton>
##  gap> Basilica := AutomatonGroup( "u=(v,1)(1,2), v=(u,1)" );
##  < u, v >
##  gap> M := MealyAutomaton(u*v*u^-3);
##  <automaton>
##  gap> Print(M);
##  a1 = (a2, a5), a2 = (a3, a4), a3 = (a4, a2)(1,2), a4 = (a4, a4), a5 = (a6, a3)
##  (1,2), a6 = (a7, a4), a7 = (a6, a4)(1,2)
##  \endexample
##
DeclareOperation("MealyAutomaton", [IsList]);
DeclareOperation("MealyAutomaton", [IsList, IsList]);
DeclareOperation("MealyAutomaton", [IsList, IsList, IsList]);
DeclareOperation("MealyAutomaton", [IsTreeHomomorphism]);


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
##  Returns the list of <A> acceptible by `MealyAutomaton' (see "MealyAutomaton")
##
##
DeclareAttribute("AutomatonList", IsMealyAutomaton);


###############################################################################
##
#A  NumberOfStates( <A> )
##
##  Returns the number of states of the automaton <A>.
##
##
DeclareAttribute("NumberOfStates", IsMealyAutomaton);


###############################################################################
##
#A  SizeOfAlphabet( <A> )
##
##  Returns the number of letters in the alphabet the automaton <A> acts on.
##
##
DeclareAttribute("SizeOfAlphabet", IsMealyAutomaton);



################################################################################
##
#A  AG_MinimizedAutomatonList ( <A> )
##
##  Returns a minimized automaton, which contains the states of <A>, their inverses
##  and the trivial state
##
DeclareAttribute( "AG_MinimizedAutomatonList", IsMealyAutomaton, "mutable" );


################################################################################
##
#F  MinimizationOfAutomaton ( <A> )
##
##  Returns the automaton obtained from automaton <A> by minimization.
##  \beginexample
##  gap> B := MealyAutomaton("a=(1,a)(1,2), b=(1,a)(1,2), c=(a,b), d=(a,b)");
##  <automaton>
##  gap> C := MinimizationOfAutomaton(B);
##  <automaton>
##  gap> Print(C);
##  a = (1, a)(1,2), c = (a, a), 1 = (1, 1)
##  \endexample
##
DeclareGlobalFunction("MinimizationOfAutomaton");


################################################################################
##
#F  MinimizationOfAutomatonTrack ( <A> )
##
##  Returns the list `[A_new, new_via_old, old_via_new]', where `A_new' is an
##  automaton obtained from automaton <A> by minimization,
##  `new_via_old' describes how new states are expressed in terms of the old ones, and
##  `old_via_new' describes how old states are expressed in terms of the new ones.
##  \beginexample
##  gap> B := MealyAutomaton("a=(1,a)(1,2), b=(1,a)(1,2), c=(a,b), d=(a,b)");
##  <automaton>
##  gap> B_min := MinimizationOfAutomatonTrack(B);
##  [ <automaton>, [ 1, 3, 5 ], [ 1, 1, 2, 2, 3 ] ]
##  gap> Print(B_min[1]);
##  a = (1, a)(1,2), c = (a, a), 1 = (1, 1)
##  \endexample
##
DeclareGlobalFunction("MinimizationOfAutomatonTrack");


################################################################################
##
#F  AutomatonWithInverses ( <A> )
##
##  Returns an automaton obtained from automaton <A> by adding inverse elements and
##  the identity element, and minimizing the result.
##
DeclareGlobalFunction("AutomatonWithInverses");


################################################################################
##
#F  AutomatonWithInversesTrack ( <A> )
##
##  Returns an automaton `A_new' obtained from automaton <A> by adding inverse elements and
##  the identity element, and minimizing the result. Returns the list
##  `[A_new,track_s,track_l]', where
##  `track_s' is how new states are expressed in terms of the old ones, and
##  `track_l' is how old states are expressed in terms of the new ones.
##
DeclareGlobalFunction("AutomatonWithInversesTrack");



#############################################################################
##
#P  IsInvertible ( <A> )
##
##  Is `true' if <A> is invertible and `false' otherwise.
##
DeclareProperty("IsInvertible", IsMealyAutomaton);


################################################################################
##
#P  IsOfPolynomialGrowth ( <A> )
##
##  Determines whether the automaton <A> has polynomial growth in terms of Sidki~\cite{Sid00}.
##
##  See also `IsBounded' ("IsBounded") and
##  `PolynomialDegreeOfGrowth' ("PolynomialDegreeOfGrowth").
##  \beginexample
##  gap> B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
##  <automaton>
##  gap> IsOfPolynomialGrowth(B);
##  true
##  gap> D := MealyAutomaton("a=(a,b)(1,2), b=(b,a)");
##  <automaton>
##  gap> IsOfPolynomialGrowth(D);
##  false
##  \endexample
##
DeclareProperty("IsOfPolynomialGrowth", IsMealyAutomaton);


################################################################################
##
#P  IsBounded ( <A> )
##
##  Determines whether the automaton <A> is bounded in terms of Sidki~\cite{Sid00}.
##
##  See also `IsOfPolynomialGrowth' ("IsOfPolynomialGrowth")
##  and `PolynomialDegreeOfGrowth' ("PolynomialDegreeOfGrowth").
##  \beginexample
##  gap> B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
##  <automaton>
##  gap> IsBounded(B);
##  true
##  gap> C := MealyAutomaton("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  <automaton>
##  gap> IsBounded(C);
##  false
##  \endexample
##
DeclareProperty("IsBounded", IsMealyAutomaton);


################################################################################
##
#A  PolynomialDegreeOfGrowth ( <A> )
##
##  For an automaton <A> of polynomial growth in terms of Sidki~\cite{Sid00}
##  determines its degree of
##  polynomial growth. This degree is 0 if and only if automaton is bounded.
##  If the growth of automaton is exponential returns `fail'.
##
##  See also `IsOfPolynomialGrowth' ("IsOfPolynomialGrowth")
##  and `IsBounded' ("IsBounded").
##  \beginexample
##  gap> B := MealyAutomaton("a=(b,1)(1,2), b=(a,1)");
##  <automaton>
##  gap> PolynomialDegreeOfGrowth(B);
##  0
##  gap> C := MealyAutomaton("a=(a,b)(1,2), b=(b,c), c=(c,1)(1,2)");
##  <automaton>
##  gap> PolynomialDegreeOfGrowth(C);
##  2
##  \endexample
##
DeclareAttribute("PolynomialDegreeOfGrowth", IsMealyAutomaton);


################################################################################
##
#O  DualAutomaton ( <A> )
##
##  Returns the automaton dual of <A>.
##  \beginexample
##  gap> A := MealyAutomaton("a=(b,a)(1,2), b=(b,a)");
##  <automaton>
##  gap> D := DualAutomaton(A);
##  <automaton>
##  gap> Print(D);
##  d1 = (d2, d1)[ 2, 2 ], d2 = (d1, d2)[ 1, 1 ]
##  \endexample
##
DeclareOperation("DualAutomaton", [IsMealyAutomaton]);


################################################################################
##
#O  InverseAutomaton ( <A> )
##
##  Returns the automaton inverse to <A> if <A> is invertible.
##  \beginexample
##  gap> A := MealyAutomaton("a=(b,a)(1,2), b=(b,a)");
##  <automaton>
##  gap> B := InverseAutomaton(A);
##  <automaton>
##  gap> Print(B);
##  a1 = (a1, a2)(1,2), a2 = (a2, a1)
##  \endexample
##
DeclareOperation("InverseAutomaton", [IsMealyAutomaton]);


################################################################################
##
#O  IsBireversible ( <A> )
##
##  Computes whether or not the automaton <A> is bireversible, i.e. <A>, the dual of <A> and
##  the dual of the inverse of <A> are invertible. The example below shows that the
##  Bellaterra automaton is bireversible.
##  \beginexample
##  gap> Bellaterra := MealyAutomaton("a=(c,c)(1,2), b=(a,b), c=(b,a)");
##  <automaton>
##  gap> IsBireversible(Bellaterra);
##  true
##  \endexample
##
DeclareProperty("IsBireversible", IsMealyAutomaton);


################################################################################
##
#O  IsTrivial ( <A> )
##
##  Computes whether the automaton <A> is equivalent to the trivial automaton.
##  \beginexample
##  gap> A := MealyAutomaton("a=(c,c), b=(a,b), c=(b,a)");
##  <automaton>
##  gap> IsTrivial(A);
##  true
##  \endexample
##
DeclareProperty("IsTrivial", IsMealyAutomaton);


################################################################################
##
#O  DisjointUnion ( <A>, <B> )
##
##  Constructs the disjoint union of automata <A> and <B>
##  \beginexample
##  gap> A := MealyAutomaton("a=(a,b)(1,2), b=(a,b)");
##  <automaton>
##  gap> B := MealyAutomaton("c=(d,c), d=(c,e)(1,2), e=(e,d)");
##  <automaton>
##  gap> Print(DisjointUnion(A, B));
##  a1 = (a1, a2)(1,2), a2 = (a1, a2), a3 = (a4, a3), a4 = (a3, a5)
##  (1,2), a5 = (a5, a4)
##  \endexample
##
DeclareOperation("DisjointUnion", [IsMealyAutomaton, IsMealyAutomaton]);



################################################################################
##
#O  AreEquivalentAutomata( <A>, <B> )
##
##  Returns `true' if for every state `s' of the automaton <A> there is a state of the automaton <B>
##  equivalent to `s' and vice versa.
##  \beginexample
##  gap> A := MealyAutomaton("a=(b,a)(1,2), b=(a,c), c=(b,c)(1,2)");
##  <automaton>
##  gap> B := MealyAutomaton("b=(a,c), c=(b,c)(1,2), a=(b,a)(1,2), d=(b,c)(1,2)");
##  <automaton>
##  gap> AreEquivalentAutomata(A, B);
##  true
##  \endexample
##
DeclareOperation("AreEquivalentAutomata", [IsMealyAutomaton, IsMealyAutomaton]);



################################################################################
##
#O  SubautomatonWithStates( <A>, <states> )
##
##  Returns the minimal subautomaton of the automaton <A> containing states <states>.
##  \beginexample
##  gap> A := MealyAutomaton("a=(e,d)(1,2),b=(c,c),c=(b,c)(1,2),d=(a,e)(1,2),e=(e,d)");
##  <automaton>
##  gap> Print(SubautomatonWithStates(A, [1, 4]));
##  a = (e, d)(1,2), d = (a, e)(1,2), e = (e, d)
##  \endexample
##
DeclareOperation("SubautomatonWithStates", [IsMealyAutomaton, IsList]);




################################################################################
##
#O  AutomatonNucleus( <A> )
##
##  Returns the nucleus of the automaton <A>, i.e. the minimal subautomaton
##  containing all cycles in <A>.
##  \beginexample
##  gap> A := MealyAutomaton("a=(b,c)(1,2),b=(d,d),c=(d,b)(1,2),d=(d,b)(1,2),e=(a,d)");
##  <automaton>
##  gap> Print(AutomatonNucleus(A));
##  b = (d, d), d = (d, b)(1,2)
##  \endexample
##
DeclareOperation("AutomatonNucleus", [IsMealyAutomaton]);



##  PassToPowerOfAlphabet ( <A>, <power> )


#E
