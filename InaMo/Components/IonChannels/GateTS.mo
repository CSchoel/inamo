within InaMo.Components.IonChannels;
model GateTS "gating molecule with two conformations/positions X and Y governed by two functions tau and steady"
  import InaMo.Components.FittingFunctions.*;
  replaceable function ftau = generalizedLogisticFit "time until difference between n and fsteady(V) has reduced by a factor of 1/e if V is held constant";
  replaceable function fsteady = generalizedLogisticFit "value that n would reach if V is held constant";
  Real n(start=fsteady(0), fixed=true) "ratio of molecules in open conformation";
  input SI.ElectricPotential V "membrane potential";
  Real tau "time until difference between n and fsteady(V) has reduced by a factor of 1/e if V is held constant";
equation
  tau = 1 / (falpha(V) + fbeta(V));
  der(n) = (fsteady(V) - n)/tau;
end GateTS;
