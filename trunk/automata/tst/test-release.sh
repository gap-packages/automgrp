#! /bin/sh

gapdir=$1
if [ -z "$gapdir" -o ! -d "$gapdir" -o ! -d "$gapdir/pkg" ]; then
  echo "Usage: $0 GAP_DIR"
  exit 1
fi

script=`mktemp`
script_all=`mktemp`

cat > $script << HERE_EOF
LoadPackage("automgrp");
AG_Globals.run_tests_forever := true;
Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.g"));
HERE_EOF

cp $script $script_all
cat >> $script_all << HERE_EOF
LoadAllPackages();
AG_Globals.run_tests_forever := true;
Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.g"));
HERE_EOF

mkdir $gapdir/pkg-bak || exit 1
mv $gapdir/pkg/* $gapdir/pkg-bak/ || exit 1
mv $gapdir/pkg-bak/automgrp $gapdir/pkg-bak/fga $gapdir/pkg/ || exit 1
gap $script
mv $gapdir/pkg-bak/* $gapdir/pkg/ || exit 1
rmdir $gapdir/pkg-bak
gap $script_all

rm $script $script_all
