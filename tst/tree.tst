# Grigorchuk group
gap> G := AutomatonGroup("a=(1,1)(1,2),b=(a,c),c=(a,d),d=(1,b)");
< a, b, c, d >
gap> IsActingOnRegularTree(G);
true
gap> H:=DerivedSubgroup(G);;
gap> FixesVertex(H,1);
true
gap> Projection(H,1);
< b, a^-1*c, a^-1*d >

#
gap> K:=Group(G.3);
< c >
gap> Projection(K,1);
< a >
gap> Projection(K,2);
< d >
gap> Projection(K,[2,1]);
< 1 >
