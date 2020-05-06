within InaMo.Examples;
model LTypeCalciumStep "response of I_Ca,L to a step from -40 mV to 10 mV, recreates figure 1H from inada 2009"
  LTypeCalciumChannel cal(g_max=21e-9);
  ConstantConcentration ca;
  LipidBilayer l2(use_init=false, c=40e-12);
  VoltageClamp vc(v_stim=if time < 1 then -0.04 else 0.01);
equation
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(cal.ca_sub, ca.c);
annotation(
  experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="vc\\.i"),
  Documentation(info="
    <html>
      <p>This example is required separately from LTypeCalciumIV and
      LTypeCalciumIVN, because it needs a much more fine grained step size to
      accurately show the current time course.</p>
      <p>To reproduce Figure S1H in Inada 2009 plot vc.i against time.</p>
      <p>NOTE: Inada et al. state that they used AN cells for plot S1H, but
      actual value of peak current suggests that parameters of NH cells were
      used instead.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow that the steady state is reached both
        before the step and after the step</li>
        <p>Tolerance is chosen to detect changes of a single picoampere.</p
        <li>Interval: accurately show time course of current</li>
      </ul>
    </html>
  ")
);
end LTypeCalciumStep;
