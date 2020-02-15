within InaMo.Components.IonChannels;
model InstantGate "gate with instantaneous behavior"
  replaceable function fn = scaledExpFit(x0=0, sx=1, sy=1) "function that defines behavior of gating variable n";
  Real n = fn(v) "ratio of molecules in open conformation";
  input SI.ElectricPotential v "membrane potential";
end InstantGate;
