#############################################################################
##
#W  utilsratfun.gi             automata package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##  automata v 0.91 started June 07 2004
##
#Y  Copyright (C) 2003-2004 Yevgen Muntyan, Dmytro Savchuk
##


#############################################################################
##
#F  AbelImageAutomatonInList(<list>)
##
InstallGlobalFunction(AbelImageAutomatonInList,
function(list)
  local zero, one, x, m, mk, e, n, d, s, i, det, detk, result;

  n := Length(list);
  d := Length(list[1]) - 1;
  x := AutomataAbelImageIndeterminate;
  m := IdentityMat(n, x);
  e := [];
  zero := 0*x;
  one := x^0;

  for s in [1..n] do
    for i in [1..d] do
      m[s][list[s][i]] := m[s][list[s][i]] + x;
    od;
    if (list[s][d+1] = ()) then e[s] := zero;
    else e[s] := one; fi;
  od;

  result := [];
  det := Determinant(m);
  for s in [1..n] do
    mk := StructuralCopy(m);
    for i in [1..n] do
      mk[i][s] := e[i];
    od;
    detk := Determinant(mk);
    result[s] := detk / det;
  od;

  return result;
end);


#E
