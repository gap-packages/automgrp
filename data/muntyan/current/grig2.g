BV(GrigorchukGroup);
IsContracting(GrigorchukGroup);
__fgrp := FamilyObj(a)!.freegroup;
__fgens := FamilyObj(a)!.freegens;
__elms := [__fgens[1]*__fgens[2], __fgens[1]*__fgens[3], __fgens[1]*__fgens[4]];

makeword := function(seq)
  local w, s;

  w := One(__fgrp);

  for s in seq do
    w := w * __elms[s];
  od;

  return Autom(w, UnderlyingAutomFamily(GrigorchukGroup));
end;

checkseq := function(seq)
  return IsOne(makeword(seq)) and IsOne(makeword(List(seq, i->i^(1,2,3))));
end;

maketuples := function(n)
  local args;
  args := List([1..n], i->[1,2,3]);
  Add(args, function(arg) return arg; end);
  return CallFuncList(ListX, args);
end;

for t in maketuples(8) do
  if checkseq(t) then
    Print(t, "\n");
  elif IsOne(makeword(t)) then
    Print("only one: ", t, "\n");
  fi;
od;
