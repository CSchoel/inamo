within InaMo.Components.IonChannels;
model GateABS "gating molecule with two conformations/positions X and Y governed by three functions alpha, beta and steady"
  import InaMo.Components.FittingFunctions.*;
  replaceable function falpha = goldmanFit(x0=0, sx=1, sy=1) "rate of transfer from closed to open conformation";
  replaceable function fbeta = scaledExpFit(x0=0, sx=1, sy=1) "rate of transfer from conformation X to Y";
  replaceable function fsteady = generalizedLogisticFit(y_min=0, y_max=1, x0=0, sx=1, se=1) "value that n would reach if V is held constant";
  Real n(start=fsteady(0), fixed=true) "ratio of molecules in open conformation";
  input SI.ElectricPotential V "membrane potential";
  Real tau "time until difference between n and fsteady(V) has reduced by a factor of 1/e if V is held constant";
equation
  tau = 1 / (falpha(V) + fbeta(V));
  der(n) = (fsteady(V) - n)/tau;
end GateABS;
