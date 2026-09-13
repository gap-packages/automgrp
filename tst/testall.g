LoadPackage("automgrp");
dirs := DirectoriesPackageLibrary("automgrp", "tst");
files := Filtered(DirectoryContents(dirs[1]),
                  f -> Length(f) > 4 and f{[Length(f) - 3 .. Length(f)]} = ".tst");
# automgrp05.tst holds the examples of the FR converters, which need the
# suggested package FR
if not IsPackageMarkedForLoading("fr", "") then
  files := Difference(files, ["automgrp05.tst"]);
fi;
# GAP wraps long output differently across versions, so compare up to
# whitespace, as TestPackage does
TestDirectory(List(Set(files), f -> Filename(dirs[1], f)),
              rec(exitGAP := true,
                  testOptions := rec(compareFunction := "uptowhitespace")));
