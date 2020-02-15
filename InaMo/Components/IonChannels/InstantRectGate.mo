within InaMo.Components.IonChannels;
model InstantRectGate "concentration-dependent gate which changes gating variable instantly"
  replaceable function fn = reciprocalRatioFit(x0=0.5);
  Real n = fn(c_ex) "ratio of molecules in open conformation";
  input SI.Concentration c_ex "external concentation of ion";
end InstantRectGate;
