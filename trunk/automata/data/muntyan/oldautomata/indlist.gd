#############################################################################
##
#W  indlist.gi              automata package                   Yevgen Muntyan
##
##  automata v0.9, started 01/22/2004
##


DeclareCategory("IsIndexedList", IsObject);

DeclareOperation("IndexedList", [IsList, IsList]);
DeclareOperation("IsBoundInIndexedList", [IsObject, IsObject]);
DeclareOperation("Put", [IsIndexedList, IsObject, IsObject]);
DeclareOperation("Remove", [IsObject, IsObject]);
DeclareOperation("SubList", [IsObject, IsObject]);
DeclareOperation("Indexes", [IsObject]);
DeclareOperation("Values", [IsObject]);
DeclareOperation("UnionOfIndexedLists", [IsIndexedList, IsIndexedList]);








