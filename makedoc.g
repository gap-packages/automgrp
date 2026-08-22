#############################################################################
##
##  makedoc.g
##
##  Builds the package documentation with AutoDoc/GAPDoc.
##
##  The declarations are documented beside the code, in <#GAPDoc> blocks in the
##  files listed under gapdoc.files; the chapters pull them in with <#Include>.
##
#############################################################################

LoadPackage("AutoDoc");

# Run this from the package's root directory: gap makedoc.g
AutoDoc(rec(
    autodoc := true,
    gapdoc := rec(
        files := [
            "gap/automaton.gd",
            "gap/automfam.gd",
            "gap/autom.gd",
            "gap/automgroup.gd",
            "gap/automsg.gd",
            "gap/listops.gd",
            "gap/rws.gd",
            "gap/scilab.gd",
            "gap/selfs.gd",
            "gap/selfsim.gd",
            "gap/selfsimfam.gd",
            "gap/selfsimgroup.gd",
            "gap/selfsimsg.gd",
            "gap/treehom.gd",
            "gap/treehomsg.gd",
            "gap/treeaut.gd",
            "gap/treeautgrp.gd",
            "gap/tree.gd",
            "gap/utils.gd",
            "gap/convertersfr.gd",
            "gap/globals.g",
            "gap/groups.g",
            "gap/automaton.gi",
            "gap/automfam.gi",
            "gap/autom.gi",
            "gap/automgroup.gi",
            "gap/automsg.gi",
            "gap/listops.gi",
            "gap/rws.gi",
            "gap/scilab.gi",
            "gap/selfs.gi",
            "gap/selfsim.gi",
            "gap/selfsimfam.gi",
            "gap/selfsimgroup.gi",
            "gap/selfsimsg.gi",
            "gap/treehom.gi",
            "gap/treehomsg.gi",
            "gap/treeaut.gi",
            "gap/treeautgrp.gi",
            "gap/tree.gi",
            "gap/utilsfrgrp.gi",
            "gap/utils.gi",
            "gap/convertersfr.gi"
        ],
    ),
    extract_examples := true,
    scaffold := rec(
        includes := [
            "intro.xml",
            "groups.xml",
            "elements.xml",
            "autom.xml",
            "misc.xml"
        ],
        bib := "fa.bib",
        entities := rec(
            AutomGrp := "<Package>AutomGrp</Package>",
        ),
    ),
));

QuitGap();
