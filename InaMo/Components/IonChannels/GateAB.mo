within InaMo.Components.IonChannels;
model GateAB "gating molecule with two conformations/positions X and Y governed by two functions alpha and beta"
  import InaMo.Components.FittingFunctions.*;
  import Modelica.SIunits.Conversions.from_degC;
  replaceable function falpha = goldmanFit(V_off=0, sdn=1, sV=1) "rate of transfer from conformation Y to X";
  replaceable function fbeta = scaledExpFit(sx=1, sy=1) "rate of transfer from conformation X to Y";
  Real n(start=falpha(0)/(falpha(0) + fbeta(0)), fixed=true) "ratio of molecules in conformation X";
  input SI.ElectricPotential V "membrane potential";
equation
  der(n) = falpha(V) * (1 - n) - fbeta(V) * n;
end GateAB;
