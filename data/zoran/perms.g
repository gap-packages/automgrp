c := (1,2,3,4,5);
S := SymmetricGroup(5);
T := Tuples(S, 3);;
Print("calculated tuples\n");
last_i := 0;
for i in [1..Length(T)] do
  t := T[i];
  a := [c, t[1], c^2, t[2], c^3, t[3], c^4];
  alpha := Product(a);
  for p in SymmetricGroup(7) do
    if p <> () and Product(Permuted(a, p)) = alpha then
      break;
    fi;
  od;
  if p = () or Product(Permuted(a, p)) <> alpha then
    Print(t, "\n");
    break;
  fi;
  if i >= last_i + 1000 then
    last_i := i;
    Print(i, "\n");
  fi;
od;


all := [];
c := (1,2,3,4,5);
S := SymmetricGroup(5);
T := Tuples(S, 2);;
Print("calculated tuples\n");
last_i := 0;
for i in [1..Length(T)] do
  t := T[i];
  a := [c, (1,2), c^2, t[1], c^3, t[2], c^4];
  alpha := Product(a);
  for p in SymmetricGroup(7) do
    if p <> () and Product(Permuted(a, p)) = alpha then
      break;
    fi;
  od;
  if p = () or Product(Permuted(a, p)) <> alpha then
    Print(t, "\n");
    Add(all, t);
  fi;
  if i >= last_i + 1000 then
    last_i := i;
    Print(i, "\n");
  fi;
od;
