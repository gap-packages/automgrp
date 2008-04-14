#! /bin/sh

gapdir=$1
if [ -z "$gapdir" -o ! -d "$gapdir" -o ! -d "$gapdir/pkg" ]; then
  echo "Usage: $0 GAP_DIR"
  exit 1
fi

script=`mktemp`
script_all=`mktemp`

echo1 () {
cat << HERE_EOF
LoadPackage("automgrp");
AG_Globals.run_tests_forever := true;
Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.g"));
HERE_EOF
}

echo2 () {
cat << HERE_EOF
LoadAllPackages();
AG_Globals.run_tests_forever := true;
Read(Filename(DirectoriesLibrary("pkg/automgrp/tst"), "testall.g"));
HERE_EOF
}

echo1 > $script
echo "QUIT;" >> $script

echo1 > $script_all
echo2 >> $script_all
echo "QUIT;" >> $script_all

mkdir $gapdir/pkg-bak || exit 1
mv $gapdir/pkg/* $gapdir/pkg-bak/ || exit 1
mv $gapdir/pkg-bak/automgrp $gapdir/pkg-bak/fga $gapdir/pkg/ || exit 1
gap $script
mv $gapdir/pkg-bak/* $gapdir/pkg/ || exit 1
rmdir $gapdir/pkg-bak
gap $script_all

rm $script $script_all
