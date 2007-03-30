BV(GrigorchukGroup);
__fgrp := FamilyObj(a)!.freegroup;
__fgens := FamilyObj(a)!.freegens;
__elms := [__fgens[1]*__fgens[2], __fgens[1]*__fgens[3], __fgens[1]*__fgens[4]];

makeword := function(seq)
  local w, s;

  w := One(__fgrp);

  for s in seq do
    w := w * __elms[s];
  od;

  return Autom(w, FamilyObj(a));
end;

checkseq := function(seq)
  return IsOne(makeword(seq)) and IsOne(makeword(List(seq, i->i^(1,2,3))));
end;
