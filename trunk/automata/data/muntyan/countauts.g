S := ListX ([(),(1,2)],[(),(1,2)],[(),(1,2)],[1..3],[1..3],[1..3],[1..3],[1..3],[1..3],
function(y3, y2, y1, x32, x31, x22, x21, x12, x11)
  return [[x11,x12,y1],[x21,x22,y2],[x31,x32,y3]];
end);

trans1 := function(l)
  local r, j;
  r := [[],[],[]];
  for j in [1..3] do
    r[j][3] := l[j^(1,2)][3];
    r[j][1] := (l[j^(1,2)][1])^(1,2);
    r[j][2] := (l[j^(1,2)][2])^(1,2);
  od;
  return r;
end;

trans2 := function(l)
  local r, j;
  r := [[],[],[]];
  for j in [1..3] do
    r[j][3] := l[j^(1,3)][3];
    r[j][1] := (l[j^(1,3)][1])^(1,3);
    r[j][2] := (l[j^(1,3)][2])^(1,3);
  od;
  return r;
end;

star := l -> [[l[1][2], l[1][1], l[1][3]],
              [l[2][2], l[2][1], l[2][3]],
              [l[3][2], l[3][1], l[3][3]]];

inv := function (l)
  local r, i;
  
  r := [[],[],[]];
  for i in [1..3] do
    r[i][3] := l[i][3];
    if l[i][3] = (1,2) then
      r[i][1] := l[i][2];
      r[i][2] := l[i][1];
    else
      r[i][1] := l[i][1];
      r[i][2] := l[i][2];
    fi;
  od;
  return r;
end;

s1 := List(S, trans1);;
s2 := List(S, trans2);;
s3 := List(S, star);;
s4 := List(S, inv);;


p1 := PermListList(S, s1);
p2 := PermListList(S, s2);
p3 := PermListList(S, s3);
p4 := PermListList(S, s4);
G := Group(p1, p2, p3, p4);

orbs := OrbitsPerms(G, [1..Size(S)]);;
all_nums := List(orbs, o -> Minimum(o));;
auts := List(orbs, o -> S[Minimum(o)]);;

is3aut := function (l)
  local red;
  red := ReducedAutomatonInList(l);
  if Length(red[1]) = Length(l) then
    return true;
  else 
    return false;
  fi;
end;
three_auts := Filtered(auts, is3aut);
three_nums := Filtered(all_nums, i -> is3aut(S[i]));

agr := List(three_auts, l -> CreateAutom(l, ["a","b","c"]));
three_gr := Filtered(agr, g -> (Length(GeneratorsOfGroup(g)) = 3));
two_gr := Filtered(agr, g -> (Length(GeneratorsOfGroup(g)) = 2));

three_fam := List(three_gr, g -> FamilyObj(GeneratorsOfGroup(g)[1]));
two_fam := List(two_gr, g -> FamilyObj(GeneratorsOfGroup(g)[1]));


frac := List(three_nums, i -> [i, IsFractalByWords(FamilyObj(GeneratorsOfGroup(CreateAutom(S[i],["a","b","c"]))[1]))]);
