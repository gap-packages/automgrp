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
              "IsSphericallyTransitive(IsAutomaton and IsActingOnBinaryTree)",
              [IsAutomaton and IsActingOnBinaryTree],
function(a)
  local ab;
  Info(InfoAutomata, 3, "IsSphericallyTransitive(a): using AbelImage");
  ab := AbelImage(a);
  return ab = One(ab)/(One(ab)+IndeterminateOfUnivariateRationalFunction(ab));
end);


###############################################################################
##
#M  AbelImage (<a>)
##
InstallMethod(AbelImage, "AbelImage(IsAutomaton)", [IsAutomaton],
function(a)
  local ab;
  return AbelImageAutomatonInList(AutomatonList(a))[AutomatonListInitialState(a)];
end);


#E
