#############################################################################
##
#W  automaton.gi               automata package                Yevgen Muntyan
#W                                                             Dmytro Savchuk
##
##  automata v 0.91 started June 07 2004
##

Revision.automaton_gi :=
  "@(#)$Id$";


###############################################################################
##
#M  IsSphericallyTransitive (<a>)
##
InstallMethod(IsSphericallyTransitive,
              "method for IsAutomaton acting on binary tree",
              [IsAutomaton and IsActingOnBinaryTree],
function(a)
  local ab;
  Info(InfoAutomata, 3, "IsSphericallyTransitive(a): using AbelImage");
  ab := AbelImageAutomatonInList(AutomatonList(a))[AutomatonListInitialState(a)];
  return ab = One(ab)/(One(ab)+IndeterminateOfUnivariateRationalFunction(ab));
end);


#E
