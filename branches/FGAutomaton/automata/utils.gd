#############################################################################
##
#W  utils.gd                   automata package                Yevgen Muntyan
##                                                              Dmytro Sachuk
##
##  automata v 0.91 started June 07 2004
##

Revision.utils_gd := 
  "@(#)$Id$";


DeclareCategory("IsIndexedList", IsObject);

DeclareOperation("IndexedList", [IsList, IsList]);
DeclareOperation("IsBoundInIndexedList", [IsObject, IsObject]);
DeclareOperation("Put", [IsIndexedList, IsObject, IsObject]);
DeclareOperation("Remove", [IsObject, IsObject]);
DeclareOperation("SubList", [IsObject, IsObject]);
DeclareOperation("Indexes", [IsObject]);
DeclareOperation("Values", [IsObject]);
DeclareOperation("UnionOfIndexedLists", [IsIndexedList, IsIndexedList]);


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

#E