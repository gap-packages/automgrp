[![Build Status](https://github.com/gap-packages/automgrp/actions/workflows/CI.yml/badge.svg)](https://github.com/gap-packages/automgrp/actions/workflows/CI.yml)
[![Code Coverage](https://codecov.io/github/gap-packages/automgrp/coverage.svg)](https://codecov.io/gh/gap-packages/automgrp)

The AutomGrp package
====================

The AutomGrp package provides methods for computations with groups and
semigroups generated by finite automata or given by wreath recursions, as well
as with their finitely generated subgroups, subsemigroups and elements.

This package is a free software and you can do pretty much anything you want
with it. See LICENSE file for the exact terms.


Authors
-------

The AutomGrp package is written by:

Yevgen Muntyan
Bellevue, WA, USA
e-mail: muntyan@fastmail.fm

Dmytro Savchuk
Department of Mathematics and Statistics
University of South Florida
Tampa, FL, 33620
e-mail: dmytro.savchuk@gmail.com
www: http://savchuk.myweb.usf.edu/


Installing the AutomGrp package
-------------------------------

Since AutomGrp is distributed with GAP, normally you should not have to install it,
it will already be present. But if you e.g. want to use a newer version than what is
shipped with GAP, you can do the following:

First, download the latest version from <https://gap-packages.github.io/automgrp/>.
This will give you an archive file with a name like `automgrp-X.Y.Z.tar.bz2`, where
`X.Y.Z` stands in for the actual version number.
To install the AutomGrp package, move the archive file `automgrp-X.Y.Z.tar.bz2` or
`automgrp-X.Y.Z.tar.gz` (`automgrp-X.Y.Z-win.zip` if you are using a Windows system)
into the `pkg` directory of your GAP installation, and unpack it. See section
"ref:Installing GAP Packages" of the GAP 4 reference manual for details and
additional options for installing GAP packages.

Restart GAP and load the package by issuing at the GAP prompt the command:

    LoadPackage( "AutomGrp" );


Execute the following at the GAP prompt to test the installation:

    Read( Filename( DirectoriesPackageLibrary( "automgrp", "tst" ), "testall.g" ) );


Bug reports, comments, etc.
---------------------------

If you encounter problems or have questions or comments, please use the
issue tracker at <https://github.com/fingolfin/automgrp/issues>.

When sending a bug report, please include:

* A GAP script that demonstrates the problem.

* The exact version of GAP you are using, ideally the whole "banner"
  GAP prints during startup.

* The output of the following command in GAP:

  PackageInfo("AutomGrp")[1].Version;

* The operating system you are using e.g. Debian Linux, Windows, macOS, etc.
