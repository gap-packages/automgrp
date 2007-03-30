BV(GrigorchukGroup);
__fgrp := FamilyObj(a)!.freegroup;
__fgens := FamilyObj(a)!.freegens;
__elms := [__fgens[1]*__fgens[2], __fgens[1]*__fgens[3], __fgens[1]*__fgens[4]];

iterate := function(seq)
  local result, i;

  result := [];
  for i in seq do
    Append(result, [2, (i-2) mod 3 + 1]);
  od;

  return result;
end;

makeword4 := function(seq)
  local w, s;

  w := One(__fgrp);

  for s in seq do
    w := w * __elms[s];
  od;

  return Autom(w^4, FamilyObj(a));
end;

w := [3];
for i in [1..100] do
#   g1 := makeword(w);
  g2 := makeword4(List(w, i->i^(1,2,3)));
  g3 := makeword4(List(w, i->i^(1,3,2)));
  if IsOne(g2) then
    if IsOne(g3) then
      Print(i, ": yes\n");
    else
      Print(i, ": only one\n");
    fi;
  elif IsOne(g3) then
    Print(i, ": only one\n");
  else
    Print(i, ": no\n");
  fi;
  w := iterate(w);
od;
