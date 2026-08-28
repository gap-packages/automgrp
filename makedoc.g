#############################################################################
##
##  makedoc.g
##
##  Builds the package documentation with AutoDoc/GAPDoc.
##
##  The declarations are documented beside the code, in <#GAPDoc> blocks under
##  gap/; the chapters pull them in with <#Include>.
##
#############################################################################

LoadPackage("AutoDoc");

# Run this from the package's root directory: gap makedoc.g
AutoDoc(rec(
    autodoc := true,
    gapdoc := true,
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
