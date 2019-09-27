LoadPackage("automgrp");
dirs := DirectoriesPackageLibrary("automgrp", "tst");
TestDirectory(dirs, rec(exitGAP := true));
