within InaMo.Examples;
model TransientOutwardSteady "steady state of I_to, recreates Figures S2A-S2D from Inada 2009"
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  TransientOutwardChannel to;
  Real act_steady = to.act.fsteady(v);
  Real act_tau = to.act.ftau(v);
  Real inact_steady = to.inact_slow.fsteady(v);
  Real inact_tau_fast = to.inact_fast.ftau(v);
  Real inact_tau_slow = to.inact_slow.ftau(v);
  SI.Voltage v(start=-0.12, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
annotation(
  experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S2A-S2D from Inada 2009, plot act_steady,
      inact_steady, inact_tau_fast and inact_tau_slow against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -120 to 80 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
        <li>Interval: enough to give a smooth plot</li>
      </ul>
    </html>
  ")
);
end TransientOutwardSteady;
