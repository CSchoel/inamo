within InaMo.Components.IonChannels;
model InstantGate "gate with instantaneous behavior"
  replaceable function fn = scaledExpFit(x0=0, sx=1, sy=1) "function that defines behavior of gating variable n";
  Real n = fn(v_gate) "ratio of molecules in open conformation";
  outer SI.ElectricPotential v_gate "membrane potential";
end InstantGate;
