#############################################################################
##
#W  init.g                  automata package                   Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.init_g :=
  "@(#)$Id$";

DeclareAutoPackage("automata", "0.91", ReturnTrue);


ReadPkg("automata", "globals.g");

ReadPkg("automata", "automaton.gd");
ReadPkg("automata", "initialautomaton.gd");
ReadPkg("automata", "listops.gd");
ReadPkg("automata", "fgautom.gd");
ReadPkg("automata", "fgautomgroup.gd");
ReadPkg("automata", "utils.gd");

ReadPkg("automata", "automaton.gi");
ReadPkg("automata", "initialautomaton.gi");
ReadPkg("automata", "listops.gi");
ReadPkg("automata", "fgautom.gi");
ReadPkg("automata", "fgautomgroup.gi");
ReadPkg("automata", "utils.gi");

#ReadPkg("automata", "selfs.g");
#ReadPkg("automata", "autom32.g");


#E
