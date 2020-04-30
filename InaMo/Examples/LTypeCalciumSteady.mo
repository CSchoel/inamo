within InaMo.Examples;
model LTypeCalciumSteady "steady state of I_Ca,L, recreates Figures S1A-S1D from Inada 2009"
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  LTypeCalciumChannel cal;
  LTypeCalciumChannelN calN;
  ConstantConcentration ca(c_const=0);
  Real act_steady = cal.act.fsteady(v);
  Real act_steady_n = calN.act.fsteady(v);
  Real act_tau = cal.act.ftau(v);
  Real inact_steady = cal.inact_slow.fsteady(v);
  Real inact_tau_fast = cal.inact_fast.ftau(v);
  Real inact_tau_slow = cal.inact_slow.ftau(v);
  SI.Voltage v(start=-0.08, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, calN.p);
  connect(l2.n, calN.n);
  connect(ca.c, cal.c_sub);
  connect(ca.c, calN.c_sub);
annotation(
  experiment(StartTime = 0, StopTime = 140, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="act_steady|inact_steady|act_steady_n|act_tau|inact_tau_fast|inact_tau_slow|v|vc\\.v"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S1A and S1B from Inada 2009, plot act_steady and
      inact_steady against v.
      For Figure S1C and S1D, plot inact_tau_fast and inact_tau_slow
      against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -80 to 60 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end LTypeCalciumSteady;
