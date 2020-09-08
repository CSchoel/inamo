within InaMo.Components.IonCurrents;
model InstantGate "gate with instantaneous behavior"
  extends InaMo.Icons.Gate;
  outer parameter Real FoRT; // FIXME: this is only here to acoid a bug in OMC regarding lookup of outer variables
  replaceable function fn = scaledExpFit(x0=0, sx=1, sy=1) "function that defines behavior of gating variable n";
  Real n = fn(v_gate) "ratio of molecules in open conformation";
  outer SI.ElectricPotential v_gate "membrane potential";
end InstantGate;
