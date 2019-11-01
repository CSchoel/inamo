within InaMo.Components.IonChannels;
model Gate "gating molecule with two conformations/positions A and B"
  import InaMo.Components.FittingFunctions.*;
  replaceable function falpha = goldmanFit(V_off=0, sdn=1, sV=1) "rate of transfer from conformation B to A";
  replaceable function fbeta = scaledExpFit(sx=1, sy=1) "rate of transfer from conformation A to B";
  Real n(start=falpha(0)/(falpha(0) + fbeta(0)), fixed=true) "ratio of molecules in conformation A";
  input Real V(unit="mV") "membrane potential (as displacement from resting potential)";
  TemperatureInput T;
protected
  Real phi = 3^((T-6.3)/10);
equation
  der(n) = phi * (falpha(V) * (1 - n) - fbeta(V) * n);
end Gate;
