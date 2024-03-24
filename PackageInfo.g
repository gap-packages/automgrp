#############################################################################
##
##  PackageInfo.g for the package `automgrp'
##

SetPackageInfo(rec(

PackageName := "AutomGrp",
Subtitle := "Automata groups",
Version := "1.3.2",
Date := "30/09/2019", # dd/mm/yyyy format
License := "MIT",

Persons := [
  rec(
    LastName      := "Muntyan",
    FirstNames    := "Yevgen",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "muntyan@fastmail.fm",
    PostalAddress := "",
    Place         := "Bellevue, WA, USA",
    Institution   := ""
  ),
  rec(
    LastName      := "Savchuk",
    FirstNames    := "Dmytro",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "dmytro.savchuk@gmail.com",
    WWWHome       := "http://savchuk.myweb.usf.edu/",
    PostalAddress := "Dept of Mathematics and Statistics, University of South Florida, 4202 E Fowler Ave, CMC 342, Tampa, FL, 33647, USA",
    Place         := "Tampa, FL, USA",
    Institution   := "University of South Florida"
  ),
],

Status := "accepted",
CommunicatedBy := "Leonard Soicher (Queen Mary, London)",
AcceptDate := "03/2016",

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/automgrp",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://gap-packages.github.io/automgrp",
README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/automgrp-", ~.Version ),
ArchiveFormats  := ".tar.gz .tar.bz2",

##  Here you  must provide a short abstract explaining the package content
##  in HTML format (used on the package overview Web page) and an URL
##  for a Webpage with more detailed information about the package
##  (not more than a few lines, less is ok):
##  Please, use '<span class="pkgname">GAP</span>' and
##  '<span class="pkgname">MyPKG</span>' for specifing package names.
##
AbstractHTML := "The <span class=\"pkgname\">AutomGrp</span> package provides \
methods for computations with groups and semigroups generated by finite automata \
or given by wreath recursion, as well as with their finitely generated subgroups \
and elements.",

PackageDoc := rec(
 # use same as in GAP
 BookName  := "AutomGrp",
 ArchiveURLSubset := ["doc", "htm"],
 HTMLStart := "htm/chapters.htm",
 PDFFile   := "doc/manual.pdf",
 # the path to the .six file used by GAP's help system
 SixFile   := "doc/manual.six",
 # a longer title of the book, this together with the book name should
 # fit on a single text line (appears with the '?books' command in GAP)
 # LongTitle := "Elementary Divisors of Integer Matrices",
 LongTitle := "Automata Groups",
 # Should this help book be autoloaded when GAP starts up? This should
 # usually be 'true', otherwise say 'false'.
 Autoload  := true
),

##  Are there restrictions on the operating system for this package? Or does
##  the package need other packages to be available?
Dependencies := rec(
  # GAP version, use version strings for specifying exact versions,
  # prepend a '>=' for specifying a least version.
  GAP := ">=4.9.1",
  # list of pairs [package name, (least) version],  package name is case
  # insensitive, least version denoted with '>=' prepended to version string.
  # without these, the package will not load
  # NeededOtherPackages := [["GAPDoc", ">= 0.99"]],
  NeededOtherPackages := [["FGA", ">= 1.1.0.1"]],
  # without these the package will issue a warning while loading
  SuggestedOtherPackages := [["FR", ">= 2.0.0"]],
  # needed external conditions (programs, operating system, ...)  provide
  # just strings as text or
  # pairs [text, URL] where URL  provides further information
  # about that point.
  # (no automatic test will be done for this, do this in your
  # 'AvailabilityTest' function below)
  # ExternalConditions := []
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

##  The LoadPackage mechanism can produce a default banner from the info
##  in this file. If you are not happy with it, you can provide a string
##  here that is used as a banner. GAP decides when the banner is shown and
##  when it is not shown. *optional* (note the ~-syntax in this example)
BannerString := Concatenation(
  "----------------------------------------------------------------\n",
  "     ^                                    ___                   \n",
  "    / \\                                  /   \\                  \n",
  "   /   \\           _______  ___         ||        ___   __      \n",
  "  /_____\\   ||  ||    |    /   \\  |\\ /| ||   __ |/   | |  \\    \n",
  " /       \\  ||  ||    |   ||   || | V | ||   || |      |__/    \n",
  "/         \\  \\__/     |    \\___/  |   |  \\___/  |      |        \n",
  "                                                                \n",
  "Loading  AutomGrp ", ~.Version, " (Automata Groups and Semigroups)\n",
  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,
        " (", ~.Persons[1].Email, ")\n",
  "   ", ~.Persons[2].FirstNames, " ", ~.Persons[2].LastName,
        " (", ~.Persons[2].WWWHome, ")\n",
  "Homepage: ", ~.PackageWWWHome, "\n",
  "----------------------------------------------------------------\n" ),

##  Suggest here if the package should be *automatically loaded* when GAP is
##  started.  This should usually be 'false'. Say 'true' only if your package
##  provides some improvements of the GAP library which are likely to enhance
##  the overall system performance for many users.
Autoload := true,

##  *Optional*, but recommended: path relative to package root to a file which
##  contains as many tests of the package functionality as sensible.
TestFile := "tst/testall.g",

##  *Optional*: Here you can list some keyword related to the topic
##  of the package.
# Keywords := ["Smith normal form", "p-adic", "rational matrix inversion"]
Keywords := ["finite automata", "tree automorphisms", "self-similar groups", "wreath recursion"]

));
