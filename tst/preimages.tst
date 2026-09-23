#@local G, H, hom, K, R, UR
gap> START_TEST("preimages.tst");

# membership in the range of these monomorphisms may be undecidable, so
# checked preimages must not test it
gap> G := SelfSimilarGroup("x=(1,y)(1,2),y=(z^-1,1)(1,2),z=(1,x*y)");;
gap> H := UnderlyingAutomatonGroup(G);;
gap> hom := MonomorphismToAutomatonGroup(G);;
gap> List(GroupNucleus(H), x -> PreImagesRepresentative(hom, x)) = GroupNucleus(G);
true
gap> List(GroupNucleus(H), x -> PreImagesElm(hom, x)) = List(GroupNucleus(G), x -> [x]);
true
gap> GeneratorsOfGroup(PreImagesSet(hom, Group(GroupNucleus(H){[2]}))) = GroupNucleus(G){[2]};
true
gap> K := Group(G.1*G.2, G.3);;
gap> hom := MonomorphismToAutomatonGroup(K);;
gap> PreImagesRepresentative(hom, (G.1*G.2*G.3^2)^hom);
x*y*z^2
gap> R := SelfSimilarSemigroup("a=(1,1)[1,1], b=(a*c,1)(1,2), c=(1,a*b)");;
gap> UR := UnderlyingAutomatonSemigroup(R);;
gap> hom := MonomorphismToAutomatonSemigroup(R);;
gap> List(GeneratorsOfSemigroup(UR), x -> PreImagesRepresentative(hom, x));
[ 1, a, b, c, a*b ]

#
gap> STOP_TEST("preimages.tst");
