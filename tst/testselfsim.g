UnitTest("SelfSim", function()
  local l, FSSelfSimilarGroupsDefs, FSSelfSimilarGroups,\
  FSSelfSimilarSemigroupsDefs, FSSelfSimilarSemigroups, G, T,hom,count,w;

# add groups ONLY at the end of the list to keep numeration
  FSSelfSimilarGroupsDefs := [
    "x=(1,y)(1,2),y=(z^-1,1)(1,2),z=(1,x*y)",
    "x=(x^-1,y)(1,2),y=(z^-1,1)(1,2),z=(1,x*y)",
    "a=(a^-1*b,b^-1*a)(1,2),b=(a^-1,b^-1)",
    [[[-1,2],[-2,1],(1,2)],[[-1],[-2],()]],
  ];

  FSSelfSimilarSemigroupsDefs := [
    "a=(1,1)[1,1],b=(a*c,1)(1,2),c=(1,a*b)",
  ];

  FSSelfSimilarGroups := List( FSSelfSimilarGroupsDefs, SelfSimilarGroup );
  FSSelfSimilarSemigroups := List( FSSelfSimilarSemigroupsDefs, SelfSimilarSemigroup );

  T := Group([FSSelfSimilarGroups[2].1^2, FSSelfSimilarGroups[2].2^2]);

  Add( FSSelfSimilarGroups, T);

  for l in FSSelfSimilarGroups do
    AssertTrue( IsFiniteState(l));
  od;

  for l in FSSelfSimilarSemigroups do
    AssertTrue( IsFiniteState(l));
  od;

  AssertEqual( NumberOfStates( UnderlyingAutomaton( UnderlyingAutomatonGroup( FSSelfSimilarGroups[1]))),15);
  AssertEqual( NumberOfStates( UnderlyingAutomaton( UnderlyingAutomatonGroup( FSSelfSimilarGroups[2]))),51);
  AssertEqual( NumberOfStates( UnderlyingAutomaton( UnderlyingAutomatonGroup( FSSelfSimilarGroups[3]))),5);
  AssertEqual( NumberOfStates( UnderlyingAutomaton( UnderlyingAutomatonGroup(T))),52);


  AssertEqual(NumberOfStates(UnderlyingAutomaton(UnderlyingAutomatonSemigroup(FSSelfSimilarSemigroups[1]))),5);

  for G in FSSelfSimilarGroups do
    hom := MonomorphismToAutomatonGroup(G);
    for count in [1..10] do
      w:=Random(G);
      AssertEqual(w,PreImagesRepresentative(hom,w^hom));
    od;
  od;

  for G in FSSelfSimilarSemigroups do
    hom := MonomorphismToAutomatonSemigroup(G);
    for count in [1..10] do
      w:=Random(G);
      AssertEqual(w,PreImagesRepresentative(hom,w^hom));
    od;
  od;


end);
