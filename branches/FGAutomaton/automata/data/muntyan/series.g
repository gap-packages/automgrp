generate_names := function(n)
  local letters;
  letters := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  return letters{[1..n]};
end;

ratios := function (list)
  local result, i, l;
  l := Length(list);
  result := [];
  for i in [1..l-1] do
    result[i] := list[i]/list[i+1];
  od;
  return result;
end;

seriesf := function(list, n)
  local state_num, g, gens, perms, perm_group, result;

  if not IsCorrectAutomatonList(list) then
    Error("bad list\n");
  fi;

  state_num := Length(list);
  g := CreateAutom(list, generate_names(state_num));
  gens := GeneratorsOfGroup(g);

  perms := List(gens, a->Perm(a, n));
  perm_group := Group(perms);

  Print("size: ", Size(perm_group), "\n");

  result := [LowerCentralSeriesOfGroup(perm_group)];
  result[2] := ratios(List(result[1], Size));
  result[3] := PCentralSeries(perm_group);
  result[4] := ratios(List(result[3], Size));
  result[5] := JenningsSeries(perm_group);
  result[6] := ratios(List(result[5], Size));

  result := result{[2,4,6]};
  
  return result;
end;
