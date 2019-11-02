within InaMo.Components.IonChannels;
model GateABT "gating molecule with two conformations/positions X and Y governed by three functions alpha, beta and tau"
  import InaMo.Components.FittingFunctions.*;
  import Modelica.SIunits.Conversions.from_degC;
  replaceable function falpha = goldmanFit(V_off=0, sdn=1, sV=1) "rate of transfer from conformation Y to X";
  replaceable function fbeta = scaledExpFit(x0=0, sx=1, sy=1) "rate of transfer from conformation X to Y";
  replaceable function ftau = generalizedLogisticFit(y_min=0, y_max=1, x0=0, sx=1, se=1) "time until steady state is reached if current voltage is held constant";
  Real n(start=falpha(0)/(falpha(0) + fbeta(0)), fixed=true) "ratio of molecules in conformation X";
  input SI.ElectricPotential V "membrane potential";
  Real n_steady "value that n would reach if current voltage was kept constant";
equation
  n_steady = falpha(V)/(falpha(V) + fbeta(V));
  der(n) = (n_steady - n)/ftau(V);
end GateABT;
