$SAGE := rec();

$SAGE.ErrorHandler := function(m,a,m2,mode)
    PrintTo("*errout*", [m,a,m2,mode], "\n");
#     if a <> fail then
#         PrintTo("*errout*", a, "\n");
#     fi;
    SetErrorHandler($SAGE.ErrorHandler);
    return true;
end;

SetErrorHandler($SAGE.ErrorHandler);
