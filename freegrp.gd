#############################################################################
##
#W  freegrp.gd               automata package                  Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


#############################################################################
##
#O  Nielsen(args)
#O  NielsenBack(args)
##
DeclareOperation("Nielsen", [IsList]);
DeclareOperation("NielsenBack", [IsList]);

DeclareOperation("CalculateWord", [IsAssocWord, IsList]);
DeclareOperation("CalculateWords", [IsList, IsList]);


DeclareOperation("Mihaylov", [IsList]);

DeclareOperation("Rang", [IsList]);

DeclareOperation("Contains", [IsList, IsObject]);

DeclareOperation("NumberOfLetters", [IsList]);
DeclareOperation("NielsenLow", [IsList, IsInt, IsInt]);
DeclareOperation("NielsenMihaylov", [IsList, IsInt, IsInt]);













