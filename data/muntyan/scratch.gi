printnicely := function(a)
	local listrep, pf, i, j, names, list, deg, longstring;

	listrep := ListRep(a);
	
	
	list := listrep.list;
	longstring := "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	if Length(list) < 27 then 
		names := Tuples(longstring, 1);
		names := names{[1..Length(list)]};
	elif Length(list) < 26^2 + 1 then
		names := Tuples(longstring, 2);
		names := names{[1..Length(list)]};
	else
		Print("Sorry\n");
		return;
	fi;
	deg := Degree(a);
	
	pf := function(w)
		if IsOne(w) then
			Print(AUTOMATA_PARAMETERS.IDENTITY_SYMBOL);
		else
			Print(w);
		fi;
	end;
	
	for i in [1..Length(list)] do
		Print(names[i], " = (");
		for j in [1..deg] do
			Print(names[list[i][j]]);
			if j <> deg then
				Print(", ");
			fi;
		od;
		if not IsOne(list[i][deg+1]) then
			Print(")", list[i][deg+1], "\n");
		else
			Print(")\n");
		fi; 
	od;

	for i in [1..Length(list)] do
		Print(names[i], " = "); pf(listrep.names[i]); Print("\n");
	od;
end;


##################################################################

printnicely := function(a) local listrep, pf, i, j, names, list, deg, longstring; listrep :=ListRep(a);   list := listrep.list; longstring := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; if Length(list)< 27 then   names := Tuples(longstring, 1);  names := names{[1..Length(list)]}; elif Length(list) < 26^2 + 1 then  names := Tuples(longstring, 2);  names :=names{[1..Length(list)]}; else  Print("Sorry\n");  return; fi; deg := Degree(a);  pf :=function(w)  if IsOne(w) then   Print(AUTOMATA_PARAMETERS.IDENTITY_SYMBOL);  else  Print(w);  fi; end;  for i in [1..Length(list)] do  Print(names[i], " = (");  for j in[1..deg] do   Print(names[list[i][j]]);   if j <> deg then    Print(", ");   fi; od;  if not IsOne(list[i][deg+1]) then   Print(")", list[i][deg+1], "\n");  else   Print(")\n");  fi;  od; for i in [1..Length(list)] do  Print(names[i], " = "); pf(listrep.names[i]);Print("\n"); od;end; 
 