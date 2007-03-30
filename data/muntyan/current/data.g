AutomataParameters.identity_symbol := "1";

GrigorchukGroup := AutomGroupNoBindGlobal("a=(1,2), b=(a,c), c=(a,d), d=(1,b)");
UGrigorchukGroup := AutomGroupNoBindGlobal("a=(1,2)(3,4)(5,6), b=(1,c,a,c,a,c), c=(a,d,1,d,a,d), d=(a,b,a,b,1,b)");
AddingMachine := AutomGroupNoBindGlobal("t=(1,t)(1,2)");
Bellaterra := AutomGroupNoBindGlobal("a=(c,b), b=(b,c), c=(a,a)(1,2)");
Basilica := AutomGroupNoBindGlobal("a=(1,b)(1,2), b=(1,a)");
Aleshin := AutomGroupNoBindGlobal("a=(c,b)(1,2), b=(b,c)(1,2), c=(a,a)");

BV := function(g)
  local i, fam;
  fam := UnderlyingAutomFamily(g);
  for i in [1..fam!.numstates] do
    if IsBoundGlobal(fam!.names[i]) then
      UnbindGlobal(fam!.names[i]);
    fi;
    BindGlobal(fam!.names[i], fam!.automgens[i]);
    MakeReadWriteGlobal(fam!.names[i]);
  od;
end;

TA := TreeAutomorphism;
AG := AutomGroup;
Gens := GeneratorsOfGroup;
FreeGens := FreeGeneratorsOfGroup;
