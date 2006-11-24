S := ListX ([(),(1,2)],[(),(1,2)],[(),(1,2)],[1..3],[1..3],[1..3],[1..3],[1..3],[1..3],
function(y3, y2, y1, x32, x31, x22, x21, x12, x11)
  return [[x11,x12,y1],[x21,x22,y2],[x31,x32,y3]];
end);;

trans1 := function(l)
  local r, j;
  r := [[],[],[]];
  for j in [1..3] do
    r[j][3] := l[j^(1,2)][3];
    r[j][1] := (l[j^(1,2)][1])^(1,2);
    r[j][2] := (l[j^(1,2)][2])^(1,2);
  od;
  return r;
end;;

trans2 := function(l)
  local r, j;
  r := [[],[],[]];
  for j in [1..3] do
    r[j][3] := l[j^(1,3)][3];
    r[j][1] := (l[j^(1,3)][1])^(1,3);
    r[j][2] := (l[j^(1,3)][2])^(1,3);
  od;
  return r;
end;;

star := l -> [[l[1][2], l[1][1], l[1][3]],
              [l[2][2], l[2][1], l[2][3]],
              [l[3][2], l[3][1], l[3][3]]];;

s1 := List(S, trans1);;
s2 := List(S, trans2);;
s3 := List(S, star);;

p1 := PermListList(S, s1);
p2 := PermListList(S, s2);
p3 := PermListList(S, s3);
G := Group(p1, p2, p3);

orbs := OrbitsPerms(G, [1..Size(S)]);;
all_nums := List(orbs, o -> Minimum(o));;

is3aut := function (l)
  local red;
  red := ReducedAutomatonInList(l);
  if Length(red[1]) = Length(l) then
    return true;
  else
    return false;
  fi;
end;;
three_nums := Filtered(all_nums, i -> is3aut(S[i]));

check_dual := function(list)
  local i, j, p;
  p := [[],[]];
  for i in [1, 2] do
    for j in [1..3] do
      p[i][j] := list[j][i];
    od;
    p[i] := PermListList([1..3], p[i]);
    if p[i] = fail then
      return [false];
    fi;
  od;
  return [true, p[1], p[2]];
end;;

all_dualizible := [];;
for i in three_nums do
  d := check_dual(S[i]);
  if d[1] then
    Print(i, " ", d[2], " ", d[3], "\n");
    Add(all_dualizible, i);
  fi;
od;

all_all_dualizible := [];;
for i in all_nums do
  d := check_dual(S[i]);
  if d[1] then
    Print(i, " ", d[2], " ", d[3], "\n");
    Add(all_all_dualizible, i);
  fi;
od;
