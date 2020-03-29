within InaMo.Examples;
model HyperpolarizationActivatedSteady "steady state of I_f, recreates Figures S4A and S4B from Inada 2009"
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  HyperpolarizationActivatedChannel f;
  Real act_steady = f.act.fsteady(v);
  Real act_tau = f.act.ftau(v);
  SI.Voltage v(start=-0.12, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, f.p);
  connect(l2.n, f.n);
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S4A from Inada 2009, plot act_steady against v.
      For Figure S4B, plot act_tau against v.</p>
    </html>
  ")
);
end HyperpolarizationActivatedSteady;
