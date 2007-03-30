rws := FARewritingSystem(4, Reversed([
  [[-1], [1]], [[-2], [2]], [[-3], [3]], [[-4], [2,3]], [[4], [2,3]],
  [[1,1], []], [[2,2], []], [[3,3], []], [[3,2], [2,3]],]));
Print(rws, "\n");

BV(GrigorchukGroup);
g := Group(a*b, a*c);

rws := FARewritingSystem(4, [
  [[-4], [2,3]],
  [[4], [2,3]],
  [[1,1], []],
  [[-1,-1], []],
  [[2,2], []],
  [[-2,-2], []],
  [[3,3], []],
  [[-3,-3], []],
  [[3,2], [2,3]],
  [[3,-2], [2,3]],
  [[-3,2], [2,3]],
  [[-3,-2], [2,3]],
  [[-1], [1]],
  [[-2], [2]],
  [[-3], [3]],
]);

# build_words :=
# function(letters, maxlen)
#   local words, i, j, w;
#
#   words := List([1..maxlen], i->[]);
#   words[1] := Concatenation(List([1..letters], i->[[i], [-i]]));
#
#   for i in [1 .. maxlen-1] do
#     for w in words[i] do
#       for j in [1..letters] do
#         if j <> -w[i] then
#           Add(words[i+1], Concatenation(w, [j]));
#         fi;
#         if j <> w[i] then
#           Add(words[i+1], Concatenation(w, [-j]));
#         fi;
#       od;
#     od;
#   od;
#
#   return Concatenation(words);
# end;
