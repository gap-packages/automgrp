S:=SelfSimilarSemigroup("a=(a*b,1)[1,1],b=(b^2,b*a)(1,2)");
G:=SelfSimilarGroup("a=(b,a^-1*b)(1,2),b=(b,a^-2)");
H:=Group([a*b,b^2]);
D:=Semigroup([a^2*b,b^4*a*b^2,a*b*a]);

AutomGrpToFR(S);


gap> G:=SelfSimilarGroup("a=(b,a^-1*b)(1,2),b=(b,a^-2)");
< a, b >
gap> testf(G);
<FR machine with alphabet [ 1 .. 2 ] on Group( [ a, b ] )>
gap> Display(G);
< a = (b, a^-1*b)(1,2),
  b = (b, a^-2) >
gap> Display(testf(G));
 G |  1          2
---+-----+----------+
 a | b,2   a^-1*b,1
 b | b,1     a^-2,2
---+-----+----------+
gap> G:=SelfSimilarSemigroup("a=(b,a^-1*b)(1,2),b=(b,a^-2)");
< a, b >
gap> Display(testf(G));
 G |  1          2
---+-----+----------+
 a | b,2   a^-1*b,1
 b | b,1     a^-2,2
---+-----+----------+
gap> G:=SelfSimilarSemigroup("a=(b,a*b)[1,2],b=(b,a^2)");
< a, b >
gap> Display(G);
< a = (b, a*b),
  b = (b, a^2) >
gap> Display(testf(G));
 G |  1       2
---+-----+-------+
 a | b,1   a*b,2
 b | b,1   a^2,2
---+-----+-------+
gap> G:=SelfSimilarSemigroup("a=(b,a*b)[1,2],b=(b,a^2)[2,2]");
< a, b >
gap> Display(testf(G));
 M |  1       2
---+-----+-------+
 a | b,1   a*b,2
 b | b,2   a^2,2
---+-----+-------+
gap> G:=SelfSimilarSemigroup("a=(b,a*b)[1,2],b=(1,a^2)[2,2]");
< a, b >
gap> Display(testf(G));
 M |     1       2
---+--------+-------+
 a |    b,1   a*b,2
 b | <id>,2   a^2,2
---+--------+-------+
gap> Display(G);
< a = (b, a*b),
  b = (1, a^2)[2,2] >
gap> G:=SelfSimilarSemigroup("a=(b,a*b)(1,2),b=(1,a^2)[2,2]");
< a, b >
gap> Display(G);
< a = (b, a*b)[2,1],
  b = (1, a^2)[2,2] >
gap> Display(testf(G));
 M |     1       2
---+--------+-------+
 a |    b,2   a*b,1
 b | <id>,2   a^2,2
---+--------+-------+
gap> G:=SelfSimilarGroup("a=(b^-1,a*b)(1,2),b=(1,a^2)");
< a, b >
gap> Display(testf(G));
 G |     1       2
---+--------+-------+
 a | b^-1,2   a*b,1
 b | <id>,1   a^2,2
---+--------+-------+
gap> Display(G);
< a = (b^-1, a*b)(1,2),
  b = (1, a^2) >
gap> M:=testf(G);
<FR machine with alphabet [ 1 .. 2 ] on Group( [ a, b ] )>
gap> GeneratorsOfFRMachine(M);
[ a, b ]
gap> WreathRecursion(M)(GeneratorsOfFRMachine(M)[1]);
[ [ b^-1, a*b ], [ 2, 1 ] ]
gap> Decompose(a);
(b^-1, a*b)(1,2)
