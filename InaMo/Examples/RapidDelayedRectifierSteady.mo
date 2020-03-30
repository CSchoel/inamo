within InaMo.Examples;
model RapidDelayedRectifierSteady "steady state of I_K,r, recreates figure S3A and S3B from Inada 2009"
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  RapidDelayedRectifierChannel kr;
  Real act_steady = kr.act_fast.fsteady(v);
  Real act_tau_fast = kr.act_fast.tau;
  Real act_tau_slow = kr.act_slow.ftau(v);
  Real inact_steady = kr.inact.fsteady(v);
  Real inact_tau = kr.inact.tau;
  SI.Voltage v(start=-0.12, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
annotation(
  experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S3A and S3B from Inada 2009, plot act_steady and
      act_tau_fast against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -120 mV to 80 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
      </ul>
    </html>
  ")
);
end RapidDelayedRectifierSteady;
