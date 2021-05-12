model TransientOutwardChannel "transient outward potassium current (I_to)"
  extends InaMo.Currents.Interfaces.IonChannelElectric(g_max = 20e-9);
  extends InaMo.Icons.Activatable;
  extends InaMo.Icons.Inactivatable;
  extends InaMo.Icons.Current(current_name = "I_to");
  // v_eq ~= -0.08696 V (calculated with nernst)
  GateTS act(redeclare function ftau = pseudoABTau(redeclare function falpha = expFit(x0 = -30.61e-3, sx = 0.09e3, sy = 1.037 / 3.188e-3), redeclare function fbeta = expFit(x0 = -23.84e-3, sx = -0.12e3, sy = 0.396 / 3.188e-3), off = 0.596e-3), redeclare function fsteady = genLogistic(x0 = 7.44e-3, sx = 1000 / 16.4)) "voltage-dependent activation";
  function inact_steady = genLogistic(x0 = -33.8e-3, sx = -1000 / 6.12);
  GateTS inact_slow(redeclare function ftau = gaussianAmp(y_min = 0.1, y_max = 4 + 0.1, x0 = -65e-3, sigma = sqrt(500 / 2) / 1000), redeclare function fsteady = inact_steady) "voltage-dependent slow inactivation";
  GateTS inact_fast(redeclare function ftau = genLogistic(y_min = 0.01266, y_max = 4.72716 + 0.01266, x0 = -154.5e-3, sx = -1000 / 23.96), redeclare function fsteady = inact_steady) "voltage-dependent fast inactivation";
  Real inact_total = 0.55 * inact_slow.n + 0.45 * inact_fast.n "total inactivation resulting from fast and slow inactivation gates";
equation
  open_ratio = act.n * inact_total;
  annotation(
    Documentation(info = "<html>
  <p>This model implements the equations for I_to in Inada 2009.</p>
  <p>NOTE: inact_fast.ftau.y_min is given as 0.1266 (126.6 ms) in Inada 2009,
  but this is inconsistent with plot S2C in the same article.
  We therefore suspect that this is an order of magnitude error and the
  value should be 0.01266 (12.66 ms) instead, which is also consistent with
  the C++ code.</p>
  <p>NOTE: inact_slow.ftau.y_min is given as 0.1 s and this value is also used
  in the C++ code.
  However, Figure S2D in Inada 2009 clearly shows a value around 0.2 s.
  We stick with 0.1 s, because we assume that Figure S2D may just use an old
  setting and we hope that the C++ code is the most accurate source with
  regard to actual simulation behavior.</p>
</html>"));
end TransientOutwardChannel;