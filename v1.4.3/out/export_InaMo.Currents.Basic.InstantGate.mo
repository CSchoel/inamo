model InstantGate "gate with instantaneous behavior"
  extends InaMo.Icons.Gate;
  outer parameter Real FoRT;
  // FIXME: this is only here to acoid a bug in OMC regarding lookup of outer variables
  replaceable function fn = expFit(x0 = 0, sx = 1, sy = 1) "function that defines behavior of gating variable n";
  Real n = fn(v_gate) "ratio of molecules in open conformation";
  outer SI.ElectricPotential v_gate "membrane potential";
  annotation(
    Documentation(info = "<html>
  <p>This model can be used if gating (or similar) voltage-dependent behavior
  has to be described, but the kinetics are so fast that they can be assumed
  to instantaneously arrive at their steady state.</p>
</html>"));
end InstantGate;