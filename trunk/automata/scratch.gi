printnicely := function(a)
	local listrep, pf, i, j, names, list, deg, longstring;

	listrep := ListRep(a);
	
	if Length(listrep.list) > 26 then
		Print("Sorry\n");
	fi;
	
	list := listrep.list;
	longstring := "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	names := longstring{[1..Length(list)]};
	deg := Degree(a);
	
	pf := function(w)
		if IsOne(w) then
			Print(AUTOMATA_PARAMETERS.IDENTITY_SYMBOL);
		else
			Print(w);
		fi;
	end;
	
	for i in [1..Length(list)] do
		Print([names[i]], " = (");
		for j in [1..deg] do
			Print([names[list[i][j]]]);
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
