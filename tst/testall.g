LoadPackage("automgrp");
dirs := DirectoriesPackageLibrary("automgrp", "tst");
# GAP wraps long output differently across versions, so compare up to
# whitespace, as TestPackage does
TestDirectory(dirs, rec(exitGAP := true,
                        testOptions := rec(compareFunction := "uptowhitespace")));
